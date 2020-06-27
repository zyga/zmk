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
endef

# Find the path of the zmk installation
ZMK.Path := $(abspath $(dir $(lastword $(MAKEFILE_LIST)))/..)

# Put extra test tools on PATH
export PATH := $(ZMK.Path)/tests/bin:$(PATH)

# Make overrides can be used in order to test specific behavior
ZMK.makeOverrides ?=

# Make target can be customized for each log file.
# For default logic, see the rule below.
ZMK.makeTarget ?=

# Tests print a header, unless silent mode is used
# Tests do not use localization
# Tests always remake targets
# Tests print commands instead of invoking them
# Tests do not mention directory changes
# Tests warn about undefined variables
%.log: MAKEFLAGS=Bn
%.log: Test.mk Makefile $(ZMK.Path)/z.mk $(wildcard $(ZMK.Path)/zmk/*.mk)
	$(strip LANG=C $(MAKE) $(ZMK.makeOverrides) -I $(ZMK.Path) \
		--warn-undefined-variables \
		--always-make \
		--dry-run \
		$(or $(ZMK.makeTarget),$(firstword $(subst -, ,$*))) >$@ 2>&1) || true

configure: $(ZMK.Path)/zmk/internalTest.mk

c::
	rm -f *.log
