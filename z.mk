# Copyright 2019-2021 Zygmunt Krynicki.
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

ifneq ($(value NAME),)
Project.Name ?= $(NAME)
else
Project.Name ?=
endif
NAME ?= $(or $(Project.Name),$(error define NAME - the name of the project))

ifneq ($(value VERSION),)
Project.Version ?= $(VERSION)
else
Project.Version ?=
endif
VERSION ?= $(or $(Project.Version),$(error define VERSION - the static version of the project))

# Speed up make by removing suffix rules.
.SUFFIXES:

# Version of the zmk library.
ZMK.Version = 0.4.2

# Location of include files used by the makefile system. Normally this is the
# zmk subdirectory of /usr/include, as this is where make is importing things
# from.
ZMK.z.mk := $(lastword $(MAKEFILE_LIST))
ZMK.Path ?= $(or $(patsubst %/,%,$(dir $(ZMK.z.mk))),.)

# Modules and templates present in the package
ZMK.modules = \
	AllClean \
	ClangAnalyzer \
	ClangTidy \
	Configure \
	Coverity \
	CppCheck \
	Directories \
	Directory \
	GitVersion \
	Header \
	HeaderGroup \
	InstallUninstall \
	Library.A \
	Library.DyLib \
	Library.So \
	ManPage \
	OS \
	ObjectGroup \
	PVS \
	Program \
	Program.Test \
	Script \
	Silent \
	Sparse \
	Symlink \
	Tarball \
	Tarball.Src \
	Toolchain \
	internalTest \
	toolchain.Clang \
	toolchain.GCC \
	toolchain.Tcc \
	toolchain.Watcom

# Files belonging to ZMK that need to be distributed in third-party release tarballs.
ZMK.DistFiles = z.mk $(addprefix zmk/,$(foreach m,$(ZMK.modules),$m.mk) pvs-filter.awk)

# Temporary directory, used by distcheck.
TMPDIR ?= /tmp

# The location of the source code.
ZMK.SrcDir ?= .

# Are we building out-of-tree
ifneq ($(ZMK.SrcDir),.)
ZMK.IsOutOfTreeBuild = yes
ZMK.OutOfTreeSourcePath = $(ZMK.SrcDir)/
VPATH = $(ZMK.SrcDir)
else
ZMK.IsOutOfTreeBuild =
ZMK.OutOfTreeSourcePath =
endif


# ZMK Copyright Banner. Do not remove.
# You are not allowed to remove or alter this while staying compliant with the LGPL license.
# You can disable it by setting ZMK.NoBanner=1 on command line.
MAKECMDGOALS ?=
ZMK.NoBanner ?=
ifeq ($(or $(ZMK.NoBanner),$(MAKECMDGOALS)),)
$(info z.mk v$(ZMK.Version), Copyright (c) 2019-2021 Zygmunt Krynicki)
endif

# Meta-targets that don't have specific specific commands
.PHONY: $(sort all clean coverage fmt static-check check install uninstall dist distclean distcheck)

# Dist-clean is a super-set of clean.
distclean:: clean

# Run static checks when checking
check:: static-check

# Default goal is to build everything, regardless of declaration order
.DEFAULT_GOAL = all

# Some weird Make quirks. Depending on MAKE version, it's hard to use literal
# hash but it's possible to expand ZMK.hash to it reliably.
ZMK.hash=\#
# Comma is also hard to use directly.
ZMK.comma=,
# Newline is just hard to define.
define ZMK.newline


endef
# Boolean negation function
ZMK.not=$(if $1,,yes)
DEBUG ?=
# Display diagnostic messages when DEBUG has specific items.
DEBUG := $(subst $(ZMK.comma), ,$(DEBUG))

# Define the module and template system.
ZMK.ImportedModules ?=
ZMK.expandStack = 0
ZMK.nesting.0 = > #
ZMK.nesting.1 = ... > #
ZMK.nesting.2 = ... ... > #
ZMK.nesting.3 = ... ... ... > #
ZMK.nesting.4 = ... ... ... ... > #
ZMK.nesting.5 = ... ... ... ... ... > #
ZMK.nesting.6 = ... ... ... ... ... ... > #
ZMK.nesting.7 = ... ... ... ... ... ... ... > #
ZMK.nesting.8 = ... ... ... ... ... ... ... ... > #
ZMK.nesting.9 = ... ... ... ... ... ... ... ... ... > #
ZMK.nesting.10 = ... ... ... ... ... ... ... ... ... ... > #
ZMK.nesting.11 = ... ... ... ... ... ... ... ... ... ... ... > #
ZMK.nesting.12 = ... ... ... ... ... ... ... ... ... ... ... ... > #
ZMK.nesting.13 = ... ... ... ... ... ... ... ... ... ... ... ... ... > #
ZMK.nesting.14 = ... ... ... ... ... ... ... ... ... ... ... ... ... ... > #
ZMK.nesting.15 = ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... > #

define ZMK.Import
ifeq (,$1)
$$(error incorrect call to ZMK.Import, expected module name)
endif
ifeq (,$$(filter $1,$$(ZMK.ImportedModules)))
$$(if $$(findstring import,$$(DEBUG)),$$(info DEBUG: importing »$1«))
ZMK.ImportedModules += $1
include $$(ZMK.Path)/zmk/$1.mk
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
