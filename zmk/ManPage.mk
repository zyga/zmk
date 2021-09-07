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
$(eval $(call ZMK.Import,Directories))

# ManPage.isAvailable expand to "yes" when the man command is available.
ManPage.isAvailable ?= $(if $(shell command -v man 2>/dev/null),yes)
# ManPage.isGNU expands to "yes" when man is the GNU man implementation, with various additional options over BSD.
ManPage.isGNU ?= $(if $(and $(ManPage.isAvailable),$(shell man --help 2>&1 | grep -F -- --warning)),yes)

# GNU man can be used to perform rudimentary validation of manual pages.
ifeq ($(ManPage.isGNU),yes)
# Set of arcane options that turn GNU troff into a validator.
%.man-check: ManPage.manOpts += --warnings=all
%.man-check: ManPage.manOpts += --encoding=UTF-8
%.man-check: ManPage.manOpts += --troff-device=utf8
%.man-check: ManPage.manOpts += --ditroff
%.man-check: ManPage.manOpts += --local-file
.PHONY: %.man-check
%.man-check: %
	$(call Silent.Say,MAN,$<)
	$(Silent.Command)LC_ALL=C MANROFFSEQ= MANWIDTH=80 man $(ManPage.manOpts) $< 2>&1 >/dev/null | sed -e 's@tbl:<standard input>@$*@g'
static-check-manpages::
static-check:: static-check-manpages
endif

ManPage.Variables=Section
define ManPage.Template
$1.Section ?= $$(patsubst .%,%,$$(suffix $1))
$1.InstallDir = $$(if $$(man$$($1.Section)dir),$$(man$$($1.Section)dir),$$(error unknown section $$($1.Section)))
$1.InstallMode = 0644
$$(eval $$(call ZMK.Expand,InstallUninstall,$1))
static-check-manpages:: $1.man-check
endef
