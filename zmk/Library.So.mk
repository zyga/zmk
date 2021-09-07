# SPDX-FileCopyrightText: 2019-2024 Zygmunt Krynicki
# SPDX-License-Identifier: LGPL-3.0-only
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
$(eval $(call ZMK.Import,Directories))
$(eval $(call ZMK.Import,Toolchain))

Library.So.Variables=Sources SoName InstallDir VersionScript
define Library.So.Template
ifeq ($(Configure.DynamicLibraries),yes)

# Compile library objects.
$1: CFLAGS += -fpic
$1: CXXFLAGS += -fpic
$1: OBJCFLAGS += -fpic
$$(eval $$(call ZMK.Expand,ObjectGroup,$1))
$1.alias ?= $$(word 1,$$(subst ., ,$1)).so
$1.SoName ?= $1
ifneq ($1,$$($1.alias))
$1.VersionScript ?= $$(warning define $1.VersionScript - the name of a ELF symbol map)
else
$1.VersionScript ?=
endif

# Common dynamic/shared library meta-data.
# We are building a shared library.
$1: LDFLAGS += -shared
# Pass -soname to the linker, if we have a version handy.
$1: LDFLAGS += $(if $$($1.SoName),-Wl$$(ZMK.comma)-soname=$$($1.SoName))

# Watcom doesn't build dynamic libraries.
ifneq (,$$(Toolchain.$$(if $$($1.ObjectsObjC),CC,$$(if $$($1.ObjectsCxx),CXX,CC)).IsWatcom))
$$(error Watcom does not support shared libraries))
endif # watcom

# Symbol export control
ifneq (,$$($1.VersionScript))
# Tcc does not support version scripts.
ifeq (,$$(Toolchain.$$(if $$($1.ObjectsObjC),CC,$$(if $$($1.ObjectsCxx),CXX,CC)).IsTcc))
# If we have precise information about symbol export then switch default symbol
# visibility to hidden and use the explicit list to control public symbols.
$1: $$($1.VersionScript)
$1: LDFLAGS += -fvisibility=hidden -Wl,--version-script=$$($1.VersionScript)
endif # !tcc
endif # !symbol export control

# Link library objects.
$1: $$($1.Objects)
	$$(call Silent.Say,$$($1.SuggestedLinkerSymbol),$$@)
	$$(Silent.Command)$$(strip $$(if $$($1.ObjectsObjC),$$(LINK.m),$$(if $$($1.ObjectsCxx),$$(LINK.cc),$$(LINK.o))) $$(if $$(Toolchain.SysRoot),--sysroot=$$(Toolchain.SysRoot)) -o $$@ $$(filter %.o,$$^) $$(LDLIBS))

# Install library binary.
$1.InstallDir ?= $$(libdir)
$$(eval $$(call ZMK.Expand,InstallUninstall,$1))

# React to "all" and "clean".
$$(eval $$(call ZMK.Expand,AllClean,$1))

# Create symlink (alias) to the versioned library.
ifneq ($1,$$($1.alias))
$$($1.alias).InstallDir ?= $$($1.InstallDir)
$$($1.alias).SymlinkTarget = $1
$$(eval $$(call ZMK.Expand,Symlink,$$($1.alias)))
endif

endif # Configure.DynamicLibraries
endef
