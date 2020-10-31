# NOTE: This file is not a part of the public ZMK API.
# It is used by zmk self-test suite and it is provided here for convenience.

# Tests are grouped under the "t" target
.PHONY: t
t::

# Pretend that GCC is installed.
# This shields the test from whatever is installed on the host.
define ZMK.isolateHostToolchain
%.log: ZMK.makeOverrides += Toolchain.CC.IsAvailable=yes
%.log: ZMK.makeOverrides += Toolchain.CXX.IsAvailable=yes
%.log: ZMK.makeOverrides += Toolchain.CC.IsGcc=yes
%.log: ZMK.makeOverrides += Toolchain.CXX.IsGcc=yes
%.log: ZMK.makeOverrides += Toolchain.cc.dumpmachine=
%.log: ZMK.makeOverrides += Toolchain.gcc.dumpmachine=
%.log: ZMK.makeOverrides += Toolchain.cxx.dumpmachine=
%.log: ZMK.makeOverrides += Toolchain.g++.dumpmachine=
endef

# Find the path of the zmk installation
ZMK.test.Path := $(abspath $(dir $(lastword $(MAKEFILE_LIST)))/..)

# Location of the source tree, for out-of-tree testing.
ZMK.test.SrcDir ?= .

# For consistency with real z.mk
ifneq ($(ZMK.test.SrcDir),.)
ZMK.test.IsOutOfTreeBuild = yes
ZMK.test.OutOfTreeSourcePath = $(ZMK.test.SrcDir)/
VPATH = $(ZMK.test.SrcDir)
else
ZMK.test.IsOutOfTreeBuild =
ZMK.test.OutOfTreeSourcePath =
endif

# Put extra test tools on PATH
export PATH := $(ZMK.test.Path)/tests/bin:$(PATH)

# Make overrides can be used in order to test specific behavior
ZMK.makeOverrides ?=

# Indicate that we are testing ZMK.
# In specific cases, we may want to know this.
ZMK.makeOverrides += ZMK.testing=yes

# Make target can be customized for each log file.
# For default logic, see the rule below.
ZMK.makeTarget ?=

# Tests print a header, unless silent mode is used
# Tests do not use localization
# Tests always remake targets
# Tests print commands instead of invoking them
# Tests do not mention directory changes
# Tests warn about undefined variables
%.log: MAKEFLAGS=
%.log: Test.mk Makefile $(ZMK.test.Path)/z.mk $(wildcard $(ZMK.test.Path)/zmk/*.mk)
	@printf '\n### Log file %s ###\n\n' "$@"
	# Log creation: run make with appropriate options for the test case
	$(strip LANG=C $(MAKE) -Bn $(ZMK.makeOverrides) \
		-I $(ZMK.test.Path) \
		ZMK.SrcDir=$(ZMK.test.SrcDir) \
		--warn-undefined-variables \
		--always-make \
		--dry-run \
		-f $(ZMK.test.SrcDir)/Makefile \
		$(or $(ZMK.makeTarget),$(firstword $(subst -, ,$*))) >$@ 2>&1 || true)
	# Log analysis: detect references to undefined variables
	if grep -F 'warning: undefined variable' $@; then exit 1; fi
	# Log analysis: detect attempted usage of missing programs
	if grep -F 'Command not found' $@; then exit 1; fi

$(CURDIR)/configure configure: $(ZMK.test.Path)/zmk/internalTest.mk

c::
	$(Silent.Say,RM,*.log)
	$(Silent.Command)rm -f *.log
