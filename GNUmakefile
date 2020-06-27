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

# Use the local copy of zmk rather than the system-wide one.
ZMK.Path ?= .
include $(ZMK.Path)/z.mk

# Use git to augment version.
$(eval $(call ZMK.Import,GitVersion))
$(eval $(call ZMK.Import,Directories))

# Install all of zmk to the sub-directory in the include directory.
# Except for z.mk itself, which should live there directly.
$(foreach f,$(ZMK.DistFiles),$(eval $f.InstallDir=$(includedir)/zmk))
z.mk.InstallDir=$(includedir)
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
zmkReleaseArchive?=$(NAME)_$(VERSION).tar.gz
$(zmkReleaseArchive).Files = GNUmakefile README.md LICENSE NEWS
$(zmkReleaseArchive).Files += $(addsuffix .in,$(addprefix man/,$(ZMK.manPages)))
$(zmkReleaseArchive).Files += $(addprefix examples/hello-c/,Makefile Test.mk hello.c)
$(zmkReleaseArchive).Files += $(addprefix examples/hello-cpp/,Makefile Test.mk hello.cpp)
$(zmkReleaseArchive).Files += $(addprefix examples/hello-objc/,Makefile Test.mk hello.m README.txt)
$(zmkReleaseArchive).Files += $(addprefix examples/libhello-c/,Makefile Test.mk hello.c hello.h)
$(zmkReleaseArchive).Files += $(addprefix examples/libhello-cpp/,Makefile Test.mk hello.cpp hello.h)
$(zmkReleaseArchive).Files += $(addprefix examples/libhello-objc/,Makefile Test.mk hello.m hello.h)
$(zmkReleaseArchive).Files += $(addprefix examples/true_false/,Makefile Test.mk true_false.c README.txt)
$(zmkReleaseArchive).Files += $(addprefix examples/script/,Makefile Test.mk hello.sh)
$(zmkReleaseArchive).Files += $(addprefix tests/Configure/,Makefile Test.mk)
$(zmkReleaseArchive).Files += $(addprefix tests/Directories/,Makefile Test.mk)
$(zmkReleaseArchive).Files += $(addprefix tests/Directory/,Makefile Test.mk)
$(zmkReleaseArchive).Files += $(addprefix tests/Header/,Makefile Test.mk foo.h include/bar.h)
$(zmkReleaseArchive).Files += $(addprefix tests/Library.A/,Makefile Test.mk foo.c)
$(zmkReleaseArchive).Files += $(addprefix tests/Library.DyLib/,Makefile Test.mk foo.c)
$(zmkReleaseArchive).Files += $(addprefix tests/Library.So/,Makefile Test.mk foo.c)
$(zmkReleaseArchive).Files += $(addprefix tests/ManPage/,Makefile Test.mk foo.1 foo.2 foo.3 foo.4 foo.5 foo.6 foo.7 foo.8 foo.9 man/bar.1 man/bar.2 man/bar.3 man/bar.4 man/bar.5 man/bar.6 man/bar.7 man/bar.8 man/bar.9)
$(zmkReleaseArchive).Files += $(addprefix tests/OS/,Makefile Test.mk)
$(zmkReleaseArchive).Files += $(addprefix tests/Program/,Makefile Test.mk foo.c bar.cpp froz.m)
$(zmkReleaseArchive).Files += $(addprefix tests/Symlink/,Makefile Test.mk)
$(zmkReleaseArchive).Files += $(addprefix tests/Tarball.Src/,Makefile Test.mk foo.txt)
$(zmkReleaseArchive).Files += $(addprefix tests/Toolchain/,Makefile Test.mk)
$(zmkReleaseArchive).Files += tests/bin/GREP
$(eval $(call ZMK.Expand,Tarball.Src,$(zmkReleaseArchive)))


#check-examples = $(addprefix check,$(subst /,-,$(subst $(srcdir)/,/,$(wildcard $(srcdir)/examples/*))))
#check:: $(check-examples)
#$(check-examples): check-examples-%:
#	$(MAKE) -I $(abspath $(srcdir)) --warn-undefined-variables -C $(srcdir)/examples/$* clean
#	$(MAKE) -I $(abspath $(srcdir)) --warn-undefined-variables -C $(srcdir)/examples/$* all
#	rm -rf /tmp/zmk-example-$*
#	$(MAKE) -I $(abspath $(srcdir)) --warn-undefined-variables -C $(srcdir)/examples/$* install DESTDIR=/tmp/zmk-example-$*


check:: check-unit

# Some hackery is performed to map slashes to dashes, except in "(lib)?hello-".
tests = $(patsubst -%-,%,$(subst /,-,$(subst $(srcdir)/,/,$(dir $(shell find $(srcdir) -name Test.mk)))))
.PHONY: check-unit
check-unit: $(addprefix check-,$(tests))
.PHONY: $(addprefix check-,$(tests))

check-%: TESTDIR=$(patsubst examples/libhello/%,examples/libhello-%,$(patsubst examples/hello/%,examples/hello-%,$(subst -,/,$*)))
$(addprefix check-,$(tests)): check-%:
ifeq ($(srcdir),.)
	$(strip $(MAKE)	--no-print-directory --warn-undefined-variables \
		-I $(abspath $(ZMK.Path)) \
		-C $(TESTDIR) \
		-f Test.mk)
else
	mkdir -p $(TESTDIR)
	$(strip $(MAKE)	--no-print-directory --warn-undefined-variables \
		VPATH=$(srcdir)/$(TESTDIR) \
		srcdir=$(srcdir)/$(TESTDIR) \
		-I $(abspath $(ZMK.Path)) \
		-C $(TESTDIR) \
		-f $(srcdir)/$(TESTDIR)/Test.mk)
endif

TMPDIR ?= /tmp

.PHONY: distcheck
distcheck: ZMK.distCheckArchive ?= $(NAME)-distcheck.tar.gz
distcheck: ZMK.distCheckBase ?= $(TMPDIR)/$(NAME)-distcheck
distcheck: | $(TMPDIR)
	# Prepare scratch space for distcheck
	-test -d $(ZMK.distCheckBase) && chmod -R +w $(ZMK.distCheckBase)
	rm -rf $(ZMK.distCheckBase)
	mkdir -p $(ZMK.distCheckBase)/tree
	mkdir -p $(ZMK.distCheckBase)/build
	# Prepare a release archive of $(NAME)
	$(MAKE) zmkReleaseArchive=$(ZMK.distCheckArchive) dist
	# Unpack the release archive of $(NAME) to temporary directory
	mv $(ZMK.distCheckArchive) $(ZMK.distCheckBase)
	tar -zxf $(ZMK.distCheckBase)/$(ZMK.distCheckArchive) --strip-components=1 -C $(ZMK.distCheckBase)/tree
	# Make the source tree read-only for all out-of-tree checks
	chmod -R -w $(ZMK.distCheckBase)/tree
	# $(NAME), when out-of-tree, builds correctly
	$(strip $(MAKE) all \
		ZMK.Path=$(ZMK.distCheckBase)/tree \
		srcdir=$(ZMK.distCheckBase)/tree \
		VPATH=$(ZMK.distCheckBase)/tree \
		-f $(ZMK.distCheckBase)/tree/GNUmakefile \
		-C $(ZMK.distCheckBase)/build)
	# $(NAME), when out-of-tree, checks out
	$(strip $(MAKE) check \
		ZMK.Path=$(ZMK.distCheckBase)/tree \
		srcdir=$(ZMK.distCheckBase)/tree \
		VPATH=$(ZMK.distCheckBase)/tree \
		-f $(ZMK.distCheckBase)/tree/GNUmakefile \
		-C $(ZMK.distCheckBase)/build)
	# $(NAME), when out-of-tree, installs via DESTDIR
	$(strip $(MAKE) install \
		ZMK.Path=$(ZMK.distCheckBase)/tree \
		srcdir=$(ZMK.distCheckBase)/tree \
		VPATH=$(ZMK.distCheckBase)/tree \
		-f $(ZMK.distCheckBase)/tree/GNUmakefile \
		-C $(ZMK.distCheckBase)/build \
		DESTDIR=$(ZMK.distCheckBase)/installcheck)
	# $(NAME), when out-of-tree, uninstalls via DESTDIR
	$(strip $(MAKE) uninstall \
		ZMK.Path=$(ZMK.distCheckBase)/tree \
		srcdir=$(ZMK.distCheckBase)/tree \
		VPATH=$(ZMK.distCheckBase)/tree \
		-f $(ZMK.distCheckBase)/tree/GNUmakefile \
		-C $(ZMK.distCheckBase)/build \
		DESTDIR=$(ZMK.distCheckBase)/installcheck)
	# Uninstalled $(NAME) does not leave files or symbolic links
	test "$$(find $(ZMK.distCheckBase)/installcheck -type f -o -type l | wc -l)" -eq 0
	rm -rf $(ZMK.distCheckBase)/installcheck
	# $(NAME), when out-of-tree, can re-create the release archive
	$(strip $(MAKE) dist \
		ZMK.Path=$(ZMK.distCheckBase)/tree \
		srcdir=$(ZMK.distCheckBase)/tree \
		VPATH=$(ZMK.distCheckBase)/tree \
		-f $(ZMK.distCheckBase)/tree/GNUmakefile \
		-C $(ZMK.distCheckBase)/build)
	# Make the source tree read-write for in-tree checks
	chmod -R +w $(ZMK.distCheckBase)/tree
	# $(NAME), when in-tree, builds correctly
	$(MAKE) -C $(ZMK.distCheckBase)/tree all
	# $(NAME), when in-tree, checks out
	$(MAKE) -C $(ZMK.distCheckBase)/tree check
	# $(NAME), when in-tree, installs via DESTDIR
	$(strip $(MAKE) -C $(ZMK.distCheckBase)/tree install \
		DESTDIR=$(ZMK.distCheckBase)/installcheck)
	# $(NAME), when in-tree, uninstalls via DESTDIR
	$(strip $(MAKE) -C $(ZMK.distCheckBase)/tree uninstall \
		DESTDIR=$(ZMK.distCheckBase)/installcheck)
	# Uninstalled $(NAME) does not leave files or symbolic links
	test "$$(find $(ZMK.distCheckBase)/installcheck -type f -o -type l | wc -l)" -eq 0
	rm -rf $(ZMK.distCheckBase)/installcheck
	# $(NAME), when in-tree, can re-create the release archive
	$(MAKE) -C $(ZMK.distCheckBase)/tree dist
	# Clean up after distcheck
	rm -rf $(ZMK.distCheckBase)
