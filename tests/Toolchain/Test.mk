#!/usr/bin/make -f
include ../Common.mk

t:: debug-defaults debug-dependency-tracking \
	debug-mingw-cc-detection debug-mingw-cxx-detection \
	debug-watcom-dos-cc-detection debug-watcom-dos-cxx-detection \
	debug-watcom-win16-cc-detection debug-watcom-win16-cxx-detection \
	debug-watcom-win32-cc-detection debug-watcom-win32-cxx-detection \
	debug-gcc-configured-cross debug-g++-configured-cross \

# Test logs will contain debugging messages
%.log: ZMK.makeOverrides += DEBUG=toolchain

# Isolate from any tools installed on the host.
# This is useful to verify with forkstat(1).
%.log: ZMK.makeOverrides += Toolchain.cc=/usr/bin/host-linux-gnu-gcc
%.log: ZMK.makeOverrides += Toolchain.cc.dumpmachine=host-linux-gnu
%.log: ZMK.makeOverrides += Toolchain.gcc.dumpmachine=build-linux-gnu
%.log: ZMK.makeOverrides += Toolchain.cxx=/usr/bin/host-linux-gnu-g++
%.log: ZMK.makeOverrides += Toolchain.cxx.dumpmachine=host-linux-gnu
%.log: ZMK.makeOverrides += Toolchain.g++.dumpmachine=build-linux-gnu

debug-defaults: debug-defaults.log
	MATCH -qFx 'DEBUG: CC=cc' <$<
	MATCH -qx 'DEBUG: CXX=[cg][+][+]' <$<

debug-dependency-tracking.log: ZMK.makeOverrides += Configure.DependencyTracking=yes
debug-dependency-tracking: debug-dependency-tracking.log
	MATCH -qFx 'DEBUG: Toolchain.DependencyTracking=yes' <$<

debug-mingw-cc-detection.log: ZMK.makeOverrides += CC=fake-fake-mingw32-gcc
debug-mingw-cc-detection.log: ZMK.makeOverrides += Toolchain.cc.dumpmachine=fake-fake-mingw32
debug-mingw-cc-detection: debug-mingw-cc-detection.log
	MATCH -qFx 'DEBUG: .exe suffix enabled because fake-fake-mingw32-gcc -dumpmachine mentions mingw' <$<
	MATCH -qFx 'DEBUG: cross-compiling because gcc -dumpmachine and fake-fake-mingw32-gcc -dumpmachine differ' <$<
	MATCH -qFx 'DEBUG: Toolchain.CC.ImageFormat=PE' <$<
	MATCH -qFx 'DEBUG: Toolchain.CC.IsCross=yes' <$<

debug-mingw-cxx-detection.log: ZMK.makeOverrides += CXX=fake-fake-mingw32-g++
debug-mingw-cxx-detection.log: ZMK.makeOverrides += Toolchain.cxx.dumpmachine=fake-fake-mingw32
debug-mingw-cxx-detection: debug-mingw-cxx-detection.log
	MATCH -qFx 'DEBUG: .exe suffix enabled because fake-fake-mingw32-g++ -dumpmachine mentions mingw' <$<
	MATCH -qFx 'DEBUG: cross-compiling because g++ -dumpmachine and fake-fake-mingw32-g++ -dumpmachine differ' <$<
	MATCH -qFx 'DEBUG: Toolchain.CXX.ImageFormat=PE' <$<
	MATCH -qFx 'DEBUG: Toolchain.CXX.IsCross=yes' <$<

debug-watcom-dos-cc-detection.log: ZMK.makeOverrides += CC=open-watcom.owcc-dos
debug-watcom-dos-cc-detection.log: ZMK.makeOverrides += Toolchain.cc=/snap/open-watcom.owcc-dos
debug-watcom-dos-cc-detection: debug-watcom-dos-cc-detection.log
	MATCH -qFx 'DEBUG: .exe suffix enabled because open-watcom.owcc-dos name' <$<
	MATCH -qFx 'DEBUG: cross-compiling because open-watcom targets DOS' <$<
	MATCH -qFx 'DEBUG: Toolchain.CC.ImageFormat=MZ' <$<
	MATCH -qFx 'DEBUG: Toolchain.CC.IsCross=yes' <$<

debug-watcom-dos-cxx-detection.log: ZMK.makeOverrides += CXX=open-watcom.owcc-dos
debug-watcom-dos-cxx-detection.log: ZMK.makeOverrides += Toolchain.cxx=/snap/open-watcom.owcc-dos
debug-watcom-dos-cxx-detection: debug-watcom-dos-cxx-detection.log
	MATCH -qFx 'DEBUG: .exe suffix enabled because open-watcom.owcc-dos name' <$<
	MATCH -qFx 'DEBUG: cross-compiling because open-watcom targets DOS' <$<
	MATCH -qFx 'DEBUG: Toolchain.CXX.ImageFormat=MZ' <$<
	MATCH -qFx 'DEBUG: Toolchain.CXX.IsCross=yes' <$<

debug-watcom-win16-cc-detection.log: ZMK.makeOverrides += CC=open-watcom.owcc-win16
debug-watcom-win16-cc-detection.log: ZMK.makeOverrides += Toolchain.cc=/snap/open-watcom.owcc-win16
debug-watcom-win16-cc-detection: debug-watcom-win16-cc-detection.log
	MATCH -qFx 'DEBUG: .exe suffix enabled because open-watcom.owcc-win16 name' <$<
	MATCH -qFx 'DEBUG: cross-compiling because open-watcom targets DOS' <$<
	MATCH -qFx 'DEBUG: Toolchain.CC.ImageFormat=MZ' <$<
	MATCH -qFx 'DEBUG: Toolchain.CC.IsCross=yes' <$<

debug-watcom-win16-cxx-detection.log: ZMK.makeOverrides += CXX=open-watcom.owcc-win16
debug-watcom-win16-cxx-detection.log: ZMK.makeOverrides += Toolchain.cxx=/snap/open-watcom.owcc-win16
debug-watcom-win16-cxx-detection: debug-watcom-win16-cxx-detection.log
	MATCH -qFx 'DEBUG: .exe suffix enabled because open-watcom.owcc-win16 name' <$<
	MATCH -qFx 'DEBUG: cross-compiling because open-watcom targets DOS' <$<
	MATCH -qFx 'DEBUG: Toolchain.CXX.ImageFormat=MZ' <$<
	MATCH -qFx 'DEBUG: Toolchain.CXX.IsCross=yes' <$<

debug-watcom-win32-cc-detection.log: ZMK.makeOverrides += CC=open-watcom.owcc-win32
debug-watcom-win32-cc-detection.log: ZMK.makeOverrides += Toolchain.cc=/snap/open-watcom.owcc-win32
debug-watcom-win32-cc-detection: debug-watcom-win32-cc-detection.log
	MATCH -qFx 'DEBUG: .exe suffix enabled because open-watcom.owcc-win32 name' <$<
	MATCH -qFx 'DEBUG: cross-compiling because open-watcom targets Windows' <$<
	MATCH -qFx 'DEBUG: Toolchain.CC.ImageFormat=PE' <$<
	MATCH -qFx 'DEBUG: Toolchain.CC.IsCross=yes' <$<

debug-watcom-win32-cxx-detection.log: ZMK.makeOverrides += CXX=open-watcom.owcc-win32
debug-watcom-win32-cxx-detection.log: ZMK.makeOverrides += Toolchain.cxx=/snap/open-watcom.owcc-win32
debug-watcom-win32-cxx-detection: debug-watcom-win32-cxx-detection.log
	MATCH -qFx 'DEBUG: .exe suffix enabled because open-watcom.owcc-win32 name' <$<
	MATCH -qFx 'DEBUG: cross-compiling because open-watcom targets Windows' <$<
	MATCH -qFx 'DEBUG: Toolchain.CXX.ImageFormat=PE' <$<
	MATCH -qFx 'DEBUG: Toolchain.CXX.IsCross=yes' <$<

debug-gcc-configured-cross.log: ZMK.makeOverrides += Configure.Configured=yes
debug-gcc-configured-cross.log: ZMK.makeOverrides += Configure.HostArchTriplet=host-linux-gnu
debug-gcc-configured-cross.log: ZMK.makeOverrides += Configure.BuildArchTriplet=build-linux-gnu
debug-gcc-configured-cross.log: ZMK.makeOverrides += Toolchain.cc=/usr/bin/host-linux-gnu-gcc
debug-gcc-configured-cross.log: ZMK.makeOverrides += Toolchain.cc.dumpmachine=host-linux-gnu
debug-gcc-configured-cross.log: ZMK.makeOverrides += Toolchain.gcc.dumpmachine=build-linux-gnu
debug-gcc-configured-cross.log: ZMK.makeOverrides += Toolchain.cxx=/usr/bin/host-linux-gnu-g++
debug-gcc-configured-cross.log: ZMK.makeOverrides += Toolchain.cxx.dumpmachine=host-linux-gnu
debug-gcc-configured-cross.log: ZMK.makeOverrides += Toolchain.g++.dumpmachine=build-linux-gnu
debug-gcc-configured-cross: debug-gcc-configured-cross.log
	MATCH -qFx 'DEBUG: gcc cross-compiler selected CC=host-linux-gnu-gcc' <$<
	MATCH -qFx 'DEBUG: cross-compiling because gcc -dumpmachine and host-linux-gnu-gcc -dumpmachine differ' <$<
	MATCH -qFx 'DEBUG: Toolchain.CC.IsCross=yes' <$<
	MATCH -qFx 'DEBUG: Toolchain.CC.ImageFormat=ELF' <$<

debug-g++-configured-cross.log: ZMK.makeOverrides += Configure.Configured=yes
debug-g++-configured-cross.log: ZMK.makeOverrides += Configure.HostArchTriplet=host-linux-gnu
debug-g++-configured-cross.log: ZMK.makeOverrides += Configure.BuildArchTriplet=build-linux-gnu
debug-g++-configured-cross.log: ZMK.makeOverrides += Toolchain.cc=/usr/bin/host-linux-gnu-gcc
debug-g++-configured-cross.log: ZMK.makeOverrides += Toolchain.cc.dumpmachine=host-linux-gnu
debug-g++-configured-cross.log: ZMK.makeOverrides += Toolchain.cxx=/usr/bin/host-linux-gnu-g++
debug-g++-configured-cross.log: ZMK.makeOverrides += Toolchain.cxx.dumpmachine=host-linux-gnu
debug-g++-configured-cross.log: ZMK.makeOverrides += Toolchain.gcc.dumpmachine=build-linux-gnu
debug-g++-configured-cross.log: ZMK.makeOverrides += Toolchain.g++.dumpmachine=build-linux-gnu
debug-g++-configured-cross: debug-g++-configured-cross.log
	MATCH -qFx 'DEBUG: g++ cross-compiler selected CXX=host-linux-gnu-g++' <$<
	MATCH -qFx 'DEBUG: cross-compiling because g++ -dumpmachine and host-linux-gnu-g++ -dumpmachine differ' <$<
	MATCH -qFx 'DEBUG: Toolchain.CXX.IsCross=yes' <$<
	MATCH -qFx 'DEBUG: Toolchain.CXX.ImageFormat=ELF' <$<
