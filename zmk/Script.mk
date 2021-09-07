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

ZMK.shellcheck ?= $(shell command -v shellcheck 2>/dev/null)
static-check-shellcheck:
ifneq (,$(ZMK.shellcheck))
	$(call Silent.Say,SHELLCHECK,$^)
	$(Silent.Command)$(ZMK.shellcheck) $^
else
	@echo "ZMK: install shellcheck to analyze $^"
endif
static-check:: static-check-shellcheck

Script.Variables=Interpreter InstallDir InstallMode
define Script.Template
$1.InstallDir ?= $$(bindir)
$1.InstallMode ?= 0755
ifneq (,$$(filter Configure,$$(ZMK.ImportedModules)))
$1.InstallName ?= $$(if $$(Configure.ProgramTransformName),$$(shell echo '$$(Configure.ProgramPrefix)$$(notdir $1)$$(Configure.ProgramSuffix)' | sed -e '$$(Configure.ProgramTransformName)'),$$(Configure.ProgramPrefix)$$(notdir $1)$$(Configure.ProgramSuffix))
endif
$$(eval $$(call ZMK.Expand,InstallUninstall,$1))

$1.Interpreter ?= $$(if $$(suffix $1),$$(patsubst .%,%,$$(suffix $1)),$$(error define $1.Interpreter - the script interpreter name, sh, bash or other))
ifneq ($$(findstring $$($1.Interpreter),sh bash),)
static-check-shellcheck: $1
endif

endef
