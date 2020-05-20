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

$(eval $(call import,Module.directories))
$(eval $(call import,Module.toolchain))
$(eval $(call import,Module.OS))

Template.program.variables=sources objects c_objects cpp_objects objc_objects install_dir
define Template.program.spawn
$1.sources ?= $$(error define $1.sources - the list of source files to compile as a program)
$1.c_objects ?= $$(addsuffix .o,$$(addprefix $1-,$$(basename $$(filter %.c,$$($1.sources)))))
$1.cpp_objects ?= $$(addsuffix .o,$$(addprefix $1-,$$(basename $$(filter %.cpp,$$($1.sources)))))
$1.objc_objects ?= $$(addsuffix .o,$$(addprefix $1-,$$(basename $$(filter %.m,$$($1.sources)))))
$1.objects ?= $$($1.c_objects) $$($1.cpp_objects) $$($1.objc_objects)
$1.install_dir ?= $$(bindir)
$1.install_mode ?= 0755

# If we have some Objective C in the mix then there is some extra complexity.
# There are two degrees of freedom here, each with discrete steps. On one axis
# we may use Darwin's ObjC 2.0 stack or the 1.x GNU Step stack (!Darwin).
# On the other axis Objective C code can eithe link to nothing but the ObjC
# runtime (bare), it can link to the Foundation library (base) or to Cocoa
# (gui). This is captured by the $1.objc_kind variable that must be set if ObjC
# is used.
ifneq (,$$($1.objc_objects))
ifeq ($$(OS),Darwin)
# COMPILE.m expands to COMPILE.c on Darwin, it doesn't use OBJCFLAGS,
# so we use CFLAGS instead.
$1$$(exe): CFLAGS += -ObjC
# The author need to pass -frameowork Foundation or -framework Cocoa.
$1$$(exe): LDLIBS += -lobjc
else
$1$$(exe): OBJCFLAGS += $$(shell gnustep-config --objc-flags)
# The author need to use $$(shell gnustep-config --base-libs) or
# $$(shell gnustep-config --gui-libs) explicitly. This is not done here.
$1$$(exe): LDLIBS += $$(shell gnustep-config --objc-libs)
endif # !Darwin
endif # no objc objects

$1$$(exe).install_dir ?= $$($1.install_dir)
$1$$(exe).install_mode ?= $$($1.install_mode)
$$(eval $$(call spawn,Template.data,$1$$(exe)))

all:: $1$$(exe)
clean::
	rm -f $1$$(exe) $1-*.o

ifneq (,$$(or $$(is_gcc),$$(is_clang)))
$1$$(exe): LDFLAGS += -fPIE
endif
$1$$(exe): $$($1.objects)
ifneq (,$$($1.objc_objects))
	$$(strip $$(LINK.m) -o $$@ $$^ $$(LDLIBS))
else
ifneq (,$$($1.cpp_objects))
	$$(strip $$(LINK.cc) -o $$@ $$^ $$(LDLIBS))
else
	$$(strip $$(LINK.o) -o $$@ $$^ $$(LDLIBS))
endif
endif


$$($1.c_objects): $1-%.o: %.c
	$$(strip $$(COMPILE.c) -o $$@ $$<)
$$($1.cpp_objects): $1-%.o: %.cpp
	$$(strip $$(COMPILE.cc) -o $$@ $$<)
$$($1.objc_objects): $1-%.o: %.m
	$$(strip $$(COMPILE.m) -o $$@ $$<)
endef
