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
$(eval $(call import,Module.toolchain))

clean::
	rm -f *.profdata *.profraw

Template.program.test.variables=sources sources_coverage objects install_dir
define Template.program.test.spawn
$1.sources ?= $$(error define $1.sources - the list of source files to compile as a test program)
$1.sources_coverage ?= $$(error define $1.sources_coverage - the list of source files to include in coverage analysis)
$1.objects ?= $$(patsubst %.c,$1-%.o,$$($1.sources))
$1.install_dir ?= $$(bindir)
$$(eval $$(call spawn,Template.program,$1))

ifneq (,$$(or $$(Toolchain.is_gcc),$$(Toolchain.is_clang)))
$1$$(exe): CFLAGS += -g
endif

check:: $1$$(exe)
ifeq ($$(BUILD_ARCH_TRIPLET),$$(HOST_ARCH_TRIPLET))
	./$$<
else
	echo "not executing test program $$<$$(exe) when cross-compiling"
endif

ifeq (,$$(Toolchain.Cross))
# Support coverage analysis when building with clang and supplied with llvm
# or when using xcrun.
ifneq (,$$(or $$(xcrun),$$(and $$(findstring clang,$$(CC)),$$(shell command -v llvm-cov 2>/dev/null),$$(shell command -v llvm-profdata 2>/dev/null))))
# Build test program with code coverage measurements and show them via "coverage" target.
$1$$(exe): CFLAGS += -fcoverage-mapping -fprofile-instr-generate
$1$$(exe): LDFLAGS += -fcoverage-mapping -fprofile-instr-generate
$1.profraw: %.profraw: %
	LLVM_PROFILE_FILE=$$@ ./$$^
$1.profdata: %.profdata: %.profraw
	$$(strip $$(xcrun) llvm-profdata merge -sparse $$< -o $$@)
coverage:: $1.profdata
	$$(strip $$(xcrun) llvm-cov show ./$1$$(exe) -instr-profile=$$< $$(addprefix $$(srcdir)/,$$($1.sources_coverage)))

.PHONY: coverage-todo
coverage-todo:: $1.profdata
	$$(strip $$(xcrun) llvm-cov show ./$1$$(exe) -instr-profile=$$< -region-coverage-lt=100 $$(addprefix $$(srcdir)/,$$($1.sources_coverage)))

.PHONY: coverage-report
coverage-report:: $1.profdata
	$$(strip $$(xcrun) llvm-cov report ./$1$$(exe) -instr-profile=$$< $$(addprefix $$(srcdir)/,$$($1.sources_coverage)))
endif # can use llvv-cov
endif # not-cross-compiling
endef
