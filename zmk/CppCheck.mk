# Copyright 2019-2021 Zygmunt Krynicki.
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

$(eval $(call ZMK.Import,Silent))

# Sources are not re-defined with := so that they can expand lazily.
CppCheck.Sources ?= $(error define CppCheck.Sources - the list of source files to analyze with CppCheck)
# NOTE: Strip out the out-of-tree-source-path so that all the $1.sources (note
# the lower-case) variables use source-relative paths. This is important when
# we want to derive object paths using source paths (same file with .o
# extension replaced but rooted at the build tree, not the source tree). When
# ZMK needs to support generated source files this should be changed.
CppCheck.sources = $(patsubst $(ZMK.OutOfTreeSourcePath)%,%,$(CppCheck.Sources))
CppCheck.Options ?= --quiet

# If we have cppcheck then run it during static checks.
ifneq (,$(shell command -v cppcheck 2>/dev/null))
static-check:: static-check-cppcheck
endif

.PHONY: static-check-cppcheck
static-check-cppcheck: $(CppCheck.sources)
	$(call Silent.Say,CPPCHECK)
	$(Silent.Command)cppcheck $(CppCheck.Options) $^
