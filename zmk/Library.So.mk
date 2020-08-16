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

$(eval $(call ZMK.Import,Silent))
$(eval $(call ZMK.Import,Directories))
$(eval $(call ZMK.Import,Toolchain))

Library.So.Variables=Sources SoName InstallDir VersionScript
define Library.So.Template

# Compile library objects.
$1: CFLAGS += -fpic
$1: CXXFLAGS += -fpic
$1: OBJCFLAGS += -fpic
$$(eval $$(call ZMK.Expand,ObjectGroup,$1))

# Watcom doesn't build dynamic libraries.
ifneq (,$$(Toolchain.$$(if $$($1.ObjectsObjC),CC,$$(if $$($1.ObjectsCxx),CXX,CC)).IsWatcom))
$$(error Watcom does not support shared libraries))
endif # watcom

# We are building a shared library.
$1: LDFLAGS += -shared

# If we have a soname then store it in the shared library.
$1.SoName ?= $1
ifneq (,$$($1.SoName))
$1: LDFLAGS += -Wl,-soname=$$($1.SoName)
endif # soname
#
# If we have a version script switch symbol visibility to hidden
# and use the version script to define precise version mapping.
$1.VersionScript ?= $$(warning define $1.VersionScript - the name of a ELF symbol map)
ifneq (,$$($1.VersionScript))
# Tcc does not support version scripts.
#
ifeq (,$$(Toolchain.$$(if $$($1.ObjectsObjC),CC,$$(if $$($1.ObjectsCxx),CXX,CC)).IsTcc))
$1: $$($1.VersionScript)
$1: LDFLAGS += -fvisibility=hidden
$1: LDFLAGS += -Wl,--version-script=$$($1.VersionScript)
endif # !tcc
endif # VersionScript

# Link library objects.
$1: $$($1.Objects)
	$$(call Silent.Say2,$$($1.SuggestedLinkerSymbol),$$@)
	$$(Silent.Command)$$(strip $$(if $$($1.ObjectsObjC),$$(LINK.m),$$(if $$($1.ObjectsCxx),$$(LINK.cc),$$(LINK.o))) -o $$@ $$(filter %.o,$$^) $$(LDLIBS))

# Install library binary.
$1.InstallDir ?= $$(libdir)
$$(eval $$(call ZMK.Expand,InstallUninstall,$1))

# React to "all" and "clean".
$$(eval $$(call ZMK.Expand,AllClean,$1))

# Create symlink (alias) to the versioned library.
$1.alias = $$(basename $1)
$$($1.alias).InstallDir ?= $$($1.InstallDir)
$$($1.alias).SymlinkTarget = $1
$$(eval $$(call ZMK.Expand,Symlink,$$($1.alias)))
endef
