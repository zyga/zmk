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

$(eval $(call ZMK.Import,Silent))
$(eval $(call ZMK.Import,Directories))
$(eval $(call ZMK.Import,Toolchain))
$(eval $(call ZMK.Import,OS))

# xcrun is the helper for accessing toolchain programs on MacOS
# It is defined as empty for non-Darwin build environments.
xcrun ?=

ifeq ($(OS.Kernel),Darwin)
# MacOS uses xcrun helper for some toolchain binaries.
xcrun := xcrun
endif


clean::
	$(call Silent.Say,RM,*.profdata *.profraw)
	$(Silent.Command)rm -f *.profdata *.profraw

Program.Test.Variables=Sources SourcesCoverage InstallDir InstallMode
define Program.Test.Template
$1.SourcesCoverage ?= $$(error define $1.SourcesCoverage - the list of source files to include in coverage analysis)
$$(eval $$(call ZMK.Expand,Program,$1))

# If we are using gcc or clang, build with debugging symbols.
ifneq (,$$(or $$(Toolchain.IsGcc),$$(Toolchain.IsClang)))
$1$$(exe): CFLAGS += -g
endif

# If we are not cross-compiling, run the test program on "make check"
check:: $1$$(exe)
ifneq (,$$(Toolchain.IsCross))
	@echo "not executing test program $$<$$(exe) when cross-compiling"
else
	$$(call Silent.Say,EXEC,$$<)
	$$(Silent.Command)./$$<
endif


# If we are not cross-compiling, and stars align, support coverage analysis.
ifeq (,$$(Toolchain.IsCross))
# Support coverage analysis when building with clang and supplied with llvm
# or when using xcrun.
ifneq (,$$(or $$(xcrun),$$(and $$(Toolchain.IsClang),$$(shell command -v llvm-cov 2>/dev/null),$$(shell command -v llvm-profdata 2>/dev/null))))
# Build test program with code coverage measurements and show them via "coverage" target.
$1$$(exe): CFLAGS += -fcoverage-mapping -fprofile-instr-generate
$1$$(exe): LDFLAGS += -fcoverage-mapping -fprofile-instr-generate

$1.profraw: %.profraw: %
	$$(call Silent.Say,EXEC-TEST,$$^)
	$$(Silent.Command)LLVM_PROFILE_FILE=$$@ ./$$^
$1.profdata: %.profdata: %.profraw
	$$(call Silent.Say,LLVM-PROFDATA,$$@)
	$$(Silent.Command)$$(strip $$(xcrun) llvm-profdata merge -sparse $$< -o $$@)
coverage:: $1.profdata
	$$(call Silent.Say,LLVM-COV,$$<)
	$$(Silent.Command)$$(strip $$(xcrun) llvm-cov show ./$1$$(exe) -instr-profile=$$< $$(addprefix $$(ZMK.SrcDir)/,$$($1.SourcesCoverage)))

.PHONY: coverage-todo
coverage-todo:: $1.profdata
	$$(call Silent.Say,LLVM-COV,$$<)
	$$(Silent.Command)$$(strip $$(xcrun) llvm-cov show ./$1$$(exe) -instr-profile=$$< -region-coverage-lt=100 $$(addprefix $$(ZMK.SrcDir)/,$$($1.SourcesCoverage)))

.PHONY: coverage-report
coverage-report:: $1.profdata
	$$(call Silent.Say,LLVM-COV,$$<)
	$$(Silent.Command)$$(strip $$(xcrun) llvm-cov report ./$1$$(exe) -instr-profile=$$< $$(addprefix $$(ZMK.SrcDir)/,$$($1.SourcesCoverage)))
endif # can use llvm-cov
endif # not-cross-compiling
endef
