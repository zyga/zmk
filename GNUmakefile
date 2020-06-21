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
VERSION = 0.2  # This needs to match ZMK.Version

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
$(NAME)_$(VERSION).tar.gz.Files += examples/hello-c/hello.c examples/hello-c/Makefile examples/hello-c/Test.mk
$(NAME)_$(VERSION).tar.gz.Files += examples/hello-cpp/hello.cpp examples/hello-cpp/Makefile examples/hello-cpp/Test.mk
$(NAME)_$(VERSION).tar.gz.Files += examples/hello-objc/hello.m examples/hello-objc/Makefile examples/hello-objc/Test.mk examples/hello-objc/README.txt
$(NAME)_$(VERSION).tar.gz.Files += examples/libhello-c/hello.c examples/libhello-c/hello.h examples/libhello-c/Makefile examples/libhello-c/Test.mk
$(NAME)_$(VERSION).tar.gz.Files += examples/libhello-cpp/hello.cpp examples/libhello-cpp/hello.h examples/libhello-cpp/Makefile examples/libhello-cpp/Test.mk
$(NAME)_$(VERSION).tar.gz.Files += examples/libhello-objc/hello.m examples/libhello-objc/hello.h examples/libhello-objc/Makefile examples/libhello-objc/Test.mk
$(NAME)_$(VERSION).tar.gz.Files += examples/true_false/true_false.c examples/true_false/Makefile examples/true_false/Test.mk examples/true_false/README.txt
$(NAME)_$(VERSION).tar.gz.Files += tests/Directories/Makefile tests/Directories/Test.mk
$(NAME)_$(VERSION).tar.gz.Files += tests/Directory/Makefile tests/Directory/Test.mk
$(NAME)_$(VERSION).tar.gz.Files += tests/OS/Makefile tests/OS/Test.mk
$(NAME)_$(VERSION).tar.gz.Files += tests/Toolchain/Makefile tests/Toolchain/Test.mk
$(NAME)_$(VERSION).tar.gz.Files += tests/bin/MATCH
$(NAME)_$(VERSION).tar.gz.Files += tests/Common.mk
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
