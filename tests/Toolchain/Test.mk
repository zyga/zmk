include ../Common.mk
export DEBUG = toolchain

# Isolate from host
check-%: TEST_OPTS += Toolchain.cc=/usr/bin/host-linux-gnu-gcc
check-%: TEST_OPTS += Toolchain.cc.dumpmachine=host-linux-gnu
check-%: TEST_OPTS += Toolchain.gcc.dumpmachine=build-linux-gnu
check-%: TEST_OPTS += Toolchain.cxx=/usr/bin/host-linux-gnu-g++
check-%: TEST_OPTS += Toolchain.cxx.dumpmachine=host-linux-gnu
check-%: TEST_OPTS += Toolchain.g++.dumpmachine=build-linux-gnu

.PHONY: check

check:: check-defaults
.PHONY: check-defaults
check-defaults:
	$(TEST_HEADER)
	$(MAKE) $(TEST_OPTS) | MATCH -qF 'DEBUG: CC=cc'
	$(MAKE) $(TEST_OPTS) | MATCH -q 'DEBUG: CXX=[cg][+][+]'

check:: check-dependency-tracking
.PHONY: check-dependency-tracking
check-dependency-tracking:
	$(TEST_HEADER)
	$(MAKE) $(TEST_OPTS) | MATCH -q 'DEBUG: Toolchain.DependencyTracking=$$'
	$(MAKE) $(TEST_OPTS) Configure.DependencyTracking=yes | MATCH -q 'DEBUG: Toolchain.DependencyTracking=yes$$'

check:: check-mingw-cc-detection
.PHONY: check-mingw-cc-detection
check-mingw-cc-detection: TEST_OPTS += CC=fake-fake-mingw32-gcc
check-mingw-cc-detection: TEST_OPTS += Toolchain.cc.dumpmachine=fake-fake-mingw32
check-mingw-cc-detection:
	$(TEST_HEADER)
	$(MAKE) $(TEST_OPTS) | MATCH -qF 'DEBUG: .exe suffix enabled because fake-fake-mingw32-gcc -dumpmachine mentions mingw'
	$(MAKE) $(TEST_OPTS) | MATCH -qF 'DEBUG: cross-compiling because gcc -dumpmachine and fake-fake-mingw32-gcc -dumpmachine differ'
	$(MAKE) $(TEST_OPTS) | MATCH -qF 'DEBUG: Toolchain.CC.ImageFormat=PE'
	$(MAKE) $(TEST_OPTS) | MATCH -qF 'DEBUG: Toolchain.CC.IsCross=yes'

check:: check-mingw-cxx-detection
.PHONY: check-mingw-cxx-detection
check-mingw-cxx-detection: TEST_OPTS += CXX=fake-fake-mingw32-g++
check-mingw-cxx-detection: TEST_OPTS += Toolchain.cxx.dumpmachine=fake-fake-mingw32
check-mingw-cxx-detection:
	$(TEST_HEADER)
	$(MAKE) $(TEST_OPTS) | MATCH -qF 'DEBUG: .exe suffix enabled because fake-fake-mingw32-g++ -dumpmachine mentions mingw'
	$(MAKE) $(TEST_OPTS) | MATCH -qF 'DEBUG: cross-compiling because g++ -dumpmachine and fake-fake-mingw32-g++ -dumpmachine differ'
	$(MAKE) $(TEST_OPTS) | MATCH -qF 'DEBUG: Toolchain.CXX.ImageFormat=PE'
	$(MAKE) $(TEST_OPTS) | MATCH -qF 'DEBUG: Toolchain.CXX.IsCross=yes'

check:: check-watcom-dos-cc-detection
.PHONY: check-watcom-dos-cc-detection
check-watcom-dos-cc-detection: TEST_OPTS += CC=open-watcom.owcc-dos
check-watcom-dos-cc-detection: TEST_OPTS += Toolchain.cc=/snap/open-watcom.owcc-dos
check-watcom-dos-cc-detection:
	$(TEST_HEADER)
	$(MAKE) $(TEST_OPTS) | MATCH -qF 'DEBUG: .exe suffix enabled because open-watcom.owcc-dos name'
	$(MAKE) $(TEST_OPTS) | MATCH -qF 'DEBUG: cross-compiling because open-watcom targets DOS'
	$(MAKE) $(TEST_OPTS) | MATCH -qF 'DEBUG: Toolchain.CC.ImageFormat=MZ'
	$(MAKE) $(TEST_OPTS) | MATCH -qF 'DEBUG: Toolchain.CC.IsCross=yes'

check:: check-watcom-dos-cxx-detection
.PHONY: check-watcom-dos-cxx-detection
check-watcom-dos-cxx-detection: TEST_OPTS += CXX=open-watcom.owcc-dos
check-watcom-dos-cxx-detection: TEST_OPTS += Toolchain.cxx=/snap/open-watcom.owcc-dos
check-watcom-dos-cxx-detection:
	$(TEST_HEADER)
	$(MAKE) $(TEST_OPTS) | MATCH -qF 'DEBUG: .exe suffix enabled because open-watcom.owcc-dos name'
	$(MAKE) $(TEST_OPTS) | MATCH -qF 'DEBUG: cross-compiling because open-watcom targets DOS'
	$(MAKE) $(TEST_OPTS) | MATCH -qF 'DEBUG: Toolchain.CXX.ImageFormat=MZ'
	$(MAKE) $(TEST_OPTS) | MATCH -qF 'DEBUG: Toolchain.CXX.IsCross=yes'

check:: check-watcom-win16-cc-detection
.PHONY: check-watcom-win16-cc-detection
check-watcom-win16-cc-detection: TEST_OPTS += CC=open-watcom.owcc-win16
check-watcom-win16-cc-detection: TEST_OPTS += Toolchain.cc=/snap/open-watcom.owcc-win16
check-watcom-win16-cc-detection:
	$(TEST_HEADER)
	$(MAKE) $(TEST_OPTS) | MATCH -qF 'DEBUG: .exe suffix enabled because open-watcom.owcc-win16 name'
	$(MAKE) $(TEST_OPTS) | MATCH -qF 'DEBUG: cross-compiling because open-watcom targets DOS'
	$(MAKE) $(TEST_OPTS) | MATCH -qF 'DEBUG: Toolchain.CC.ImageFormat=MZ'
	$(MAKE) $(TEST_OPTS) | MATCH -qF 'DEBUG: Toolchain.CC.IsCross=yes'

check:: check-watcom-win16-cxx-detection
.PHONY: check-watcom-win16-cxx-detection
check-watcom-win16-cxx-detection: TEST_OPTS += CXX=open-watcom.owcc-win16
check-watcom-win16-cxx-detection: TEST_OPTS += Toolchain.cxx=/snap/open-watcom.owcc-win16
check-watcom-win16-cxx-detection:
	$(TEST_HEADER)
	$(MAKE) $(TEST_OPTS) | MATCH -qF 'DEBUG: .exe suffix enabled because open-watcom.owcc-win16 name'
	$(MAKE) $(TEST_OPTS) | MATCH -qF 'DEBUG: cross-compiling because open-watcom targets DOS'
	$(MAKE) $(TEST_OPTS) | MATCH -qF 'DEBUG: Toolchain.CXX.ImageFormat=MZ'
	$(MAKE) $(TEST_OPTS) | MATCH -qF 'DEBUG: Toolchain.CXX.IsCross=yes'

check:: check-watcom-win32-cc-detection
.PHONY: check-watcom-win32-cc-detection
check-watcom-win32-cc-detection: TEST_OPTS += CC=open-watcom.owcc-win32
check-watcom-win32-cc-detection: TEST_OPTS += Toolchain.cc=/snap/open-watcom.owcc-win32
check-watcom-win32-cc-detection:
	$(TEST_HEADER)
	$(MAKE) $(TEST_OPTS) | MATCH -qF 'DEBUG: .exe suffix enabled because open-watcom.owcc-win32 name'
	$(MAKE) $(TEST_OPTS) | MATCH -qF 'DEBUG: cross-compiling because open-watcom targets Windows'
	$(MAKE) $(TEST_OPTS) | MATCH -qF 'DEBUG: Toolchain.CC.ImageFormat=PE'
	$(MAKE) $(TEST_OPTS) | MATCH -qF 'DEBUG: Toolchain.CC.IsCross=yes'

check:: check-watcom-win32-cxx-detection
.PHONY: check-watcom-win32-cxx-detection
check-watcom-win32-cxx-detection: TEST_OPTS += CXX=open-watcom.owcc-win32
check-watcom-win32-cxx-detection: TEST_OPTS += Toolchain.cxx=/snap/open-watcom.owcc-win32
check-watcom-win32-cxx-detection:
	$(TEST_HEADER)
	$(MAKE) $(TEST_OPTS) | MATCH -qF 'DEBUG: .exe suffix enabled because open-watcom.owcc-win32 name'
	$(MAKE) $(TEST_OPTS) | MATCH -qF 'DEBUG: cross-compiling because open-watcom targets Windows'
	$(MAKE) $(TEST_OPTS) | MATCH -qF 'DEBUG: Toolchain.CXX.ImageFormat=PE'
	$(MAKE) $(TEST_OPTS) | MATCH -qF 'DEBUG: Toolchain.CXX.IsCross=yes'


check:: check-gcc-configured-cross
.PHONY: check-gcc-configured-cross
check-gcc-configured-cross: TEST_OPTS += Configure.Configured=yes
check-gcc-configured-cross: TEST_OPTS += Configure.HostArchTriplet=host-linux-gnu
check-gcc-configured-cross: TEST_OPTS += Configure.BuildArchTriplet=build-linux-gnu
check-gcc-configured-cross: TEST_OPTS += Toolchain.cc=/usr/bin/host-linux-gnu-gcc
check-gcc-configured-cross: TEST_OPTS += Toolchain.cc.dumpmachine=host-linux-gnu
check-gcc-configured-cross: TEST_OPTS += Toolchain.gcc.dumpmachine=build-linux-gnu
check-gcc-configured-cross: TEST_OPTS += Toolchain.cxx=/usr/bin/host-linux-gnu-g++
check-gcc-configured-cross: TEST_OPTS += Toolchain.cxx.dumpmachine=host-linux-gnu
check-gcc-configured-cross: TEST_OPTS += Toolchain.g++.dumpmachine=build-linux-gnu
check-gcc-configured-cross:
	$(TEST_HEADER)
	$(MAKE) $(TEST_OPTS) | MATCH -qF 'DEBUG: gcc cross-compiler selected CC=host-linux-gnu-gcc'
	$(MAKE) $(TEST_OPTS) | MATCH -qF 'DEBUG: cross-compiling because gcc -dumpmachine and host-linux-gnu-gcc -dumpmachine differ'
	$(MAKE) $(TEST_OPTS) | MATCH -qF 'DEBUG: Toolchain.CC.IsCross=yes'
	$(MAKE) $(TEST_OPTS) | MATCH -qF 'DEBUG: Toolchain.CC.ImageFormat=ELF'


check:: check-g++-configured-cross
.PHONY: check-g++-configured-cross
check-g++-configured-cross: TEST_OPTS += Configure.Configured=yes
check-g++-configured-cross: TEST_OPTS += Configure.HostArchTriplet=host-linux-gnu
check-g++-configured-cross: TEST_OPTS += Configure.BuildArchTriplet=build-linux-gnu
check-g++-configured-cross: TEST_OPTS += Toolchain.cc=/usr/bin/host-linux-gnu-gcc
check-g++-configured-cross: TEST_OPTS += Toolchain.cc.dumpmachine=host-linux-gnu
check-g++-configured-cross: TEST_OPTS += Toolchain.cxx=/usr/bin/host-linux-gnu-g++
check-g++-configured-cross: TEST_OPTS += Toolchain.cxx.dumpmachine=host-linux-gnu
check-g++-configured-cross: TEST_OPTS += Toolchain.gcc.dumpmachine=build-linux-gnu
check-g++-configured-cross: TEST_OPTS += Toolchain.g++.dumpmachine=build-linux-gnu
check-g++-configured-cross:
	$(TEST_HEADER)
	$(MAKE) $(TEST_OPTS) | MATCH -qF 'DEBUG: g++ cross-compiler selected CXX=host-linux-gnu-g++'
	$(MAKE) $(TEST_OPTS) | MATCH -qF 'DEBUG: cross-compiling because g++ -dumpmachine and host-linux-gnu-g++ -dumpmachine differ'
	$(MAKE) $(TEST_OPTS) | MATCH -qF 'DEBUG: Toolchain.CXX.IsCross=yes'
	$(MAKE) $(TEST_OPTS) | MATCH -qF 'DEBUG: Toolchain.CXX.ImageFormat=ELF'
