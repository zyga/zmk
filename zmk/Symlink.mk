# SPDX-FileCopyrightText: 2019-2024 Zygmunt Krynicki
# SPDX-License-Identifier: LGPL-3.0-only
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

$(eval $(call ZMK.Import,Silent))

# Symbolic link. Gets installed to the desired location. The location can be
# set using the .InstallDir instance variable. The special value of noinst
# prevents installation. This template is used by other parts of ZMK, to
# install components they produce.
Symlink.Variables=SymlinkTarget InstallDir InstallName
define Symlink.Template
$1.InstallDir ?= $$(error define $1.InstallDir - the destination directory, or noinst to skip installation)
$1.SymlinkTarget ?= $$(error define $1.SymlinkTarget - the target of the symbolic link)
$1.InstallName ?= $$(notdir $1)

# Create the directory where the symbolic link is built in.
$$(eval $$(call ZMK.Expand,Directory,$$(dir $1)))
# Create the symbolic link in the build directory.
$1: | $$(patsubst %/,%,$$(dir $1))
	$$(call Silent.Say,SYMLINK,$$@)
	$$(Silent.Command)$$(strip ln -sf $$($1.SymlinkTarget) $$@)
# React to "all" and "clean" targets.
$$(eval $$(call ZMK.Expand,AllClean,$1))

# Unless we don't want to install the file, look below.
ifneq ($$($1.InstallDir),noinst)

# Create the directory where the symbolic link is installed to.
$$(eval $$(call ZMK.Expand,Directory,$$($1.InstallDir)))
# Create the symbolic link in the install directory.
$$(DESTDIR)$$($1.InstallDir)/$$($1.InstallName):| $$(DESTDIR)$$($1.InstallDir)
	$$(call Silent.Say,SYMLINK,$$@)
	$$(Silent.Command)$$(strip ln -sf $$($1.SymlinkTarget) $$@)
# React to "install" and "uninstall" targets.
install:: $$(DESTDIR)$$($1.InstallDir)/$$($1.InstallName)
uninstall::
	$$(call Silent.Say,RM,$$($1.InstallDir)/$$($1.InstallName))
	$$(Silent.Command)rm -f $$(DESTDIR)$$($1.InstallDir)/$$($1.InstallName)
endif # !noinst
endef
