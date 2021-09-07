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

$(eval $(call ZMK.Import,Directories))

# Relative directory in the build tree
$(eval $(call ZMK.Expand,Directory,subdir/subsubdir))

# Sub-directory of a known directory.
$(eval $(call ZMK.Expand,Directory,$(libdir)/extra))

# Custom directory with duplicates and trailing slash.
$(eval $(call ZMK.Expand,Directory,/foo))
$(eval $(call ZMK.Expand,Directory,/foo))
$(eval $(call ZMK.Expand,Directory,/foo/))

# Custom directories with implicitly defined parents.
$(eval $(call ZMK.Expand,Directory,/custom/long/path))

# Custom directories with explicitly defined parents.
$(eval $(call ZMK.Expand,Directory,/))
$(eval $(call ZMK.Expand,Directory,/other))
$(eval $(call ZMK.Expand,Directory,/other/custom/))
$(eval $(call ZMK.Expand,Directory,/other/custom/path))

debug:: subdir/subsubdir $(addprefix $(DESTDIR),$(libdir)/extra /foo /custom/long/path /other/custom/path)
