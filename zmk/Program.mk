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
$(eval $(call ZMK.Import,OS))

Program.Variables=Sources InstallDir InstallMode Linker
define Program.Template
# Compile program objects.
$$(eval $$(call ZMK.Expand,BuildObjects,$1))

$1.Linker ?= $$(if $$($1.ObjectsObjC),$$(CC),$$(if $$($1.ObjectsCxx),$$(CXX),$$(CC)))

# Link program objects.
ifneq (,$$($1.ObjectsObjC))
$1$$(exe): LDLIBS += -lobjc
endif # no objective C objects
$1$$(exe): $$($1.Objects)
	$$(strip $$(if $$($1.ObjectsObjC),$$(LINK.m),$$(if $$($1.ObjectsCxx),$$(LINK.cc),$$(LINK.o))) -o $$@ $$^ $$(LDLIBS))

# Install program binary.
$1.InstallDir ?= $$(bindir)
$1.InstallMode ?= 0755
$1.InstallName ?= $$(if $$(Configure.ProgramTransformName),$$(shell echo '$$(Configure.ProgramPrefix)$$(notdir $1)$$(Configure.ProgramSuffix)' | sed -e '$$(Configure.ProgramTransformName)'),$$(Configure.ProgramPrefix)$$(notdir $1)$$(Configure.ProgramSuffix))
$1$$(exe).InstallDir ?= $$($1.InstallDir)
$1$$(exe).InstallMode ?= $$($1.InstallMode)
$1$$(exe).InstallName ?=  $$($1.InstallName)
$$(eval $$(call ZMK.Expand,Installable,$1$$(exe)))

# React to "all" and "clean".
$$(eval $$(call ZMK.Expand,Buildable,$1$$(exe)))
endef
