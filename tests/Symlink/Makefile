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

include z.mk

name1.InstallDir = /some/path
name1.SymlinkTarget=target
$(eval $(call ZMK.Expand,Symlink,name1))

name2.InstallDir = /other/path
name2.InstallName = custom-install-name2
name2.SymlinkTarget=target
$(eval $(call ZMK.Expand,Symlink,name2))

subdir/name3.InstallDir = /other/path
subdir/name3.SymlinkTarget=../target
$(eval $(call ZMK.Expand,Symlink,subdir/name3))

subdir/name4.InstallDir = /other/path
subdir/name4.InstallName = custom-install-name4
subdir/name4.SymlinkTarget=../target
$(eval $(call ZMK.Expand,Symlink,subdir/name4))

