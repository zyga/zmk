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

VERSION_static ?= $(VERSION)

# If we have the git program and the .git directory then we can just ask git.
ifneq (,$(and $(shell command -v git 2>/dev/null),$(wildcard $(srcdir)/.git)))
VERSION_static := $(VERSION)
VERSION := $(shell GIT_DIR=$(srcdir)/.git git describe --abbrev=10 --tags)
else
# If we don't have .git directory and the git program, but we have the
# .version-from-git file, then use that instead.
ifneq ($(wildcard $(srcdir)/.version-from-git),)
VERSION_static := $(VERSION)
VERSION := $(shell cat $(srcdir)/.version-from-git)
endif
endif

# Define additional target that is useful for tarballs.
$(srcdir)/.version-from-git: $(srcdir)/.git
	GIT_DIR=$< git describe --abbrev=10 --tags > $@

$(if $(findstring git-version,$(DEBUG)),$(info DEBUG: git defines VERSION=$(VERSION)))
$(if $(findstring git-version,$(DEBUG)),$(info DEBUG: git defines VERSION_static=$(VERSION_static)))
