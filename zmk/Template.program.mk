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

Template.program.variables=sources objects install_dir
define Template.program.spawn
$1.sources ?= $$(error define $1.sources - the list of source files to compile as a program)
$1.objects ?= $$(patsubst %.c,$1-%.o,$$($1.sources))
$1.install_dir ?= $$(bindir)
$1.install_mode ?= 0755

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
	$$(strip $$(LINK.o) -o $$@ $$^ $$(LDLIBS))
$$($1.objects): $1-%.o: %.c
	$$(strip $$(COMPILE.c) -o $$@ $$<)
endef
