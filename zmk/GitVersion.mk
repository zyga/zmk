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

# Craft a better version if we have Git.

GitVersion.debug ?= $(findstring version,$(DEBUG))
GitVersion.versionFilePresent = $(if $(wildcard $(ZMK.SrcDir)/.version),yes)
GitVersion.gitAvailable ?= $(if $(shell command -v git 2>/dev/null),yes)
GitVersion.gitMetaDataPresent ?= $(if $(wildcard $(ZMK.SrcDir)/.git),yes)
GitVersion.versionFromMakefile := $(strip $(VERSION))
GitVersion.versionFromFile =
GitVersion.versionFromGit =
GitVersion.Active =
GitVersion.Origin =

ifeq (yes,$(GitVersion.versionFilePresent))
# Note that we never generate this file from any rule in zmk!
# If the source tree contains the .version file then it is authoritative.
GitVersion.versionFromFile:=$(shell cat $(ZMK.SrcDir)/.version 2>/dev/null)
GitVersion.Origin = file
else
ifeq (yes,$(and $(GitVersion.gitAvailable),$(GitVersion.gitMetaDataPresent)))
# If we have the git program and the .git directory then we can also ask git.
GitVersion.versionFromGit=$(shell GIT_DIR=$(ZMK.SrcDir)/.git git describe --abbrev=10 --tags 2>/dev/null | sed -e 's/^v//')
GitVersion.Origin = git
ifneq (,$(value CI))
# If we are in CI and git version was empty then perhaps this is a shallow clone?
ifeq (,$(GitVersion.versionFromGit))
$(error zmk cannot compute project version from git, did the CI system use a shallow clone?))
endif # ! git version
endif # ! CI
endif # version from git
endif # !version from version file

# If we have a version from git, offer a rule that writes it to the source
# tree. This file is picked up by the Tarball.Src module and internally renamed
# to .version inside the archive. When we see the .version file we do not look
# for git information anymore, as it may no longer be the "same" git history.
ifneq (,$(GitVersion.versionFromGit))
$(ZMK.SrcDir)/.version-from-git: $(ZMK.SrcDir)/.git
	$(call Silent.Say,GIT-VERSION,$@)
	$(Silent.Command)echo $(GitVersion.versionFromGit) >$@
endif

# Set the new effective VERSION.
VERSION=$(or $(GitVersion.versionFromFile),$(GitVersion.versionFromGit),$(GitVersion.versionFromMakefile))

# If the effective version is different from the version in the makefile then
# set the active flag. This information is used by the Tarball.Src module.
ifneq ($(VERSION),$(GitVersion.versionFromMakefile))
GitVersion.Active = yes
endif

$(if $(GitVersion.debug),$(foreach v,versionFilePresent gitAvailable gitMetaDataPresent versionFromMakefile versionFromFile versionFromGit Active,$(info DEBUG: GitVersion.$v=$(GitVersion.$v))))
$(if $(GitVersion.debug),$(info DEBUG: effective VERSION=$(VERSION)))
