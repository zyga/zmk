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

Template.library.a.variables=sources objects
define Template.library.a.spawn
ifneq ($$(suffix $1),.a)
$$(error $1 must end with ".a")
endif
$1.sources ?= $$(error define $1.sources)
$1.objects ?= $$(patsubst %.c,$1-%.o,$$(filter %.c,$$($1.sources)))

all:: $1
clean::
	rm -f $1
uninstall::
	rm -f $$(DESTDIR)$$(libdir)/$1
install:: $$(DESTDIR)$$(libdir)/$1

$1: $$($1.objects)
	$$(AR) $$(ARFLAGS) $$@ $$^
$$($1.objects): $1-%.o: %.c
	$$(strip $$(COMPILE.c) -o $$@ $$<)
$$(DESTDIR)$$(libdir)/$1: $1 | $$(DESTDIR)$$(libdir)
	install $$^ $$@
endef
