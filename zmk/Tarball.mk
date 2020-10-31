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
$(eval $(call ZMK.Import,Directories))
$(eval $(call ZMK.Import,OS))

Tarball.tar ?= $(shell command -v tar 2>/dev/null)
Tarball.isGNU ?= $(if $(shell $(Tarball.tar) --version 2>&1 | grep GNU),yes)

# When using MacOS, ask tar not to store mac-specific meta-data through .DS_Store files.
ifeq ($(OS.Kernel),Darwin)
Tarball.tarOptions += --no-mac-metadata
endif

# Recognize common compression formats
%.tar.gz:  Tarball.compressFlag=z
%.tar.bz2: Tarball.compressFlag=j
%.tar.xz:  Tarball.compressFlag=J

Tarball.Variables=Name Files
define Tarball.Template
$1.Name ?= $$(patsubst %.tar$$(suffix $1),%,$1)
$1.Files ?= $$(error define $1.Files - the list of files to include in the tarball)

dist:: $1

# Apply transforms, using either GNU or BSD tar syntax.
# - strip $(CURDIR), this fixes out-of-tree configure
# - strip $(ZMK.Path), this effectively bundles ZMK into the root directory of the archive
# - insert directory with archive name up front
# - rename the .version-from-git file to .version (see GitVersion module)
ifeq ($$(Tarball.isGNU),yes)
$1: Tarball.tarOptions += --absolute-names
$1: Tarball.tarOptions += --xform='s@$$(CURDIR)/@@g'
ifneq ($$(ZMK.Path),.)
$1: Tarball.tarOptions += --xform='s@$$(ZMK.Path)/@@g'
endif
$1: Tarball.tarOptions += --xform='s@.version-from-git@.version@'
$1: Tarball.tarOptions += --xform='s@^@$$($1.Name)/@'
else
$1: Tarball.tarOptions += -s '@$$(CURDIR)/@@g'
ifneq ($$(ZMK.Path),.)
$1: Tarball.tarOptions += -s '@$$(ZMK.Path)/@@g'
endif
$1: Tarball.tarOptions += -s '@^.version-from-git@$$($1.Name)/.version@'
$1: Tarball.tarOptions += -s '@^.@$$($1.Name)/~@'
endif

$1: $$(sort $$($1.Files))
	$$(call Silent.Say,TAR,$$@)
	$$(Silent.Command)$$(strip $$(Tarball.tar) \
		-$$(or $$(Tarball.compressFlag),a)cf $$@ \
		$$(if $$(ZMK.IsOutOfTreeBuild),-C $$(ZMK.SrcDir)) \
		$$(Tarball.tarOptions) \
		$$(patsubst $$(ZMK.SrcDir)/%,%,$$^))
endef
