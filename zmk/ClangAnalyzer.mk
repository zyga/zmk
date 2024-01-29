# Copyrigth 2019-2024 Zygmunt Krynicki.
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
ClangAnalyzer.Sources ?= $(error define ClangAnalyzer.Sources - the list of source files to analyze with clang-analyzer/scan-build)
# NOTE: Strip out the out-of-tree-source-path so that all the $1.sources (note
# the lower-case) variables use source-relative paths. This is important when
# we want to derive object paths using source paths (same file with .o
# extension replaced but rooted at the build tree, not the source tree). When
# ZMK needs to support generated source files this should be changed.
ClangAnalyzer.sources = $(patsubst $(ZMK.OutOfTreeSourcePath)%,%,$(ClangAnalyzer.Sources))
ClangAnalyzer.Options ?=

# If we have scan-build then run it during static checks.
ifneq (,$(shell command -v scan-build 2>/dev/null))
static-check:: static-check-clang-analyzer
endif

.PHONY: static-check-clang-analyzer
static-check-clang-analyzer: $(ClangAnalyzer.sources)
	$(call Silent.Say,CLANG-ANALYZER)
	$(Silent.Command)scan-build $(ClangAnalyzer.Options) $(MAKE) ZMK.NoBanner=1 -B
