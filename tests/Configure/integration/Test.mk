#!/usr/bin/make -f
include zmk/internalTest.mk

t:: integration 

# Test logs will contain debugging messages specific to the configure module
%.log: ZMK.makeOverrides += DEBUG=configure

integration: integration.log
	GREP -qFx 'DEBUG: ZMK.SrcDir=$(ZMK.test.SrcDir)' <$<
	GREP -qFx 'DEBUG: ZMK.IsOutOfTreeBuild=$(ZMK.test.IsOutOfTreeBuild)' <$<
	GREP -qFx 'DEBUG: ZMK.OutOfTreeSourcePath=$(ZMK.test.OutOfTreeSourcePath)' <$<
