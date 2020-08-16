# Copyright 2019-2020 Zygmunt Krynicki.
#
# This file is part of zmk.
#
# Zmk is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License.
#
# Zmk is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with Zmk.  If not, see <https://www.gnu.org/licenses/>.

PVS.Sources ?= $(error define PVS.Sources - the list of source files to analyze with PVS Studio)

PLOG_CONVERTER_FLAGS ?=

# If we have pvs-studio then run it during static checks.
ifneq (,$(shell command -v pvs-studio 2>/dev/null))
static-check:: static-check-pvs
endif

.PHONY: static-check-pvs
static-check-pvs: $(addsuffix .PVS-Studio.log,$(PVS.Sources))
	$(strip plog-converter \
		--settings $(ZMK.SrcDir)/.pvs-studio.cfg \
		$(PLOG_CONVERTER_FLAGS) \
		--srcRoot $(ZMK.SrcDir) \
		--renderTypes errorfile $^ | srcdir=$(ZMK.SrcDir) abssrcdir=$(abspath $(ZMK.SrcDir)) awk -f $(ZMK.Path)/zmk/pvs-filter.awk)

pvs-report: $(addsuffix .PVS-Studio.log,$(PVS.Sources))
	$(strip plog-converter \
		--settings $(ZMK.SrcDir)/.pvs-studio.cfg \
		$(PLOG_CONVERTER_FLAGS) \
		--srcRoot $(ZMK.SrcDir) \
		--projectName $(NAME) \
		--projectVersion $(VERSION) \
		--renderTypes fullhtml \
		--output $@ \
		$^)

%.c.PVS-Studio.log: %.c.i ~/.config/PVS-Studio/PVS-Studio.lic | %.c
	$(strip pvs-studio \
		--cfg $(ZMK.SrcDir)/.pvs-studio.cfg \
		--i-file $< \
		--source-file $(firstword $|) \
		--output-file $@)

%.c.i: %.c
	$(strip $(CC) $(CPPFLAGS) $< -E -o $@)
%.cpp.i: %.cpp
	$(strip $(CXX) $(CPPFLAGS) $< -E -o $@)
%.m.i: %.m
	$(strip $(CC) $(CPPFLAGS) $< -E -o $@)

clean::
	rm -f *.i
	rm -f *.PVS-Studio.log
	rm -rf pvs-report
