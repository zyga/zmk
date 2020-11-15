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
$(eval $(call ZMK.Import,Toolchain))
$(eval $(call ZMK.Import,OS))

ObjectGroup.Variables=Sources Objects ObjectsC ObjectsCxx ObjectsObjC
define ObjectGroup.Template
$1.Sources ?= $$(error define $1.Sources - the list of source files to compile)
$1.ObjectsC ?= $$(addsuffix .o,$$(addprefix $1-,$$(basename $$(filter %.c,$$($1.Sources)))))
$1.ObjectsCxx ?= $$(addsuffix .o,$$(addprefix $1-,$$(basename $$(filter %.cpp,$$($1.Sources)))))
$1.ObjectsObjC ?= $$(addsuffix .o,$$(addprefix $1-,$$(basename $$(filter %.m,$$($1.Sources)))))
$1.Objects ?= $$(strip $$($1.ObjectsC) $$($1.ObjectsCxx) $$($1.ObjectsObjC))
$1.SuggestedLinkerSymbol ?= $$(if $$($1.ObjectsObjC),OBJCLD,$$(if $$($1.ObjectsCxx),CXXLD,CCLD))

# Check if we have the required compiler.
$$(if $$(or $$($1.ObjectsC),$$($1.ObjectsObjC)),$$(if $$(Toolchain.CC.IsAvailable),,$$(error Building $1 requires a C compiler)))
$$(if $$($1.ObjectsCxx),$$(if $$(Toolchain.CXX.IsAvailable),,$$(error Building $1 requires a C++ compiler)))

# This is how to compile each type of source files.
$$($1.ObjectsC): $1-%.o: %.c
	$$(call Silent.Say,CC,$$@)
	$$(Silent.Command)$$(strip $$(COMPILE.c) -o $$@ $$<)
$$($1.ObjectsCxx): $1-%.o: %.cpp
	$$(call Silent.Say,CXX,$$@)
	$$(Silent.Command)$$(strip $$(COMPILE.cc) -o $$@ $$<)
$$($1.ObjectsObjC): $1-%.o: %.m
	$$(call Silent.Say,OBJC,$$@)
	$$(Silent.Command)$$(strip $$(COMPILE.m) -o $$@ $$<)

clean::
	$$(call Silent.Say,RM,$$($1.Objects))
	$$(Silent.Command)rm -f $$($1.Objects)
ifneq (,$$(Toolchain.DependencyTracking))
	$$(call Silent.Say,RM,$$($1.Objects:.o=.d))
	$$(Silent.Command)rm -f $$($1.Objects:.o=.d)
endif

ifneq (,$$(Toolchain.DependencyTracking))
-include $$($1.Objects:.o=.d)
endif

endef
