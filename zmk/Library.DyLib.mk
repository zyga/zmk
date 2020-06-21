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

$(eval $(call ZMK.Import,Directories))
$(eval $(call ZMK.Import,Toolchain))

Library.DyLib.Variables=Sources ExportList
define Library.DyLib.Template
# Compile library objects.
$1: CFLAGS += -fpic
$1: CXXFLAGS += -fpic
$1: OBJCFLAGS += -fpic
$$(eval $$(call ZMK.Expand,ObjectGroup,$1))

# We are building a dynamic library.
$1: LDFLAGS += -dynamiclib

# Provide current and compatibility version
# TODO: this is preliminary, implement the real thing
$1: LDFLAGS += -compatibility_version 1.0 -current_version 1.0

# If we have a list of exported symbols then switch symbol
# visibility to hidden and pass the list to the linker.
$1.ExportList ?= $$(warning should define $1.ExportList)
ifneq (,$$($1.ExportList))
$1: $$($1.ExportList)
$1: LDFLAGS += -fvisibility=hidden
$1: LDFLAGS += -exported_symbols_list=$$($1.ExportList)
endif

# Link library objects.
$1: $$($1.Objects)
	$$(strip $$(if $$($1.ObjectsObjC),$$(LINK.m),$$(if $$($1.ObjectsCxx),$$(LINK.cc),$$(LINK.o))) -o $$@ $$(filter %.o,$$^) $$(LDLIBS))

# Install library binary.
$1.InstallDir ?= $$(libdir)
$$(eval $$(call ZMK.Expand,InstallUninstall,$1))

# Install symlink (alias) to the versioned library.
$1.alias ?= $$(basename $$(basename $1)).dylib
$$($1.alias).InstallDir ?= $$($1.InstallDir)
$$($1.alias).SymlinkTarget = $1
$$(eval $$(call ZMK.Expand,Symlink,$$($1.alias)))

# React to "all" and "clean".
$$(eval $$(call ZMK.Expand,AllClean,$1))
$$(eval $$(call ZMK.Expand,AllClean,$$($1.alias)))
endef
