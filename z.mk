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

NAME ?= $(error define NAME - the name of the project)
VERSION ?= $(error define VERSION - the static version of the project)

# Speed up make by removing suffix rules.
.SUFFIXES:

# The location of the source code.
srcdir ?= .

# Version of the zmk library.
ZMK.Version = 0.2

# Location of include files used by the makefile system. Normally this is the
# zmk subdirectory of /usr/include, as this is where make is importing things
# from.
ZMK.z.mk := $(lastword $(MAKEFILE_LIST)))
ZMK.Path ?= $(dir $(ZMK.z.mk))

# Modules and templates present in the package
ZMK.modules = \
	Buildable \
	BuildObjects \
	Configure \
	Coverity \
	Directories \
	Directory \
	GitVersion \
	Header \
	Installable \
	Library.A \
	Library.DyLib \
	Library.So \
	ManPage \
	OS \
	Program \
	Program.Test \
	PVS \
	Script \
	Symlink \
	Tarball \
	Tarball.Src \
	Toolchain \
	Toolchain.Clang \
	Toolchain.GCC \
	Toolchain.OpenWatcom \
	Toolchain.Tcc

# Manual pages present in the package.
ZMK.manPages = \
	zmk.Directories.5 \
	zmk.OS.5 \
	zmk.Toolchain.5 \
	zmk.Buildable.5 \
	zmk.Program.5

# Files belonging to ZMK that need to be distributed in third-party release tarballs.
ZMK.DistFiles = z.mk $(addprefix zmk/,$(foreach m,$(ZMK.modules),$m.mk) pvs-filter.awk)

ifneq ($(NAME),zmk)
ifneq ($(ZMK.Path),$(srcdir)/)
$(srcdir)/zmk:
	install -d $@
$(srcdir)/zmk/%: $(ZMK.Path)zmk/% | $(srcdir)/zmk
	install -m 644 $< $@
$(srcdir)/z.mk: $(ZMK.Path)z.mk
	install -m 644 $< $@
endif
distclean::
	rm -rf $(srcdir)/zmk
	rm -f $(srcdir)/z.mk
endif

# ZMK Copyright Banner. Do not remove.
# You are not allowed to remove or alter this while staying compliant with the LGPL license.
MAKECMDGOALS ?=
ifeq ($(MAKECMDGOALS),)
$(info z.mk v$(ZMK.Version), Copyright (c) 2019-2020 Zygmunt Krynicki)
endif

# Meta-targets that don't have specific specific commands
.PHONY: $(sort all clean coverage fmt static-check check install uninstall dist distclean)

# Run static checkers when checking
check:: static-check

# Default goal is to build everything, regardless of declaration order
.DEFAULT_GOAL = all

# Display diagnostic messages when DEBUG has specific items.
ZMK.comma=,
DEBUG ?=
DEBUG := $(subst $(ZMK.comma), ,$(DEBUG))

# Define the module and template system.
ZMK.ImportedModules ?=
ZMK.expandStack = 0
ZMK.nesting.0 = > #
ZMK.nesting.1 = ... > #
ZMK.nesting.2 = ... ... > #
ZMK.nesting.3 = ... ... ... > #
ZMK.nesting.4 = ... ... ... ... > #

define ZMK.Import
ifeq (,$1)
$$(error incorrect call to ZMK.Import, expected module name)
endif
ifeq (,$$(filter $1,$$(ZMK.ImportedModules)))
$$(if $$(findstring import,$$(DEBUG)),$$(info DEBUG: importing »$1«))
include $$(ZMK.Path)zmk/$1.mk
ZMK.ImportedModules += $1
endif
endef


ZMK.variablesShown =
define ZMK.showVariable
ifeq (,$$(findstring $1,$$(ZMK.variablesShown)))
$$(info DEBUG: $$(ZMK.nesting.$$(ZMK.expandStack))$1=$$($1))
ZMK.variablesShown += $1
endif
endef

define ZMK.Expand
ifeq (,$1)
$$(error incorrect call to ZMK.Expand, expected module name)
endif
ifeq (,$2)
$$(error incorrect call to ZMK.Expand, expected variable name)
endif
$$(eval $$(call ZMK.Import,$1))
$$(if $$(findstring expand,$$(DEBUG)),$$(info DEBUG: $$(ZMK.nesting.$$(ZMK.expandStack))expanding template $1("$2")))
ZMK.expandStack := $$(shell expr $$(ZMK.expandStack) + 1)
$$(eval $$(call $1.Template,$2))
ZMK.expandStack := $$(shell expr $$(ZMK.expandStack) - 1)
$$(if $$(findstring expand,$$(DEBUG)),$$(foreach n,$$($1.Variables),$$(eval $$(call ZMK.showVariable,$2.$$n))))
endef
