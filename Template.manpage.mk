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
_man_sections = 1 2 3 4 5 6 7 8 9

# GNU man can be used to perform rudimentary validation of manual pages.
ifneq ($(and $(shell command -v man 2>/dev/null),$(shell man --help 2>&1 | grep -F -- --warning)),)
static-check-manpages:
	LC_ALL=C MANROFFSEQ='' MANWIDTH=80 man --warnings -E UTF-8 -l -Tutf8 -Z $^ 2>&1 >/dev/null | diff -u - /dev/null
static-check:: static-check-manpages
endif

Template.manpage.variables=section
define Template.manpage.spawn
$1.section ?= $$(patsubst .%,%,$$(suffix $1))
install:: $$(DESTDIR)$$(man$$($1.section)dir)/$$(notdir $1)
uninstall::
	rm -f $$(DESTDIR)$$(man$$($1.section)dir)/$$(notdir $1)
$$(DESTDIR)$$(man$$($1.section)dir)/$$(notdir $1): $1 | $$(DESTDIR)$$(man$$($1.section)dir)
	install $$^ $$@
static-check-manpages: $1
endef
