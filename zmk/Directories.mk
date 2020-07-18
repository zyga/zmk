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

# Is zmk debugging enabled for this module?
Directories.debug ?= $(findstring directories,$(DEBUG))

# Installation prefix.
prefix ?= /usr/local
$(if $(Directories.debug),$(info DEBUG: prefix=$(prefix)))
exec_prefix ?= $(prefix)

# Relevant UNIX-y directories.
bindir ?= $(exec_prefix)/bin
sbindir ?= $(exec_prefix)/sbin
libexecdir ?= $(exec_prefix)/libexec
datarootdir ?= $(prefix)/share
datadir ?= $(datarootdir)
sysconfdir ?= $(prefix)/etc
sharedstatedir ?= $(prefix)/com
localstatedir ?= $(prefix)/var
runstatedir ?= $(localstatedir)/run
includedir ?= $(prefix)/include
infodir ?= $(datarootdir)info
libdir ?= $(exec_prefix)/lib
localedir ?= $(datarootdir)/locale
mandir ?= $(datarootdir)/man
man1dir ?= $(mandir)/man1
man2dir ?= $(mandir)/man2
man3dir ?= $(mandir)/man3
man4dir ?= $(mandir)/man4
man5dir ?= $(mandir)/man5
man6dir ?= $(mandir)/man6
man7dir ?= $(mandir)/man7
man8dir ?= $(mandir)/man8
man9dir ?= $(mandir)/man9

# List of standard directories. Those are created with a single rule below, and
# can be safely used as a order-only dependency.
Directories.POSIX = \
	$(prefix) $(exec_prefix) $(bindir) $(sbindir) $(libexecdir) \
	$(datarootdir) $(datadir) $(sysconfdir) $(sharedstatedir) \
	$(localstatedir) $(runstatedir) $(includedir) \
	$(infodir) $(libdir) $(localedir) $(mandir) $(man1dir) \
	$(man2dir) $(man3dir) $(man4dir) $(man5dir) $(man6dir) $(man7dir) \
	$(man8dir) $(man9dir)

# If NAME is defined, also define docdir.
ifneq ($(value NAME),$$(error define NAME - the name of the project))
docdir ?= $(datarootdir)/doc/$(NAME)
Directories.POSIX += $(docdir)
endif

$(if $(Directories.debug),$(info DEBUG: Directories.POSIX=$(Directories.POSIX)))

# Provide implicit rules for all the well-known directories.
$(foreach d,$(Directories.POSIX),$(eval $(call ZMK.Expand,Directory,$d)))
