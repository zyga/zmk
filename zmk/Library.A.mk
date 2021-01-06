# Copyright 2019-2021 Zygmunt Krynicki.
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
$(eval $(call ZMK.Import,Toolchain))

Library.A.Variables=Sources Objects
define Library.A.Template
ifneq ($$(suffix $1),.a)
$$(error library name $1 must end with ".a")
endif

# Compile library objects.
$$(eval $$(call ZMK.Expand,ObjectGroup,$1))

# Create library archive.
$1: $$($1.Objects)
	$$(call Silent.Say,AR,$$@)
	$$(Silent.Command)$$(AR) $$(ARFLAGS) $$@ $$^

# Install library archive.
$1.InstallDir ?= $$(libdir)
$$(eval $$(call ZMK.Expand,InstallUninstall,$1))

# React to "all" and "clean".
$$(eval $$(call ZMK.Expand,AllClean,$1))
endef
