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
$(eval $(call import,Module.OS))

_bsd_tar_options ?=
_tar_compress_flag ?=

ifeq ($(OS),Darwin)
_bsd_tar_options := --no-mac-metadata
endif

%.tar.gz:  _tar_compress_flag=z
%.tar.bz2: _tar_compress_flag=j
%.tar.xz:  _tar_compress_flag=J

Template.tarball.variables=name files

define Template.tarball.spawn
$1.name ?= $$(patsubst %.tar$$(suffix $1),%,$1)
$1.files ?= $$(error define $1.files - the list of files to include in the tarball)

dist:: $1
$1: $$(sort $$(addprefix $$(srcdir)/,$$($1.files)))
ifneq ($(shell tar --version 2>&1 | grep GNU),)
	tar -$$(or $$(_tar_compress_flag),a)cf $$@ -C $(srcdir) --xform='s@^@$$($1.name)/@g' --xform='s@.version-from-git@.version@' $$(patsubst $$(srcdir)/%,%,$$^)
else
	tar $$(strip $$(_bsd_tar_options) -$$(or $$(_tar_compress_flag),a)cf) $$@ -C $(srcdir) -s '@.@$$($1.toplevel)/~@' -s '@.version-from-git@.version@' $$(patsubst $$(srcdir)/%,%,$$^)
endif
endef
