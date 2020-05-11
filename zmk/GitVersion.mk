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

# Craft a better version if we have Git.

VERSION_static := $(VERSION)
$(if $(findstring version,$(DEBUG)),$(info DEBUG: VERSION_static=$(VERSION_static)))

# Note that we never generate this file from any rule in zmk!
# The source tree contains the .version file then it is authoritative.
ifneq (,$(wildcard $(srcdir)/.version))
VERSION_dot_version_file = $(shell cat $(srcdir)/.version 2>/dev/null)
$(if $(findstring version,$(DEBUG)),$(info DEBUG: VERSION_dot_version_file=$(VERSION_dot_version_file)))
VERSION = $(or $(VERSION_dot_version_file),$(VERSION_static))
else
ifneq (,$(and $(shell command -v git 2>/dev/null),$(wildcard $(srcdir)/.git)))
# If we have the git program and the .git directory then we can also ask git.
VERSION_git = $(shell GIT_DIR=$(srcdir)/.git git describe --abbrev=10 --tags 2>/dev/null | sed -e 's/^v//')
# Check if we are under CI (Travis/GitHub Actions) then error if partial checkouts are used.
ifneq ($(origin CI),undefined)
$(if $(VERSION_git),,$(error zmk cannot compute project version from git, did the CI system use shallow clone?))
endif
$(if $(findstring version,$(DEBUG)),$(info DEBUG: VERSION_git=$(VERSION_git)))
VERSION = $(or $(VERSION_git),$(VERSION_static))
$(srcdir)/.version-from-git: $(srcdir)/.git
	echo $(VERSION_git) >$@
endif
endif
$(if $(findstring version,$(DEBUG)),$(info DEBUG: definition of VERSION=$(value VERSION)))
