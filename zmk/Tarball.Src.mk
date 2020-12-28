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

$(eval $(call ZMK.Import,Silent))

# XXX: those belong in other places but that's fine for now.
zmk.haveGPG?=$(if $(shell sh -c "command -v gpg"),yes)
zmk.haveGPGKeys?=$(if $(and $(zmk.haveGPG),$(wildcard $(HOME)/.gnupg/*),$(shell gpg --list-secret-keys)),yes)
zmk.isCI?=$(if $(value CI),yes)
zmk.isGitSnapshot?=$(if $(filter GitVersion,$(ZMK.ImportedModules)),$(if $(GitVersion.Active),yes))

# XXX: This belongs in z.mk.
zmk.not=$(if $1,,yes)

%.asc: %
	$(call Silent.Say,GPG-SIGN,$@)
	$(Silent.Command)gpg --detach-sign --armor $<

# Allow preventing ZMK from ever being bundled.
ZMK.DoNotBundle ?= $(if $(value ZMK_DO_NOT_BUNDLE),yes)

Tarball.Src.Variables=Name Files Sign
define Tarball.Src.Template
$1.Name ?= $$(patsubst %.tar$$(suffix $1),%,$1)
$1.Files ?= $$(error define $1.Files - the list of files to include in the tarball)
ifeq ($$(ZMK.DoNotBundle),)
$1.Files += $$(addprefix $$(ZMK.Path)/,$$(ZMK.DistFiles))
# If the Configure module is imported then include the configure script.
ifneq (,$$(filter Configure,$$(ZMK.ImportedModules)))
$1.Files += $(CURDIR)/configure
endif
endif

# If we have a GPG keys, CI is not set and the tarball is not a snapshot, sign it.
$1.Sign ?= $$(and $$(zmk.haveGPG),$$(zmk.haveGPGKeys),$$(call zmk.not,$$(zmk.isCI)),$$(call zmk.not,$$(zmk.isCI)))

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
distcheck-$1: ZMK.absSrcdir ?= $$(abspath $$(ZMK.SrcDir))
distcheck-$1: ZMK.srcDirMakefile ?= $$(or $$(wildcard $$(abspath $$(ZMK.SrcDir)/GNUmakefile)),$$(wildcard $$(abspath $$(ZMK.SrcDir)/Makefile)))
distcheck-$1: | $$(TMPDIR)
	# Prepare scratch space for distcheck.
	if [ -d $$(ZMK.distCheckBase) ]; then chmod -R +w $$(ZMK.distCheckBase); fi
	rm -rf $$(ZMK.distCheckBase)
	mkdir -p $$(ZMK.distCheckBase)/tree
	mkdir -p $$(ZMK.distCheckBase)/build
	# Prepare a release archive $1 in a temporary directory.
	$$(strip $$(MAKE) dist \
		ZMK.SrcDir=$$(ZMK.absSrcdir)) \
		-I $$(ZMK.absSrcdir) \
		-C $$(ZMK.distCheckBase) \
		-f $$(ZMK.srcDirMakefile)
	# Unpack the release archive $1 to temporary directory.
	tar -zxf $$(ZMK.distCheckBase)/$1 --strip-components=1 -C $$(ZMK.distCheckBase)/tree
	# Make the source tree read-only for all out-of-tree checks.
	chmod -R -w $$(ZMK.distCheckBase)/tree
ifneq (,$$(filter Configure,$$(ZMK.ImportedModules)))
	# $1, can be configured for an out-of-tree build
	(cd $$(ZMK.distCheckBase)/build/ && ../tree/configure)
endif
	# $1, when out-of-tree, builds correctly.
	$$(strip $$(MAKE) all \
		ZMK.Path=$$(ZMK.distCheckBase)/tree \
		ZMK.SrcDir=$$(ZMK.distCheckBase)/tree \
		-f $$(ZMK.distCheckBase)/tree/$$(notdir $$(ZMK.srcDirMakefile)) \
		-C $$(ZMK.distCheckBase)/build)
	# $1, when out-of-tree, checks out.
	$$(strip $$(MAKE) check \
		ZMK.Path=$$(ZMK.distCheckBase)/tree \
		ZMK.SrcDir=$$(ZMK.distCheckBase)/tree \
		-f $$(ZMK.distCheckBase)/tree/$$(notdir $$(ZMK.srcDirMakefile)) \
		-C $$(ZMK.distCheckBase)/build)
	# $1, when out-of-tree, installs via DESTDIR.
	$$(strip $$(MAKE) install \
		ZMK.Path=$$(ZMK.distCheckBase)/tree \
		ZMK.SrcDir=$$(ZMK.distCheckBase)/tree \
		-f $$(ZMK.distCheckBase)/tree/$$(notdir $$(ZMK.srcDirMakefile)) \
		-C $$(ZMK.distCheckBase)/build \
		DESTDIR=$$(ZMK.distCheckBase)/installcheck)
	# $(NAME), when out-of-tree, uninstalls via DESTDIR.
	$$(strip $$(MAKE) uninstall \
		ZMK.Path=$$(ZMK.distCheckBase)/tree \
		ZMK.SrcDir=$$(ZMK.distCheckBase)/tree \
		-f $$(ZMK.distCheckBase)/tree/$$(notdir $$(ZMK.srcDirMakefile)) \
		-C $$(ZMK.distCheckBase)/build \
		DESTDIR=$$(ZMK.distCheckBase)/installcheck)
	# Uninstalled $1 does not leave files or symbolic links.
	test "$$$$(find $$(ZMK.distCheckBase)/installcheck -type f -o -type l | wc -l)" -eq 0
	rm -rf $$(ZMK.distCheckBase)/installcheck
	# $1, when out-of-tree, can re-create the release archive.
	$$(strip $$(MAKE) dist \
		ZMK.Path=$$(ZMK.distCheckBase)/tree \
		ZMK.SrcDir=$$(ZMK.distCheckBase)/tree \
		-f $$(ZMK.distCheckBase)/tree/$$(notdir $$(ZMK.srcDirMakefile)) \
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
