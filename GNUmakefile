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

NAME = zmk
VERSION = 0.1

# Use the local copy of zmk rather than the system-wide one.
ZMK.Path =
include ./z.mk

# Use git to augment version.
$(eval $(call import,Module.git-version))

# The release tarball.
$(NAME)_$(VERSION).tar.gz.files += GNUmakefile README.md LICENSE NEWS
$(NAME)_$(VERSION).tar.gz.files += $(ZMK.DistFiles)
ifneq ($(VERSION),$(VERSION_static))
$(NAME)_$(VERSION).tar.gz.files += .version-from-git
endif
$(eval $(call spawn,Template.tarball,$(NAME)_$(VERSION).tar.gz))

# Install almost all of the ZMK files to the zmk subdirectory of the include
# directory, except for z.mk itself, which is installed directly to the
# include directory.
$(foreach m,$(ZMK.DistFiles),$(eval $m.install_dir=$(includedir)/zmk))
z.mk.install_dir = $(includedir)
configure.install_mode = 0755
$(foreach m,$(ZMK.DistFiles),$(eval $(call spawn,Template.data,$m)))
