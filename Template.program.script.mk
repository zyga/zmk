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

# Shellcheck can be used to check scripts
ifneq ($(shell command -v shellcheck 2>/dev/null),)
static-check-shellcheck:
	shellcheck $^
static-check:: static-check-shellcheck
endif

Template.program.script.variables=interp install_dir
define Template.program.script.spawn
$1.interp ?= $$(error define $1.interp - the interpreter name (sh, bash or other))
$1.install_dir ?= $$(bindir)
$$(eval $$(call spawn,Template.data,$1))
ifneq ($$(findstring $$($1.interp),sh bash),)
static-check-shellcheck: $1
endif
endef


