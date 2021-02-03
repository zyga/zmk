# Copyright 2019-2021 Zygmunt Krynicki.
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

# Sources are not re-defined with := so that they can expand lazily.
ClangTidy.Sources ?= $(error define ClangTidy.Sources - the list of source files to analyze with ClangTidy)
# NOTE: Strip out the out-of-tree-source-path so that all the $1.sources (note
# the lower-case) variables use source-relative paths. This is important when
# we want to derive object paths using source paths (same file with .o
# extension replaced but rooted at the build tree, not the source tree). When
# ZMK needs to support generated source files this should be changed.
ClangTidy.sources = $(patsubst $(ZMK.OutOfTreeSourcePath)%,%,$(ClangTidy.Sources))
ClangTidy.Options ?=

# If we have cppcheck then run it during static checks.
ifneq (,$(shell command -v clang-tidy 2>/dev/null))
static-check:: static-check-clang-tidy
endif

static-check:: static-check-clang-tidy
.PHONY: static-check-clang-tidy
static-check-clang-tidy: $(ClangTidy.sources)
	$(call Silent.Say,CLANG-TIDY)
	$(Silent.Command)clang-tidy $(ClangTidy.Options) $^$(if $(CPPFLAGS), -- $(CPPFLAGS))
