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
VERSION = 0.3.8  # This needs to match ZMK.Version

ZMK.SrcDir ?= .
-include GNUmakefile.configure.mk
ZMK.Path = $(ZMK.SrcDir)
include $(ZMK.Path)/z.mk

# Use git to augment version.
$(eval $(call ZMK.Import,GitVersion))
$(eval $(call ZMK.Import,Directories))
$(eval $(call ZMK.Import,Configure))

# Install all of zmk to the sub-directory in the include directory.
# Except for z.mk itself, which should live there directly.
$(foreach f,$(ZMK.DistFiles),$(eval $f.InstallDir=$(includedir)/zmk))
z.mk.InstallDir=$(includedir)
$(foreach f,$(ZMK.DistFiles),$(eval $(call ZMK.Expand,InstallUninstall,$f)))

# Install all of the manual pages, generating them from .in files first.
all:: $(foreach f,$(ZMK.manPages),man/$f)
clean::
	rm -f $(addprefix man/,$(ZMK.manPages))
ifneq ($(ZMK.SrcDir),.)
	test -d man && rmdir man || :
endif
$(CURDIR)/man: # For out-of-tree builds.
	install -d $@
man/%: man/%.in | $(CURDIR)/man
	sed -e 's/@VERSION@/$(VERSION)/g' $< >$@
$(foreach f,$(ZMK.manPages),$(eval $(call ZMK.Expand,ManPage,man/$f)))

# Build the release tarball.
ZMK.releaseArchive?=$(NAME)_$(VERSION).tar.gz
$(ZMK.releaseArchive).Files = GNUmakefile README.md LICENSE NEWS
$(ZMK.releaseArchive).Files += $(addsuffix .in,$(addprefix man/,$(ZMK.manPages)))
$(ZMK.releaseArchive).Files += $(addprefix examples/hello-c/,Makefile Test.mk hello.c)
$(ZMK.releaseArchive).Files += $(addprefix examples/hello-cpp/,Makefile Test.mk hello.cpp)
$(ZMK.releaseArchive).Files += $(addprefix examples/hello-objc/,Makefile Test.mk hello.m README.txt)
$(ZMK.releaseArchive).Files += $(addprefix examples/libhello-c/,Makefile Test.mk hello.c hello.h)
$(ZMK.releaseArchive).Files += $(addprefix examples/libhello-cpp/,Makefile Test.mk hello.cpp hello.h)
$(ZMK.releaseArchive).Files += $(addprefix examples/libhello-objc/,Makefile Test.mk hello.m hello.h)
$(ZMK.releaseArchive).Files += $(addprefix examples/true_false/,Makefile Test.mk true_false.c README.txt)
$(ZMK.releaseArchive).Files += $(addprefix examples/script/,Makefile Test.mk hello.sh)
$(ZMK.releaseArchive).Files += $(addprefix tests/Configure/,Makefile Test.mk)
$(ZMK.releaseArchive).Files += $(addprefix tests/Directories/,Makefile Test.mk)
$(ZMK.releaseArchive).Files += $(addprefix tests/Directory/,Makefile Test.mk)
$(ZMK.releaseArchive).Files += $(addprefix tests/Header/,Makefile Test.mk foo.h include/bar.h)
$(ZMK.releaseArchive).Files += $(addprefix tests/Library.A/,Makefile Test.mk foo.c)
$(ZMK.releaseArchive).Files += $(addprefix tests/Library.DyLib/,Makefile Test.mk foo.c)
$(ZMK.releaseArchive).Files += $(addprefix tests/Library.So/,Makefile Test.mk foo.c)
$(ZMK.releaseArchive).Files += $(addprefix tests/ManPage/,Makefile Test.mk foo.1 foo.2 foo.3 foo.4 foo.5 foo.6 foo.7 foo.8 foo.9 man/bar.1 man/bar.2 man/bar.3 man/bar.4 man/bar.5 man/bar.6 man/bar.7 man/bar.8 man/bar.9)
$(ZMK.releaseArchive).Files += $(addprefix tests/OS/,Makefile Test.mk)
$(ZMK.releaseArchive).Files += $(addprefix tests/Program/,Makefile Test.mk foo.c bar.cpp froz.m)
$(ZMK.releaseArchive).Files += $(addprefix tests/Symlink/,Makefile Test.mk)
$(ZMK.releaseArchive).Files += $(addprefix tests/Tarball.Src/,Makefile Test.mk foo.txt)
$(ZMK.releaseArchive).Files += $(addprefix tests/Toolchain/,Makefile Test.mk)
$(ZMK.releaseArchive).Files += tests/bin/GREP
$(eval $(call ZMK.Expand,Tarball.Src,$(ZMK.releaseArchive)))

check:: check-unit

# Some hackery is performed to map slashes to dashes, except in "(lib)?hello-".
tests = $(patsubst -%-,%,$(subst /,-,$(subst $(ZMK.SrcDir)/,/,$(dir $(shell find $(ZMK.SrcDir) -name Test.mk)))))
.PHONY: check-unit
check-unit: $(addprefix check-,$(tests))
.PHONY: $(addprefix check-,$(tests))

check-%: TESTDIR=$(patsubst examples/libhello/%,examples/libhello-%,$(patsubst examples/hello/%,examples/hello-%,$(subst -,/,$*)))
$(addprefix check-,$(tests)): check-%:
ifeq ($(ZMK.IsOutOfTreeBuild),yes)
	mkdir -p $(TESTDIR)
	$(strip $(MAKE)	--warn-undefined-variables \
		ZMK.test.SrcDir=$(ZMK.SrcDir)/$(TESTDIR) \
		-I $(abspath $(ZMK.Path)) \
		-C $(TESTDIR) \
		-f $(ZMK.SrcDir)/$(TESTDIR)/Test.mk)
else
	$(strip $(MAKE)	--warn-undefined-variables \
		-I $(abspath $(ZMK.Path)) \
		-C $(TESTDIR) \
		-f Test.mk)
endif
