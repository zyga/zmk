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

Template.library.so.variables=sources objects soname version-script
define Template.library.so.spawn
$1.sources ?= $$(error define $1.sources - the list of source files to compile as a library)
$1.objects ?= $$(patsubst %.c,$1-%.o,$$($1.sources))
$1.soname ?= $$(error define $1.soname - the name of the .so file, including version)
$1.version-script ?= $$(warning define $1.version-script - the name of a ELF symbol map)
# Watcom doesn't build dynamic libraries.
ifeq (,$(is_watcom))
all:: $$($1.soname)
clean::
	rm -f $1 $$($1.soname)
install:: $$(DESTDIR)$$(libdir)/$1
install:: $$(DESTDIR)$$(libdir)/$$($1.soname)
uninstall::
	rm -f $$(DESTDIR)$$(libdir)/$1
	rm -f $$(DESTDIR)$$(libdir)/$1.1
$$($1.soname): LDFLAGS += -shared
$$($1.soname): CFLAGS += -fPIC
# If we have a soname then store it in the shared library.
ifneq (,$$($1.soname))
$$($1.soname): LDFLAGS += -Wl,-soname=$$($1.soname)
endif
# If we have a version script switch symbol visibility to hidden
# and use the version script to define precise version mapping.
ifneq (,$$($1.version-script))
# Tcc does not support version scripts.
ifeq (,$$(is_tcc))
$$($1.soname): $$($1.version-script)
$$($1.soname): LDFLAGS += -fvisibility=hidden
$$($1.soname): LDFLAGS += -Wl,--version-script=$$($1.version-script)
endif # !is_tcc
endif # version-script
$$($1.soname): $$($1.objects)
	$$(strip $$(LINK.o) -o $$@ $$(filter %.o,$$^) $$(LDLIBS))
$$($1.objects): $1-%.o: %.c
	$$(strip $$(COMPILE.c) -o $$@ $$<)
$1: | $$($1.soname)
	ln -s $$| $$@
$$(DESTDIR)$$(libdir)/$$($1.soname): $$($1.soname) | $$(DESTDIR)$$(libdir)
	install $$^ $$@
$$(DESTDIR)$$(libdir)/$1: | $$(DESTDIR)$$(libdir)/$$($1.soname)
	ln -s $$(notdir $$|) $$@
endif # !is_watcom
endef
