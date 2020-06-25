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

# List of directories that need to be created and have corresponding rules.
# Those are automatically handled, on demand, by expanding the Directory
# template. That template handles order-only dependencies on the parent
# directory, so, for example, creating /usr/share/man/man5 automatically
# depends on /usr/share/man, and so on.
Directory.known =
Directory.debug ?= $(findstring directory,$(DEBUG))

# Define DESTDIR to an empty value so that make --warn-undefined-variables
# does not complain about it.
ifeq ($(origin DESTDIR),undefined)
DESTDIR ?=
else
$(DESTDIR):
	mkdir -p $@
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
$$(DESTDIR)$$($1.cleaned): | $$(DESTDIR)$$($1.parentDir)
	install -d $$@
else
# Relative directories do not observe DESTDIR
$$($1.cleaned): | $$($1.parentDir)
	install -d $$@
endif # !absolute
endif # !known
endif # !.
endif # !/
endef
