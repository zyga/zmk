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

ifeq (,$(Project.Name))
$(error define Project.Name - name of the project for the zmk configure system)
endif

Probe.NamePrefix = .zmk-probe.

config.$(Project.Name).h:
	$(call Silent.Say,GENERATE,$@)
	$(Silent.Command)(	\
		echo "#ifndef CONFIG_H"; \
		echo "#define CONFIG_H"; \
		cat $(sort $^); \
		echo "#endif /* CONFIG_H */"; \
	) >$@

clean::
	$(call Silent.Say,RM,$(Probe.NamePrefix)*)
	$(Silent.Command)rm -f $(Probe.NamePrefix)*

Probe.Variables=Macro ProbeProgramText ProbeExtension
define Probe.Template
$1.Macro ?= $$(error define $1.Macro - name of the preprocessor macro to associate with probe outcome)
$1.ProbeProgramText ?= $$(error define $1.ProbeProgramText - text of the probe program, using define $1.ProbeProgramText/endef pair)
$1.ProbeExtension ?= .c
$1.probeSourceFile ?= $$(Probe.NamePrefix)$1$$($1.ProbeExtension)

$$($1.probeSourceFile): export ZMK_PROBE_PROGRAM_TEXT = $$($1.ProbeProgramText)
$$($1.probeSourceFile):
	$$(call Silent.Say,GENERATE,$$@)
	@echo "$$$${ZMK_PROBE_PROGRAM_TEXT}" >$$@

# Add a rule to compile the program.
# TODO: optimize Program template for single-source programs to avoid intermediate .o file.
$$(Probe.NamePrefix)$1.Sources = $$($1.probeSourceFile)
$$(Probe.NamePrefix)$1.InstallDir = noinst
$$(eval $$(call ZMK.Expand,Program,$$(Probe.NamePrefix)$1))

# The 043 below is the octal value of just "#" but to avoid Make parsing
# differences across versions, we synthesize it with printf instead.
$$(Probe.NamePrefix)$1.h: $$($1.probeSourceFile)
	$$(if $$($1.Info),$$(Silent.Command)printf '/* %s */\n' '$$($1.Info)' >$$@)
	$$(Silent.Command)if $$(MAKE) --quiet $$(Probe.NamePrefix)$1$$(exe); then \
		printf '\043define %s 1\n' '$$($1.Macro)' >>$$@; \
	else \
		printf '/* %s is not defined */\n' '$$($1.Macro)' >>$$@; \
	fi
	$$(call Silent.Say,GENERATE,$$@)

# Inject dependency for the concatenated header file.
config.$$(Project.Name).h: $$(Probe.NamePrefix)$1.h
endef
