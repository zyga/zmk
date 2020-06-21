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

Tarball.Src.Variables=Name Files
define Tarball.Src.Template
$1.Name ?= $$(patsubst %.tar$$(suffix $1),%,$1)
$1.Files ?= $$(error define $1.Files - the list of files to include in the tarball)
$1.Files += $$(ZMK.DistFiles)
ifneq (,$$(filter Configure,$$(ZMK.ImportedModules)))
$1.Files += configure
endif
ifneq ($$(VERSION),$$(VERSION_static))
$1.Files += .version-from-git
else
dist:: $1.asc
endif
$$(eval $$(call ZMK.Expand,Tarball,$1))
endef
