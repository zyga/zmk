#!/usr/bin/make -f
# This file is a part of zmk test system.
include zmk/internalTest.mk

t:: all install uninstall clean

$(eval $(ZMK.isolateHostToolchain))
# MacOS uses c++, GNU uses g++ by default.
# Pick one for test consistency.
%.log: ZMK.makeOverrides += CXX=c++
# Test depends on source files
%.log: foo.c bar.cpp froz.m

all: all.log
	# C/C++/ObjC programs can be built.
	GREP -qFx 'cc -MMD -c -o foo-foo.o $(ZMK.test.OutOfTreeSourcePath)foo.c' <$<
	GREP -qFx 'cc -o foo foo-foo.o' <$<
	GREP -qFx 'c++ -MMD -c -o bar-bar.o $(ZMK.test.OutOfTreeSourcePath)bar.cpp' <$<
	GREP -qFx 'c++ -MMD -o bar bar-bar.o' <$<
	GREP -qFx 'cc -MMD -c -o froz-froz.o $(ZMK.test.OutOfTreeSourcePath)froz.m' <$<
	GREP -qFx 'cc -MMD -o froz froz-froz.o -lobjc' <$<
install: install.log
	# C/C++/ObjC programs can be installed.
	GREP -qFx 'install -d /usr/local/bin' <$<
	GREP -qFx 'install -m 0755 foo /usr/local/bin/foo' <$<
	GREP -qFx 'install -m 0755 bar /usr/local/bin/bar' <$<
	GREP -qFx 'install -m 0755 froz /usr/local/bin/froz' <$<
uninstall: uninstall.log
	# C/C++/ObjC programs can be uninstalled.
	GREP -qFx 'rm -f /usr/local/bin/foo' <$<
	GREP -qFx 'rm -f /usr/local/bin/bar' <$<
	GREP -qFx 'rm -f /usr/local/bin/froz' <$<
clean: clean.log
	# C/C++/ObjC programs can be cleaned.
	GREP -qFx 'rm -f foo-foo.o'  <$<
	GREP -qFx 'rm -f foo-foo.d'  <$<
	GREP -qFx 'rm -f foo' <$<
	GREP -qFx 'rm -f bar-bar.o'  <$<
	GREP -qFx 'rm -f bar-bar.d'  <$<
	GREP -qFx 'rm -f bar' <$<
	GREP -qFx 'rm -f froz-froz.o'  <$<
	GREP -qFx 'rm -f froz-froz.d'  <$<
	GREP -qFx 'rm -f froz' <$<


t:: all-exe
all-exe.log: ZMK.makeOverrides += exe=.exe
all-exe: all-exe.log
	# C/C++ programs respect the .exe suffix (during building)
	GREP -qFx 'cc -MMD -c -o foo-foo.o $(ZMK.test.OutOfTreeSourcePath)foo.c' <$<
	GREP -qFx 'cc -o foo.exe foo-foo.o' <$<
	GREP -qFx 'c++ -MMD -c -o bar-bar.o $(ZMK.test.OutOfTreeSourcePath)bar.cpp' <$<
	GREP -qFx 'c++ -MMD -o bar.exe bar-bar.o' <$<


t:: install-custom-install-name
install-custom-install-name.log: ZMK.makeOverrides += foo.InstallName=Foo
install-custom-install-name: install-custom-install-name.log
	# Program can have a custom InstallName
	GREP -qFx 'install -d /usr/local/bin' <$<
	GREP -qFx 'install -m 0755 foo /usr/local/bin/Foo' <$<

t:: install-custom-install-mode
install-custom-install-mode.log: ZMK.makeOverrides += foo.InstallMode=0700
install-custom-install-mode: install-custom-install-mode.log
	# Program can have a custom InstallMode
	GREP -qFx 'install -m 0700 foo /usr/local/bin/foo' <$<

t:: install-custom-install-dir
install-custom-install-dir.log: ZMK.makeOverrides += foo.InstallDir=/usr/local/sbin
install-custom-install-dir: install-custom-install-dir.log
	# Program can have a custom InstallDir
	GREP -qFx 'install -m 0755 foo /usr/local/sbin/foo' <$<

t:: install-custom-deep-install-dir
install-custom-deep-install-dir.log: ZMK.makeOverrides += foo.InstallDir=/usr/local/lib/custom/bin
install-custom-deep-install-dir: install-custom-deep-install-dir.log
	# Program with nested directories in InstallDir creates each directory.
	GREP -qFx 'install -d /usr/local/lib' <$<
	GREP -qFx 'install -d /usr/local/lib/custom' <$<
	GREP -qFx 'install -d /usr/local/lib/custom/bin' <$<
	GREP -qFx 'install -m 0755 foo /usr/local/lib/custom/bin/foo' <$<

t:: install-program-prefix
install-program-prefix.log: ZMK.makeOverrides += Configure.ProgramPrefix=prefix-
install-program-prefix: install-program-prefix.log
	# Configured program prefix is used during the install phase.
	GREP -qFx 'cc -MMD -c -o foo-foo.o $(ZMK.test.OutOfTreeSourcePath)foo.c' <$<
	GREP -qFx 'cc -o foo foo-foo.o' <$<
	GREP -qFx 'install -m 0755 foo /usr/local/bin/prefix-foo' <$<

t:: install-program-suffix
install-program-suffix.log: ZMK.makeOverrides += Configure.ProgramSuffix=-suffix
install-program-suffix: install-program-suffix.log
	# Configured program suffix is used during the install phase.
	GREP -qFx 'cc -MMD -c -o foo-foo.o $(ZMK.test.OutOfTreeSourcePath)foo.c' <$<
	GREP -qFx 'cc -o foo foo-foo.o' <$<
	GREP -qFx 'install -m 0755 foo /usr/local/bin/foo-suffix' <$<

t:: install-program-transform-name
install-program-transform-name.log: ZMK.makeOverrides += Configure.ProgramTransformName=s/foo/potato/g
install-program-transform-name: install-program-transform-name.log
	# Configured program transform expression is applied during the install phase.
	GREP -qFx 'cc -MMD -c -o foo-foo.o $(ZMK.test.OutOfTreeSourcePath)foo.c' <$<
	GREP -qFx 'cc -o foo foo-foo.o' <$<
	GREP -qFx 'install -m 0755 foo /usr/local/bin/potato' <$<

install-exe.log: ZMK.makeOverrides += exe=.exe
install-exe: install-exe.log
	# C/C++ programs respect the .exe suffix (during installation)
	GREP -qFx 'install -m 0755 foo.exe /usr/local/bin/foo.exe' <$<
