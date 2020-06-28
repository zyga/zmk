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

ManPage.isAvailable ?= $(if $(shell command -v man 2>/dev/null),yes)
ManPage.isGNU ?= $(if $(and $(ManPage.isAvailable),$(shell man --help 2>&1 | grep -F -- --warning)),yes)
# GNU man can be used to perform rudimentary validation of manual pages.
ifeq ($(ManPage.isGNU),yes)
# Set of arcane options that turn GNU troff into a validator.
# TODO: man is extremely slow, refactor this to support parallelism.
static-check-manpages: export LC_ALL=C
static-check-manpages: export MANROFFSEQ=
static-check-manpages: export MANWIDTH=80
static-check-manpages: man_opts += --warnings=all
static-check-manpages: man_opts += --encoding=UTF-8
static-check-manpages: man_opts += --troff-device=utf8
static-check-manpages: man_opts += --ditroff
static-check-manpages: man_opts += --local-file
static-check-manpages:
	$(foreach m,$^,man $(MAN_OPTS) $m 2>&1 >/dev/null | sed -e 's@tbl:<standard input>@$m@g'$(ZMK.newline))
static-check:: static-check-manpages
endif

ManPage.Variables=Section
define ManPage.Template
$1.Section ?= $$(patsubst .%,%,$$(suffix $1))
$1.InstallDir = $$(if $$(man$$($1.Section)dir),$$(man$$($1.Section)dir),$$(error unknown section $$($1.Section)))
$1.InstallMode = 0644
$$(eval $$(call ZMK.Expand,InstallUninstall,$1))
static-check-manpages: $1
endef
