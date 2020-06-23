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

# GNU man can be used to perform rudimentary validation of manual pages.
#ifneq ($(and $(shell command -v man 2>/dev/null),$(shell man --help 2>&1 | grep -F -- --warning)),)
#static-check-manpages:
#	LC_ALL=C MANROFFSEQ='' MANWIDTH=80 man --warnings -E UTF-8 -l -Tutf8 -Z $^ 2>&1 >/dev/null | diff -u - /dev/null
#static-check:: static-check-manpages
#endif

ManPage.Variables=Section
define ManPage.Template
$1.Section ?= $$(patsubst .%,%,$$(suffix $1))
$1.InstallDir = $$(if $$(man$$($1.Section)dir),,$$(error unknown section $$($1.Section)))
$1.InstallMode = 0644
$$(eval $$(call ZMK.Expand,InstallUninstall,$1))
static-check-manpages: $1
endef
