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

NAME ?= $(error define NAME)
VERSION ?= $(error define VERSION)

# Speed up make by removing suffix rules.
.SUFFIXES:

# The location of the source code.
srcdir ?= .

# Version of the zmk library.
ZMK.Version = 0.1
# Location of include files used by the makefile system. Normally this is the
# zmk subdirectory of /usr/include, as this is where make is importing things
# from.
ZMK.z.mk := $(lastword $(MAKEFILE_LIST)))
ZMK.Path ?= $(dir $(ZMK.z.mk))zmk/
# Modules and templates present in the package
ZMK._modules = \
				Module.OS \
				Module.configure \
				Module.coverity \
				Module.directories \
				Module.git-version \
				Module.pvs \
				Module.toolchain \
				Template.data \
				Template.header \
				Template.library.a \
				Template.library.dylib \
				Template.library.so \
				Template.manpage \
				Template.program \
				Template.program.script \
				Template.program.test \
				Template.tarball
# Files belonging to ZMK that need to be distributed in release tarballs.
ZMK.DistFiles = $(addprefix $(ZMK.Path),z.mk $(foreach m,$(ZMK._modules),$m.mk) pvs-filter.awk configure)

# ZMK Copyright Banner. Do not remove.
# You are not allowed to remove or alter this while stating compliant with the LGPL license.
ifeq ($(MAKECMDGOALS),)
$(info z.mk v$(ZMK.Version), Copyright (c) 2020-2020 Zygmunt Krynicki)
endif

# Meta-targets that don't have specific specific commands
.PHONY: $(sort all clean coverage fmt static-check check install uninstall dist distclean)

# Run static checkers when checking
check:: static-check

# Default goal is to build everything, regardless of declaration order
.DEFAULT_GOAL = all

# Display diagnostic messages when DEBUG has specific items.
_comma=,
DEBUG ?= 
DEBUG := $(subst $(_comma), ,$(DEBUG))

# List of imported modules.
ZMK.Modules ?=

# Define the module and template system.

define import
ifeq (,$1)
$$(error import, expected module name)
endif
ifeq (,$$(findstring $1,$$(ZMK.Modules)))
$$(if $$(findstring import,$$(DEBUG)),$$(info DEBUG: importing »$1«))
include $$(ZMK.Path)$1.mk
ZMK.Modules += $1
endif
endef

define spawn
ifeq (,$1)
$$(error spawn, expected module name)
endif
ifeq (,$2)
$$(error spawn, expected variable name)
endif
$$(eval $$(call import,$1))
$$(if $$(findstring spawn,$$(DEBUG)),$$(info DEBUG: spawning »$1« as »$2«))
$$(eval $$(call $1.spawn,$2))
$$(if $$(findstring spawn,$$(DEBUG)),$$(foreach n,$$($1.variables),$$(info DEBUG:     instance variable »$2«.$$n=$$($2.$$n))))
endef
