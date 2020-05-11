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


# Symbolic link. Gets installed to the desired location. The location can be
# set using the .InstallDir instance variable. The special value of noinst
# prevents installation. This template is used by other parts of ZMK, to
# install components they produce.
Symlink.Variables=SymlinkTarget InstallDir
define Symlink.Template
$1.SymlinkTarget ?= $$(error define $1.SymlinkTarget - the target of the symbolic link)
$1.InstallDir ?= $$(error define $1.InstallDir - the destination directory, or noinst to skip installation)

$1.sourceDir = $$(dir $1)
$$(eval $$(call ZMK.Expand,Directory,$$($1.sourceDir)))
$1: | $$(DESTDIR)$$($1.sourceDir)
	$$(strip ln -s $$($1.SymlinkTarget) $$@)

# Unless we don't want to install the file, look below.
ifneq ($$($1.InstallDir),noinst)
$1.targetDir = $$(patsubst %/,%,$$(dir $$($1.InstallDir)/$1))
$$(eval $$(call ZMK.Expand,Directory,$$($1.targetDir)))

install:: $$(DESTDIR)$$($1.InstallDir)/$1
uninstall::
	rm -f $$(DESTDIR)$$($1.InstallDir)/$1

$$(DESTDIR)$$($1.InstallDir)/$1: | $$(DESTDIR)$$($1.targetDir)
	$$(strip ln -s $$($1.SymlinkTarget) $$@)
else # noinst
$1.targetDir = noinst
endif # !noinst
endef
