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

# If the GitVersion module is imported and has contributed version information then include it.
ifneq (,$$(and $$(filter GitVersion,$$(ZMK.ImportedModules)),$$(GitVersion.Active)))
$1.Files += .version-from-git
endif

ifneq (,$$($1.Sign))
dist:: $1.asc
endif

$$(eval $$(call ZMK.Expand,Tarball,$1))
endef
