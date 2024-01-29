# Copyrigth 2019-2024 Zygmunt Krynicki.
#
# This file is part of zmk.
#
# Zmk is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License version 3 as
# published by the Free Software Foundation.
#
# Zmk is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with Zmk.  If not, see <https://www.gnu.org/licenses/>.

$(eval $(call ZMK.Import,Directories))

# $1 is the header group name
# $2 is the header file (path)name

HeaderGroup.Variables=Headers InstallDir InstallMode
define HeaderGroup.Template
# Headers are not re-defined with := so that they can expand lazily.
$1.Headers ?= $$(error define $1.Headers - the list of header files to install)
# NOTE: Strip out the out-of-tree-source-path so that all the $1.headers (note
# the lower-case) variables use source-relative paths.
$1.headers = $$(patsubst $$(ZMK.OutOfTreeSourcePath)%,%,$$($1.Headers))

$1.InstallDir ?= $$(includedir)
$1.InstallMode = 0644

# This is how to compile each specific source file.
$$(foreach h,$$($1.headers),$$(eval $$h.InstallDir ?= $$($1.InstallDir)))
$$(foreach h,$$($1.headers),$$(eval $$h.InstallMode ?= $$($1.InstallMode)))
$$(foreach h,$$($1.headers),$$(eval $$(call ZMK.Expand,Header,$$h)))
endef
