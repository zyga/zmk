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

%.asc: %
		gpg --detach-sign --armor $<

Tarball.Src.Variables=Name Files Sign
define Tarball.Src.Template
$1.Name ?= $$(patsubst %.tar$$(suffix $1),%,$1)
$1.Files ?= $$(error define $1.Files - the list of files to include in the tarball)
$1.Files += $$(ZMK.DistFiles)
# Sign archives that are not git snapshots and if CI is unset
$1.Sign ?= $$(if $$(or $$(value CI),$$(and $$(filter GitVersion,$$(ZMK.ImportedModules)),$$(GitVersion.Active))),,yes)

# If the Configure module is imported then include the configure script.
ifneq (,$$(filter Configure,$$(ZMK.ImportedModules)))
$1.Files += configure
endif

# If the GitVersion module is imported then attempt to insert version
# information into the release archive. There are two possible cases.
#
# 1) We may be in the directory still with git meta-data and history present,
# enough to compute the version. This case is signified by
# GitVersion.Origin=git. When this happens, the GitVersion module contains a
# rule for generating the file .version-from-git, which we can add to the
# source archive. The tar command will automatically rename that file to just
# .version.
#
# 2) We may be running without the git meta-data, for example after unpacking
# the release archive itself. In this case we typically have the .version file
# already so we should just preserve it.
ifneq (,$$(filter GitVersion,$$(ZMK.ImportedModules)))
ifeq (git,$$(GitVersion.Origin))
$1.Files += .version-from-git
endif
ifeq (file,$$(GitVersion.Origin))
$1.Files += .version
endif
endif

ifneq (,$$($1.Sign))
dist:: $1.asc
endif

distcheck:: distcheck-$1

.PHONY: distcheck-$1
distcheck-$1: ZMK.distCheckBase ?= $$(TMPDIR)/$1-distcheck
distcheck-$1: ZMK.absSrcdir ?= $$(abspath $$(srcdir))
distcheck-$1: ZMK.srcdirMakefile ?= $$(or $$(wildcard $$(abspath $$(srcdir)/GNUmakefile)),$$(wildcard $$(abspath $$(srcdir)/Makefile)))
distcheck-$1: | $$(TMPDIR)
	# Prepare scratch space for distcheck.
	-test -d $$(ZMK.distCheckBase) && chmod -R +w $$(ZMK.distCheckBase)
	rm -rf $$(ZMK.distCheckBase)
	mkdir -p $$(ZMK.distCheckBase)/tree
	mkdir -p $$(ZMK.distCheckBase)/build
	# Prepare a release archive $1 in a temporary directory.
	$$(strip $$(MAKE) dist \
		-C $$(ZMK.distCheckBase) \
		-f $$(ZMK.srcdirMakefile) \
		-I $$(ZMK.absSrcdir) \
		VPATH=$$(ZMK.absSrcdir) \
		srcdir=$$(ZMK.absSrcdir))
	# Unpack the release archive $1 to temporary directory.
	tar -zxf $$(ZMK.distCheckBase)/$1 --strip-components=1 -C $$(ZMK.distCheckBase)/tree
	# Make the source tree read-only for all out-of-tree checks.
	chmod -R -w $$(ZMK.distCheckBase)/tree
	# $1, when out-of-tree, builds correctly.
	$$(strip $$(MAKE) all \
		ZMK.Path=$$(ZMK.distCheckBase)/tree \
		srcdir=$$(ZMK.distCheckBase)/tree \
		VPATH=$$(ZMK.distCheckBase)/tree \
		-f $$(ZMK.distCheckBase)/tree/GNUmakefile \
		-C $$(ZMK.distCheckBase)/build)
	# $1, when out-of-tree, checks out.
	$$(strip $$(MAKE) check \
		ZMK.Path=$$(ZMK.distCheckBase)/tree \
		srcdir=$$(ZMK.distCheckBase)/tree \
		VPATH=$$(ZMK.distCheckBase)/tree \
		-f $$(ZMK.distCheckBase)/tree/GNUmakefile \
		-C $$(ZMK.distCheckBase)/build)
	# $1, when out-of-tree, installs via DESTDIR.
	$$(strip $$(MAKE) install \
		ZMK.Path=$$(ZMK.distCheckBase)/tree \
		srcdir=$$(ZMK.distCheckBase)/tree \
		VPATH=$$(ZMK.distCheckBase)/tree \
		-f $$(ZMK.distCheckBase)/tree/GNUmakefile \
		-C $$(ZMK.distCheckBase)/build \
		DESTDIR=$$(ZMK.distCheckBase)/installcheck)
	# $(NAME), when out-of-tree, uninstalls via DESTDIR.
	$$(strip $$(MAKE) uninstall \
		ZMK.Path=$$(ZMK.distCheckBase)/tree \
		srcdir=$$(ZMK.distCheckBase)/tree \
		VPATH=$$(ZMK.distCheckBase)/tree \
		-f $$(ZMK.distCheckBase)/tree/GNUmakefile \
		-C $$(ZMK.distCheckBase)/build \
		DESTDIR=$$(ZMK.distCheckBase)/installcheck)
	# Uninstalled $1 does not leave files or symbolic links.
	test "$$$$(find $$(ZMK.distCheckBase)/installcheck -type f -o -type l | wc -l)" -eq 0
	rm -rf $$(ZMK.distCheckBase)/installcheck
	# $1, when out-of-tree, can re-create the release archive.
	$$(strip $$(MAKE) dist \
		ZMK.Path=$$(ZMK.distCheckBase)/tree \
		srcdir=$$(ZMK.distCheckBase)/tree \
		VPATH=$$(ZMK.distCheckBase)/tree \
		-f $$(ZMK.distCheckBase)/tree/GNUmakefile \
		-C $$(ZMK.distCheckBase)/build)
	# Make the source tree read-write for in-tree checks.
	chmod -R +w $$(ZMK.distCheckBase)/tree
	# $1, when in-tree, builds correctly.
	$$(MAKE) -C $$(ZMK.distCheckBase)/tree all
	# $1, when in-tree, checks out.
	$$(MAKE) -C $$(ZMK.distCheckBase)/tree check
	# $1, when in-tree, installs via DESTDIR.
	$$(strip $$(MAKE) -C $$(ZMK.distCheckBase)/tree install \
		DESTDIR=$$(ZMK.distCheckBase)/installcheck)
	# $(NAME), when in-tree, uninstalls via DESTDIR.
	$$(strip $$(MAKE) -C $$(ZMK.distCheckBase)/tree uninstall \
		DESTDIR=$$(ZMK.distCheckBase)/installcheck)
	# Uninstalled $1 does not leave files or symbolic links.
	test "$$$$(find $$(ZMK.distCheckBase)/installcheck -type f -o -type l | wc -l)" -eq 0
	rm -rf $$(ZMK.distCheckBase)/installcheck
	# $1, when in-tree, can re-create the release archive.
	$$(MAKE) -C $$(ZMK.distCheckBase)/tree dist
	# Clean up after distcheck.
	rm -rf $$(ZMK.distCheckBase)
	@echo "dist-check successful"

$$(eval $$(call ZMK.Expand,Tarball,$1))
endef
