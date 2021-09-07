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

Directory.debug ?= $(findstring directory,$(DEBUG))

# List of directories that need to be created and have corresponding rules.
# Those are automatically handled, on demand, by expanding the Directory
# template. That template handles order-only dependencies on the parent
# directory, so, for example, creating /usr/share/man/man5 automatically
# depends on /usr/share/man, and so on.
Directory.known =

# Define DESTDIR to an empty value so that make --warn-undefined-variables
# does not complain about it.
ifeq ($(origin DESTDIR),undefined)
DESTDIR ?=
else
$(DESTDIR):
	$(call Silent.Say,MKDIR,$@)
	$(Silent.Command)mkdir -p $@
# Warn if DESTDIR is defined in a makefile. This is probably a mistake.
ifeq ($(origin DESTDIR),file)
$(warning DESTDIR should be set only through environment variable, not in a makefile)
endif
endif
$(if $(Directory.debug),$(info DEBUG: DESTDIR=$(DESTDIR)))

# Plain directory. This template is used by other parts of ZMK.
Directory.Variables=
define Directory.Template
ifneq ($1,/)
$1.cleaned=$$(patsubst %/,%,$1)
else
$1.cleaned=$1
endif
ifneq ($$($1.cleaned),.)
ifneq ($$($1.cleaned),/)
ifeq (,$$(filter $$($1.cleaned),$$(Directory.known)))
$1.parentDir = $$(patsubst %/,%,$$(dir $$($1.cleaned)))
ifneq (,$$($1.parentDir))
ifeq (,$$(filter $$($1.parentDir),$$(Directory.known)))
$$(eval $$(call ZMK.Expand,Directory,$$($1.parentDir)))
endif # !parent known
endif # !parent empty
Directory.known += $$($1.cleaned)
ifeq (/,$$(patsubst /%,/,$$($1.cleaned)))
# Absolute directories respect DESTDIR
$$(if $$(Directory.debug),$$(info DEBUG: absolute directory $$($1.cleaned)$$(if $$(DESTDIR), with prefixed DESTDIR=$$(DESTDIR))))
$$(DESTDIR)$$($1.cleaned): | $$(DESTDIR)$$($1.parentDir)
	$$(call Silent.Say,MKDIR,$$@)
	$$(Silent.Command)install -d $$@
ifneq ($1,$$($1.cleaned))
# Unclean directory path (with trailing slash) order-depends on the clean directory path
$$(if $$(Directory.debug),$$(info DEBUG: absolute unclean directory $1 corresponding to $$($1.cleaned)$$(if $$(DESTDIR), with prefixed DESTDIR=$$(DESTDIR))))
$$(DESTDIR)$1: | $$(DESTDIR)$$($1.cleaned)
endif
else
# Relative directories do not observe DESTDIR
$$(if $$(Directory.debug),$$(info DEBUG: relative directory $$($1.cleaned)))
$$($1.cleaned): | $$($1.parentDir)
	$$(call Silent.Say,MKDIR,$$@)
	$$(Silent.Command)install -d $$@
endif # !absolute
endif # !known
endif # !.
endif # !/
endef
