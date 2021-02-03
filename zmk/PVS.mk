# Copyright 2019-2021 Zygmunt Krynicki.
#
# This file is part of zmk.
#
# Zmk is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License version 3 as
# published by the Free Software Foundation.
#
# Zmk is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with Zmk.  If not, see <https://www.gnu.org/licenses/>.

$(eval $(call ZMK.Import,Silent))

# Sources are not re-defined with := so that they can expand lazily.
PVS.Sources ?= $(error define PVS.Sources - the list of source files to analyze with PVS Studio)
# NOTE: Strip out the out-of-tree-source-path so that all the $1.sources (note
# the lower-case) variables use source-relative paths. This is important when
# we want to derive object paths using source paths (same file with .o
# extension replaced but rooted at the build tree, not the source tree). When
# ZMK needs to support generated source files this should be changed.
PVS.sources = $(patsubst $(ZMK.OutOfTreeSourcePath)%,%,$(PVS.Sources))

PLOG_CONVERTER_FLAGS ?=

define PVS.PreProcess
$1.i: $$(ZMK.OutOfTreeSourcePath)$1 | $$(patsubst %/,%,$$(CURDIR)/$$(dir $1))
	$$(call Silent.Say,CPP,$$@)
	$$(Silent.Command)$$(strip $$(CPP) $$(CPPFLAGS) $$< -E $$(if $$(Toolchain.SysRoot),--sysroot=$$(Toolchain.SysRoot)) -o $$@)
endef

define PVS.Analyze
$1.PVS-Studio.log: $1.i ~/.config/PVS-Studio/PVS-Studio.lic | $$(ZMK.OutOfTreeSourcePath)$1
	$$(call Silent.Say,PVS-STUDIO,$$@)
	$$(Silent.Command)$$(strip pvs-studio \
		--cfg $$(ZMK.OutOfTreeSourcePath).pvs-studio.cfg \
		--i-file $$< \
		--source-file $$(firstword $$|) \
		--output-file $$@)
endef

# If we have pvs-studio then run it during static checks.
ifneq (,$(shell command -v pvs-studio 2>/dev/null))
static-check:: static-check-pvs
endif

.PHONY: static-check-pvs
static-check-pvs: $(addsuffix .PVS-Studio.log,$(PVS.sources))
	$(call Silent.Say,PLOG-CONVERTER,$@)
	$(Silent.Command)$(strip plog-converter \
		--settings $(ZMK.OutOfTreeSourcePath).pvs-studio.cfg \
		$(PLOG_CONVERTER_FLAGS) \
		--srcRoot $(ZMK.SrcDir) \
		--renderTypes errorfile $^ | srcdir=$(ZMK.SrcDir) abssrcdir=$(abspath $(ZMK.SrcDir)) awk -f $(ZMK.Path)/zmk/pvs-filter.awk)

$(foreach src,$(PVS.sources),$(eval $(call PVS.PreProcess,$(src))))
$(foreach src,$(PVS.sources),$(eval $(call PVS.Analyze,$(src))))

pvs-report: $(addsuffix .PVS-Studio.log,$(PVS.sources))
	$(call Silent.Say,PLOG-CONVERTER,$@)
	$(Silent.Command)$(strip plog-converter \
		--settings $(ZMK.OutOfTreeSourcePath).pvs-studio.cfg \
		$(PLOG_CONVERTER_FLAGS) \
		--srcRoot $(ZMK.SrcDir) \
		--projectName $(NAME) \
		--projectVersion $(VERSION) \
		--renderTypes fullhtml \
		--output $@ \
		$^)

clean::
	$(call Silent.Say,RM,*.i)
	$(Silent.Command)rm -f $(addsuffix .i,$(PVS.sources))
	$(call Silent.Say,RM,*.PVS-Studio.log)
	$(Silent.Command)rm -f $(addsuffix .PVS-Studio.log,$(PVS.sources))
	$(call Silent.Say,RM,pvs-report)
	$(Silent.Command)rm -rf pvs-report
