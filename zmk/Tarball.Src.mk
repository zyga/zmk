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
# Sign archives that are not git snapshots and if CI is unset
$1.Sign ?= $$(if $$(or $$(value CI),$$(and $$(filter GitVersion,$$(ZMK.ImportedModules)),$$(GitVersion.Active))),,yes)


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

$$(eval $$(call ZMK.Expand,Tarball,$1))
endef
