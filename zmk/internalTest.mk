# NOTE: This file is not a part of the public ZMK API.
# It is used by zmk self-test suite and it is provided here for convenience.

# Tests are grouped under the "t" target
.PHONY: t
t::

# Pretend that GCC is installed.
# This shields the test from whatever is installed on the host.
define ZMK.isolateHostToolchain
%.log: ZMK.makeOverrides += Toolchain.CC.IsAvailable=yes
%.log: ZMK.makeOverrides += Toolchain.CC.IsClang=
%.log: ZMK.makeOverrides += Toolchain.CC.IsGcc=yes
%.log: ZMK.makeOverrides += Toolchain.CXX.IsAvailable=yes
%.log: ZMK.makeOverrides += Toolchain.CXX.IsClang=
%.log: ZMK.makeOverrides += Toolchain.CXX.IsGcc=yes
%.log: ZMK.makeOverrides += Toolchain.IsClang=
%.log: ZMK.makeOverrides += Toolchain.cc.dumpmachine=
%.log: ZMK.makeOverrides += Toolchain.cc.version=
%.log: ZMK.makeOverrides += Toolchain.cxx.dumpmachine=
%.log: ZMK.makeOverrides += Toolchain.cxx.version=
%.log: ZMK.makeOverrides += Toolchain.g++.dumpmachine=
%.log: ZMK.makeOverrides += Toolchain.gcc.dumpmachine=
endef

# Find the path of the zmk installation
ZMK.test.Path := $(or $(wildcard /usr/local/share/zmk),$(abspath $(dir $(lastword $(MAKEFILE_LIST)))/..))

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

ifeq ($(origin OS),environment)
OS.test.Kernel = $(findstring $(OS),Windows_NT)
else
OS.test.Kernel := $(shell uname -s)
endif

# Read a file from disk. Ideally we'd use $(file <) but it doesn't have a
# feature flag to check for and widely used systems do not support reading.
ZMK.test.readFile=$(shell cat "$1")
# Pick a key from a string with key=value pairs
ZMK.test.valueOfKey=$(strip $(patsubst $2=%,%,$(filter $2=%,$1)))

# Use real os-release(5) information if available or synthesize minimal placeholder.
ifneq (,$(findstring $(OS.test.Kernel),Linux FreeBSD NetBSD OpenBSD GNU GNU/kFreeBSD SunOS))
ZMK.test.OSRelease=$(or $(call ZMK.test.readFile,/etc/os-release),$(error zmk integration tests depends on /etc/os-release))
else ifeq ($(OS.test.Kernel),Darwin)
ZMK.test.OSRelease=ID=macos VERSION_ID=$(word 2,$(shell sysctl kern.osproductversion))
else ifeq ($(OS.test.Kernel),Haiku)
ZMK.test.OSRelease=ID=haiku VERSION_ID=zmk-unimplemented)
else ifeq ($(OS.test.Kernel),Windows_NT)
ZMK.test.OSRelease=ID=windows VERSION_ID=zmk-unimplemented
endif

# The full text of os-release(5) file.
# The ID field from the os-release(5) file.
ZMK.test.OSRelease.ID=$(call ZMK.test.valueOfKey,$(ZMK.test.OSRelease),ID)
# The VERSION_ID field from the os-release(5) file.
ZMK.test.OSRelease.VERSION_ID=$(call ZMK.test.valueOfKey,$(ZMK.test.OSRelease),VERSION_ID)

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
	if grep -i 'command not found' $@; then exit 1; fi

$(CURDIR)/configure configure: $(ZMK.test.Path)/zmk/internalTest.mk

c::
	$(call Silent.Say,RM,*.log)
	$(Silent.Command)rm -f *.log
