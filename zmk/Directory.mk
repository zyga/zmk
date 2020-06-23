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
$(eval $(call ZMK.Import,Directories))

# Plain directory. This template is used by other parts of ZMK.
Directory.Variables=
define Directory.Template
ifneq ($1,./)
ifeq (,$$(findstring $1,$$(Directories.Known)))
$1.parentDir = $$(patsubst %/,%,$$(dir $1))
ifneq (,$$($1.parentDir))
ifeq (,$$(findstring $$($1.parentDir),$$(Directories.Known)))
$$(eval $$(call ZMK.Expand,Directory,$$($1.parentDir)))
endif # !parent known
endif # !parent empty
Directories.Known += $1
$$(DESTDIR)$1: | $$(DESTDIR)$$($1.parentDir)
	install -d $$@
endif # !known
endif # !./
endef
