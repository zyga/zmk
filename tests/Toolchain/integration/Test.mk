#!/usr/bin/make -f
include zmk/internalTest.mk

t:: integration 

# Test logs will contain debugging messages
%.log: ZMK.makeOverrides += DEBUG=toolchain

integration: integration.log
ifeq ($(ZMK.test.OSRelease.ID),freebsd)
	GREP -qFx 'DEBUG: Toolchain.CC.ImageFormat=ELF' <$<
	GREP -qFx 'DEBUG: Toolchain.CC.IsAvailable=yes' <$<
	GREP -qFx 'DEBUG: Toolchain.CC.IsClang=yes' <$<
	GREP -qFx 'DEBUG: Toolchain.CC.IsCross=' <$<
	GREP -qFx 'DEBUG: Toolchain.CC.IsGcc=' <$<
	GREP -qFx 'DEBUG: Toolchain.CC.IsTcc=' <$<
	GREP -qFx 'DEBUG: Toolchain.CC.IsWatcom=' <$<
	GREP -qFx 'DEBUG: Toolchain.CXX.ImageFormat=ELF' <$<
	GREP -qFx 'DEBUG: Toolchain.CXX.IsAvailable=yes' <$<
	GREP -qFx 'DEBUG: Toolchain.CXX.IsClang=yes' <$<
	GREP -qFx 'DEBUG: Toolchain.CXX.IsCross=' <$<
	GREP -qFx 'DEBUG: Toolchain.CXX.IsGcc=' <$<
	GREP -qFx 'DEBUG: Toolchain.CXX.IsWatcom=' <$<
	GREP -qFx 'DEBUG: Toolchain.DependencyTracking=yes' <$<
	GREP -qFx 'DEBUG: Toolchain.ImageFormat=ELF' <$<
	GREP -qFx 'DEBUG: Toolchain.IsClang=yes' <$<
	GREP -qFx 'DEBUG: Toolchain.IsCross=' <$<
	GREP -qFx 'DEBUG: Toolchain.IsGcc=' <$<
	GREP -qFx 'DEBUG: Toolchain.IsWatcom=' <$<
	GREP -qFx 'DEBUG: Toolchain.cc=/usr/bin/cc' <$<
	GREP -qFx 'DEBUG: Toolchain.cxx=/usr/bin/c++' <$<
endif
