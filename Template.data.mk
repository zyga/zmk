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

$(eval $(call import,Module.directories))

# List of directories that need to be created and have corresponding rules.
# All of the POSIX directories are created with a single rule from the
# Directories module and do not need to be repeated here.
Data.Directories = $(Directories.POSIX)

# Data file. Gets installed to the desired location.  The location
# can be set using the .install_dir instance variable. The special
# value of noinst prevents installation. This template is used by
# other parts of ZMK, to install components they produce.
Template.data.variables=install_dir
define Template.data.spawn
$1.install_dir ?= $$(error define $1.install_dir - the destination directory, or noinst to skip installation)

# Unless we don't want to install the file, look below.
ifneq ($$($1.install_dir),noinst)

# To install a file, install it.
$$(DESTDIR)$$($1.install_dir)/$1: $1 | $$(DESTDIR)$$($1.install_dir)
	install $$^ $$@

# Rule for installing this directory, if one is needed.
ifeq (,$$(findstring $$($1.install_dir),$$(Data.Directories)))
Data.Directories += $$($1.install_dir)
$$(DESTDIR)$$($1.install_dir):
	install -d $$@
endif

# We want the file installed when installing.
install:: $$(DESTDIR)$$($1.install_dir)/$1

# Remove the file when uninstalling.
uninstall::
	rm -f $$(DESTDIR)$$($1.install_dir)/$1
endif
endef
