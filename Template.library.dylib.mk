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

Template.library.dylib.variables=sources objects soname export-list
define Template.library.dylib.spawn
$1.sources ?= $$(error define $1.sources - the list of source files to compile as a library)
$1.objects ?= $$(patsubst %.c,$1-%.o,$$($1.sources))
$1.soname ?= $$(error define $1.soname - the name of the .dylib file, including version)
$1.export-list ?= $$(warning should define $1.export-list)
all:: $$($1.soname)
clean::
	rm -f $1 $$($1.soname)
install:: $$(DESTDIR)$$(libdir)/$1
install:: $$(DESTDIR)$$(libdir)/$$($1.soname)
uninstall::
	rm -f $$(DESTDIR)$$(libdir)/$1
	rm -f $$(DESTDIR)$$(libdir)/$$($1.soname)
$$($1.soname): LDFLAGS += -dynamiclib
# If we have a list of exported symbols then switch symbol
# visibility to hidden and pass the list to the linker.
ifneq (,$$($1.export-list))
$$($1.soname): LDFLAGS += -fvisibility=hidden -exported_symbols_list=$$($1.export-list)
$$($1.soname): $$($1.export-list)
endif
$$($1.soname): LDFLAGS += -compatibility_version 1.0 -current_version 1.0
$$($1.soname): $$($1.objects)
	$$(strip $$(LINK.o) $$(filter %.o,$$^) $$(LDLIBS) -o $$@)
$$($1.objects): $1-%.o: %.c
	$$(strip $$(COMPILE.c) -o $$@ $$<)
$1: | $$($1.soname)
	ln -s $$| $$@
$$(DESTDIR)$$(libdir)/$$($1.soname): $$($1.soname) | $$(DESTDIR)$$(libdir)
	install $$^ $$@
$(DESTDIR)$(libdir)/$1: | $(DESTDIR)$(libdir)/$$($1.soname)
	ln -s $$(notdir $$|) $$@
endef
