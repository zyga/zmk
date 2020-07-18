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
$(eval $(call ZMK.Import,OS))

_bsd_tar_options ?=
_tar_compress_flag ?=

Tarball.isGNU ?= $(if $(shell tar --version 2>&1 | grep GNU),yes)

# If using a Mac, filter out extended meta-data files.
ifeq ($(OS.Kernel),Darwin)
_bsd_tar_options := --no-mac-metadata
endif

%.tar.gz:  _tar_compress_flag=z
%.tar.bz2: _tar_compress_flag=j
%.tar.xz:  _tar_compress_flag=J

Tarball.Variables=Name Files
define Tarball.Template
$1.Name ?= $$(patsubst %.tar$$(suffix $1),%,$1)
$1.Files ?= $$(error define $1.Files - the list of files to include in the tarball)

dist:: $1
$1: $$(sort $$(addprefix $$(srcdir)/,$$($1.Files)))
ifeq ($(Tarball.isGNU),yes)
	tar -$$(or $$(_tar_compress_flag),a)cf $$@ -C $$(srcdir) --xform='s@^@$$($1.Name)/@g' --xform='s@.version-from-git@.version@' $$(patsubst $$(srcdir)/%,%,$$^)
else
	tar $$(strip $$(_bsd_tar_options) -$$(or $$(_tar_compress_flag),a)cf) $$@ -C $$(srcdir) -s '@.@$$($1.Name)/~@' -s '@.version-from-git@.version@' $$(patsubst $$(srcdir)/%,%,$$^)
endif
endef
