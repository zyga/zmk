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

NAME = zmk
VERSION = 0.3.1  # This needs to match ZMK.Version

# Use the local copy of zmk rather than the system-wide one.
ZMK.Path =
include ./z.mk

# Use git to augment version.
$(eval $(call ZMK.Import,GitVersion))
$(eval $(call ZMK.Import,Directories))

# Install all of zmk to the include directory.
$(foreach f,$(ZMK.DistFiles),$(eval $f.InstallDir=$(includedir)))
$(foreach f,$(ZMK.DistFiles),$(eval $(call ZMK.Expand,InstallUninstall,$f)))

# Install all of the manual pages, generating them from .in files first.
all:: $(foreach f,$(ZMK.manPages),man/$f)
clean::
	rm -f $(addprefix man/,$(ZMK.manPages))
ifneq ($(srcdir),.)
	test -d man && rmdir man || :
endif
$(CURDIR)/man: # For out-of-tree builds.
	install -d $@
man/%: man/%.in | $(CURDIR)/man
	sed -e 's/@VERSION@/$(VERSION)/g' $< >$@
$(foreach f,$(ZMK.manPages),$(eval $(call ZMK.Expand,ManPage,man/$f)))

# Build the release tarball.
$(NAME)_$(VERSION).tar.gz.Files = GNUmakefile README.md LICENSE NEWS
$(NAME)_$(VERSION).tar.gz.Files += $(addprefix man/,$(ZMK.manPages))
$(NAME)_$(VERSION).tar.gz.Files += $(addprefix examples/hello-c/,Makefile Test.mk hello.c)
$(NAME)_$(VERSION).tar.gz.Files += $(addprefix examples/hello-cpp/,Makefile Test.mk hello.cpp)
$(NAME)_$(VERSION).tar.gz.Files += $(addprefix examples/hello-objc/,Makefile Test.mk hello.m README.txt)
$(NAME)_$(VERSION).tar.gz.Files += $(addprefix examples/libhello-c/,Makefile Test.mk hello.c hello.h)
$(NAME)_$(VERSION).tar.gz.Files += $(addprefix examples/libhello-cpp/,Makefile Test.mk hello.cpp hello.h)
$(NAME)_$(VERSION).tar.gz.Files += $(addprefix examples/libhello-objc/,Makefile Test.mk hello.m hello.h)
$(NAME)_$(VERSION).tar.gz.Files += $(addprefix examples/true_false/,Makefile Test.mk true_false.c README.txt)
$(NAME)_$(VERSION).tar.gz.Files += $(addprefix examples/script/,Makefile Test.mk hello.sh)
$(NAME)_$(VERSION).tar.gz.Files += $(addprefix tests/Configure/,Makefile Test.mk)
$(NAME)_$(VERSION).tar.gz.Files += $(addprefix tests/Directories/,Makefile Test.mk)
$(NAME)_$(VERSION).tar.gz.Files += $(addprefix tests/Directory/,Makefile Test.mk)
$(NAME)_$(VERSION).tar.gz.Files += $(addprefix tests/Header/,Makefile Test.mk foo.h)
$(NAME)_$(VERSION).tar.gz.Files += $(addprefix tests/Library.A/,Makefile Test.mk foo.c)
$(NAME)_$(VERSION).tar.gz.Files += $(addprefix tests/Library.DyLib/,Makefile Test.mk foo.c)
$(NAME)_$(VERSION).tar.gz.Files += $(addprefix tests/Library.So/,Makefile Test.mk foo.c)
$(NAME)_$(VERSION).tar.gz.Files += $(addprefix tests/ManPage/,Makefile Test.mk foo.1 foo.2 foo.3 foo.4 foo.5 foo.6 foo.7 foo.8 foo.9)
$(NAME)_$(VERSION).tar.gz.Files += $(addprefix tests/OS/,Makefile Test.mk)
$(NAME)_$(VERSION).tar.gz.Files += $(addprefix tests/Program/,Makefile Test.mk foo.c bar.cpp froz.m)
$(NAME)_$(VERSION).tar.gz.Files += $(addprefix tests/Symlink/,Makefile Test.mk)
$(NAME)_$(VERSION).tar.gz.Files += $(addprefix tests/Tarball.Src/,Makefile Test.mk foo.txt)
$(NAME)_$(VERSION).tar.gz.Files += $(addprefix tests/Toolchain/,Makefile Test.mk)
$(NAME)_$(VERSION).tar.gz.Files += tests/bin/GREP
$(eval $(call ZMK.Expand,Tarball.Src,$(NAME)_$(VERSION).tar.gz))


#check-examples = $(addprefix check,$(subst /,-,$(subst $(srcdir)/,/,$(wildcard $(srcdir)/examples/*))))
#check:: $(check-examples)
#$(check-examples): check-examples-%:
#	$(MAKE) -I $(abspath $(srcdir)) --warn-undefined-variables -C $(srcdir)/examples/$* clean
#	$(MAKE) -I $(abspath $(srcdir)) --warn-undefined-variables -C $(srcdir)/examples/$* all
#	rm -rf /tmp/zmk-example-$*
#	$(MAKE) -I $(abspath $(srcdir)) --warn-undefined-variables -C $(srcdir)/examples/$* install DESTDIR=/tmp/zmk-example-$*


check:: check-unit

# Some hackery is performed to map slashes to dashes, except in "(lib)?hello-".
tests = $(patsubst -%-,%,$(subst /,-,$(subst $(srcdir)/,/,$(dir $(shell find . -name Test.mk)))))
.PHONY: check-unit
check-unit: $(addprefix check-,$(tests))
.PHONY: $(addprefix check-,$(tests))
$(addprefix check-,$(tests)): check-%:
	$(MAKE) \
		--no-print-directory --warn-undefined-variables \
		-I $(abspath $(srcdir)) \
		-C $(srcdir)/$(patsubst examples/libhello/%,examples/libhello-%,$(patsubst examples/hello/%,examples/hello-%,$(subst -,/,$*))) \
		-f Test.mk
