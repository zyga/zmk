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

# A file that gets installed to a desired location. The location can be set
# using the .InstallDir instance variable. The special value of noinst prevents
# installation. This template is used by other parts of ZMK, to install
# components they produce.
Installable.Variables=InstallDir InstallMode
define Installable.Template
$1.InstallDir ?= $$(error define $1.InstallDir - the destination directory, or noinst to skip installation)
$1.InstallMode ?= 0644

# Unless we don't want to install the file, look below.
ifneq ($$($1.InstallDir),noinst)
$1.targetDir = $$(patsubst %/,%,$$(dir $$($1.InstallDir)/$1))

install:: $$(DESTDIR)$$($1.InstallDir)/$1
uninstall::
	rm -f $$(DESTDIR)$$($1.InstallDir)/$1

$$(eval $$(call ZMK.Expand,Directory,$$($1.targetDir)))
$$(DESTDIR)$$($1.InstallDir)/$1: $1 | $$(DESTDIR)$$($1.targetDir)
	$$(strip install -m $$($1.InstallMode) $$^ $$@)
else # !noinst
$1.targetDir = noinst
endif # noinst
endef
