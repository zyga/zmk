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

$(eval $(call ZMK.Import,Toolchain))
$(eval $(call ZMK.Import,OS))

BuildObjects.Variables=Sources Objects ObjectsC ObjectsCxx ObjectsObjC
define BuildObjects.Template
$1.Sources ?= $$(error define $1.Sources - the list of source files to compile)
$1.ObjectsC ?= $$(addsuffix .o,$$(addprefix $1-,$$(basename $$(filter %.c,$$($1.Sources)))))
$1.ObjectsCxx ?= $$(addsuffix .o,$$(addprefix $1-,$$(basename $$(filter %.cpp,$$($1.Sources)))))
$1.ObjectsObjC ?= $$(addsuffix .o,$$(addprefix $1-,$$(basename $$(filter %.m,$$($1.Sources)))))
$1.Objects ?= $$(strip $$($1.ObjectsC) $$($1.ObjectsCxx) $$($1.ObjectsObjC))

# This is how to compile each type of source files.
$$($1.ObjectsC): $1-%.o: %.c
	$$(strip $$(COMPILE.c) -o $$@ $$<)
$$($1.ObjectsCxx): $1-%.o: %.cpp
	$$(strip $$(COMPILE.cc) -o $$@ $$<)
$$($1.ObjectsObjC): $1-%.o: %.m
	$$(strip $$(COMPILE.m) -o $$@ $$<)

clean::
	rm -f $$($1.Objects)
ifneq (,$$(Toolchain.DependencyTracking))
	rm -f $$($1.Objects:.o=.d)
endif

ifneq (,$$(Toolchain.DependencyTracking))
-include $$($1.Objects:.o=.d)
endif

endef
