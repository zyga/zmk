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

Template.tarball.src.variables=name files

%.asc: %
		gpg --detach-sign --armor $<

define Template.tarball.src.spawn
$1.name ?= $$(patsubst %.tar$$(suffix $1),%,$1)
$1.files ?= $$(error define $1.files - the list of files to include in the tarball)
$1.files += $$(ZMK.DistFiles)
ifneq ($$(VERSION),$$(VERSION_static))
$1.files += .version-from-git
endif
$$(eval $$(call spawn,Template.tarball,$1))
dist:: $1.asc
endef
