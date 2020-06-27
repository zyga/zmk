#!/usr/bin/make -f
include zmk/internalTest.mk

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
	# By default CC=cc and CXX is either c++ or g++.
	GREP -qFx 'DEBUG: CC=cc' <$<
	GREP -qx 'DEBUG: CXX=[cg][+][+]' <$<

debug-dependency-tracking.log: ZMK.makeOverrides += Configure.DependencyTracking=yes
debug-dependency-tracking: debug-dependency-tracking.log
	# By defualt dependency tracking is enabled.
	GREP -qFx 'DEBUG: Toolchain.DependencyTracking=yes' <$<

debug-mingw-cc-detection.log: ZMK.makeOverrides += CC=fake-fake-mingw32-gcc
debug-mingw-cc-detection.log: ZMK.makeOverrides += Toolchain.cc.dumpmachine=fake-fake-mingw32
debug-mingw-cc-detection: debug-mingw-cc-detection.log
	# When CC is set to a mingw C compiler, then the image format is PE
	# and the toolchain is assumed to be a cross toolchain.
	# TODO: add a variant of this test that does not toggle cross
	# compilation condition from Windows.
	GREP -qFx 'DEBUG: .exe suffix enabled because fake-fake-mingw32-gcc -dumpmachine mentions mingw' <$<
	GREP -qFx 'DEBUG: cross-compiling because gcc -dumpmachine and fake-fake-mingw32-gcc -dumpmachine differ' <$<
	GREP -qFx 'DEBUG: Toolchain.CC.ImageFormat=PE' <$<
	GREP -qFx 'DEBUG: Toolchain.CC.IsCross=yes' <$<
	GREP -qFx 'DEBUG: Toolchain.ImageFormat=Mixed' <$<
	GREP -qFx 'DEBUG: Toolchain.IsCross=yes' <$<

debug-mingw-cxx-detection.log: ZMK.makeOverrides += CXX=fake-fake-mingw32-g++
debug-mingw-cxx-detection.log: ZMK.makeOverrides += Toolchain.cxx.dumpmachine=fake-fake-mingw32
debug-mingw-cxx-detection: debug-mingw-cxx-detection.log
	# When CXX is set to a mingw C++ compiler, then the image format is PE
	# and the toolchain is assumed to be a cross toolchain.
	# TODO: add a variant of this test that does not toggle cross
	# compilation condition from Windows.
	GREP -qFx 'DEBUG: .exe suffix enabled because fake-fake-mingw32-g++ -dumpmachine mentions mingw' <$<
	GREP -qFx 'DEBUG: cross-compiling because g++ -dumpmachine and fake-fake-mingw32-g++ -dumpmachine differ' <$<
	GREP -qFx 'DEBUG: Toolchain.CXX.ImageFormat=PE' <$<
	GREP -qFx 'DEBUG: Toolchain.CXX.IsCross=yes' <$<
	GREP -qFx 'DEBUG: Toolchain.ImageFormat=Mixed' <$<
	GREP -qFx 'DEBUG: Toolchain.IsCross=yes' <$<

debug-watcom-dos-cc-detection.log: ZMK.makeOverrides += CC=open-watcom.owcc-dos
debug-watcom-dos-cc-detection.log: ZMK.makeOverrides += Toolchain.cc=/snap/open-watcom.owcc-dos
debug-watcom-dos-cc-detection: debug-watcom-dos-cc-detection.log
	# When CC is set to a OpenWatcom C compiler targetting DOS,
	# then the image format is MZ and the toolchain is assumed to be a
	# cross toolchain.
	GREP -qFx 'DEBUG: .exe suffix enabled because open-watcom.owcc-dos name' <$<
	GREP -qFx 'DEBUG: cross-compiling because Watcom targets DOS' <$<
	GREP -qFx 'DEBUG: Toolchain.CC.ImageFormat=MZ' <$<
	GREP -qFx 'DEBUG: Toolchain.CC.IsCross=yes' <$<
	GREP -qFx 'DEBUG: Toolchain.ImageFormat=Mixed' <$<
	GREP -qFx 'DEBUG: Toolchain.IsCross=yes' <$<

debug-watcom-dos-cxx-detection.log: ZMK.makeOverrides += CXX=open-watcom.owcc-dos
debug-watcom-dos-cxx-detection.log: ZMK.makeOverrides += Toolchain.cxx=/snap/open-watcom.owcc-dos
debug-watcom-dos-cxx-detection: debug-watcom-dos-cxx-detection.log
	# When CXX is set to a OpenWatcom C++ compiler targetting DOS,
	# then the image format is MZ and the toolchain is assumed to be a
	# cross toolchain.
	GREP -qFx 'DEBUG: .exe suffix enabled because open-watcom.owcc-dos name' <$<
	GREP -qFx 'DEBUG: cross-compiling because Watcom targets DOS' <$<
	GREP -qFx 'DEBUG: Toolchain.CXX.ImageFormat=MZ' <$<
	GREP -qFx 'DEBUG: Toolchain.CXX.IsCross=yes' <$<
	GREP -qFx 'DEBUG: Toolchain.ImageFormat=Mixed' <$<
	GREP -qFx 'DEBUG: Toolchain.IsCross=yes' <$<

debug-watcom-win16-cc-detection.log: ZMK.makeOverrides += CC=open-watcom.owcc-win16
debug-watcom-win16-cc-detection.log: ZMK.makeOverrides += Toolchain.cc=/snap/open-watcom.owcc-win16
debug-watcom-win16-cc-detection: debug-watcom-win16-cc-detection.log
	# When CC is set to a OpenWatcom C compiler targetting Windows 3.x,
	# then the image format is MZ and the toolchain is assumed to be a
	# cross toolchain.
	GREP -qFx 'DEBUG: .exe suffix enabled because open-watcom.owcc-win16 name' <$<
	GREP -qFx 'DEBUG: cross-compiling because Watcom targets DOS' <$<
	GREP -qFx 'DEBUG: Toolchain.CC.ImageFormat=MZ' <$<
	GREP -qFx 'DEBUG: Toolchain.CC.IsCross=yes' <$<
	GREP -qFx 'DEBUG: Toolchain.ImageFormat=Mixed' <$<
	GREP -qFx 'DEBUG: Toolchain.IsCross=yes' <$<

debug-watcom-win16-cxx-detection.log: ZMK.makeOverrides += CXX=open-watcom.owcc-win16
debug-watcom-win16-cxx-detection.log: ZMK.makeOverrides += Toolchain.cxx=/snap/open-watcom.owcc-win16
debug-watcom-win16-cxx-detection: debug-watcom-win16-cxx-detection.log
	# When CXX is set to a OpenWatcom C++ compiler targetting Windows 3.x,
	# then the image format is MZ and the toolchain is assumed to be a
	# cross toolchain.
	GREP -qFx 'DEBUG: .exe suffix enabled because open-watcom.owcc-win16 name' <$<
	GREP -qFx 'DEBUG: cross-compiling because Watcom targets DOS' <$<
	GREP -qFx 'DEBUG: Toolchain.CXX.ImageFormat=MZ' <$<
	GREP -qFx 'DEBUG: Toolchain.CXX.IsCross=yes' <$<
	GREP -qFx 'DEBUG: Toolchain.ImageFormat=Mixed' <$<
	GREP -qFx 'DEBUG: Toolchain.IsCross=yes' <$<

debug-watcom-win32-cc-detection.log: ZMK.makeOverrides += CC=open-watcom.owcc-win32
debug-watcom-win32-cc-detection.log: ZMK.makeOverrides += Toolchain.cc=/snap/open-watcom.owcc-win32
debug-watcom-win32-cc-detection: debug-watcom-win32-cc-detection.log
	# When CC is set to a OpenWatcom C compiler targetting Windows NT,
	# then the image format is PE and the toolchain is assumed to be a
	# cross toolchain.
	GREP -qFx 'DEBUG: .exe suffix enabled because open-watcom.owcc-win32 name' <$<
	GREP -qFx 'DEBUG: cross-compiling because Watcom targets Windows' <$<
	GREP -qFx 'DEBUG: Toolchain.CC.ImageFormat=PE' <$<
	GREP -qFx 'DEBUG: Toolchain.CC.IsCross=yes' <$<
	GREP -qFx 'DEBUG: Toolchain.ImageFormat=Mixed' <$<
	GREP -qFx 'DEBUG: Toolchain.IsCross=yes' <$<

debug-watcom-win32-cxx-detection.log: ZMK.makeOverrides += CXX=open-watcom.owcc-win32
debug-watcom-win32-cxx-detection.log: ZMK.makeOverrides += Toolchain.cxx=/snap/open-watcom.owcc-win32
debug-watcom-win32-cxx-detection: debug-watcom-win32-cxx-detection.log
	# When CXX is set to a OpenWatcom C++ compiler targetting Windows NT,
	# then the image format is PE and the toolchain is assumed to be a
	# cross toolchain.
	GREP -qFx 'DEBUG: .exe suffix enabled because open-watcom.owcc-win32 name' <$<
	GREP -qFx 'DEBUG: cross-compiling because Watcom targets Windows' <$<
	GREP -qFx 'DEBUG: Toolchain.CXX.ImageFormat=PE' <$<
	GREP -qFx 'DEBUG: Toolchain.CXX.IsCross=yes' <$<
	GREP -qFx 'DEBUG: Toolchain.ImageFormat=Mixed' <$<
	GREP -qFx 'DEBUG: Toolchain.IsCross=yes' <$<

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
	# When the configue script selects different linux build and host
	# machines, then both the C and C++ compilers are set to the
	# appropriate GCC binary, then image format is ELF and the toolchain is
	# assumed to be a cross toolchain.
	GREP -qFx 'DEBUG: gcc cross-compiler selected CC=host-linux-gnu-gcc' <$<
	GREP -qFx 'DEBUG: cross-compiling because gcc -dumpmachine and host-linux-gnu-gcc -dumpmachine differ' <$<
	GREP -qFx 'DEBUG: Toolchain.CC.ImageFormat=ELF' <$<
	GREP -qFx 'DEBUG: Toolchain.CC.IsCross=yes' <$<
	GREP -qFx 'DEBUG: Toolchain.ImageFormat=ELF' <$<
	GREP -qFx 'DEBUG: Toolchain.IsCross=yes' <$<

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
	# When the configue script selects different linux build and host
	# machines, then both the C and C++ compilers are set to the
	# appropriate GCC binary, the image format is ELF and the toolchain is
	# assumed to be a cross toolchain.
	GREP -qFx 'DEBUG: g++ cross-compiler selected CXX=host-linux-gnu-g++' <$<
	GREP -qFx 'DEBUG: cross-compiling because g++ -dumpmachine and host-linux-gnu-g++ -dumpmachine differ' <$<
	GREP -qFx 'DEBUG: Toolchain.CXX.ImageFormat=ELF' <$<
	GREP -qFx 'DEBUG: Toolchain.CXX.IsCross=yes' <$<
	GREP -qFx 'DEBUG: Toolchain.ImageFormat=ELF' <$<
	GREP -qFx 'DEBUG: Toolchain.IsCross=yes' <$<
