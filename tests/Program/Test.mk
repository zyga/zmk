#!/usr/bin/make -f
# SPDX-FileCopyrightText: 2019-2024 Zygmunt Krynicki
# SPDX-License-Identifier: LGPL-3.0-only
#
# This file is part of zmk.
#
# Zmk is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License version 3 as
# published by the Free Software Foundation.
#
# Zmk is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with Zmk.  If not, see <https://www.gnu.org/licenses/>.

# This file is a part of zmk test system.
include zmk/internalTest.mk

t:: all all-sysroot install uninstall clean

$(eval $(ZMK.isolateHostToolchain))
# MacOS uses c++, GNU uses g++ by default.
# Pick one for test consistency.
%.log: ZMK.makeOverrides += CXX=c++
# Some logs behave as if a sysroot was requested.
%-sysroot.log: ZMK.makeOverrides += Toolchain.SysRoot=/path
# Test depends on source files
%.log: main.c main.cc main.cpp main.cxx main.m src/main.c

all: all.log
	# C/C++/ObjC programs can be built.
	GREP -qFx 'cc -MMD$(if $(ZMK.test.IsOutOfTreeBuild), -MF prog1-main.d) -c -o prog1-main.o $(ZMK.test.OutOfTreeSourcePath)main.c' <$<
	GREP -qFx 'cc -o prog1 prog1-main.o' <$<
	GREP -qFx 'c++ -MMD$(if $(ZMK.test.IsOutOfTreeBuild), -MF prog2-main.d) -c -o prog2-main.o $(ZMK.test.OutOfTreeSourcePath)main.cpp' <$<
	GREP -qFx 'c++ -o prog2 prog2-main.o' <$<
	GREP -qFx 'cc -MMD$(if $(ZMK.test.IsOutOfTreeBuild), -MF prog3-main.d) -c -o prog3-main.o $(ZMK.test.OutOfTreeSourcePath)main.m' <$<
	GREP -qFx 'cc -o prog3 prog3-main.o -lobjc' <$<
	GREP -qFx 'c++ -MMD$(if $(ZMK.test.IsOutOfTreeBuild), -MF prog4-main.d) -c -o prog4-main.o $(ZMK.test.OutOfTreeSourcePath)main.cxx' <$<
	GREP -qFx 'c++ -o prog4 prog4-main.o' <$<
	GREP -qFx 'c++ -MMD$(if $(ZMK.test.IsOutOfTreeBuild), -MF prog5-main.d) -c -o prog5-main.o $(ZMK.test.OutOfTreeSourcePath)main.cc' <$<
	GREP -qFx 'c++ -o prog5 prog5-main.o' <$<
	GREP -qFx 'cc -MMD$(if $(ZMK.test.IsOutOfTreeBuild), -MF src/prog6-main.d) -c -o src/prog6-main.o $(ZMK.test.OutOfTreeSourcePath)src/main.c' <$<
	GREP -qFx 'cc -o prog6 src/prog6-main.o' <$<
	GREP -qFx 'cc -MMD$(if $(ZMK.test.IsOutOfTreeBuild), -MF subdir/prog7-main.d) -c -o subdir/prog7-main.o $(ZMK.test.OutOfTreeSourcePath)main.c' <$<
	GREP -qFx 'cc -o subdir/prog7 subdir/prog7-main.o' <$<
all-sysroot: all-sysroot.log
	# C/C++/ObjC programs can be built against the configured sysroot.
	GREP -qFx 'cc -MMD$(if $(ZMK.test.IsOutOfTreeBuild), -MF prog1-main.d) -c --sysroot=/path -o prog1-main.o $(ZMK.test.OutOfTreeSourcePath)main.c' <$<
	GREP -qFx 'cc --sysroot=/path -o prog1 prog1-main.o' <$<
	GREP -qFx 'c++ -MMD$(if $(ZMK.test.IsOutOfTreeBuild), -MF prog2-main.d) -c --sysroot=/path -o prog2-main.o $(ZMK.test.OutOfTreeSourcePath)main.cpp' <$<
	GREP -qFx 'c++ --sysroot=/path -o prog2 prog2-main.o' <$<
	GREP -qFx 'cc -MMD$(if $(ZMK.test.IsOutOfTreeBuild), -MF prog3-main.d) -c --sysroot=/path -o prog3-main.o $(ZMK.test.OutOfTreeSourcePath)main.m' <$<
	GREP -qFx 'cc --sysroot=/path -o prog3 prog3-main.o -lobjc' <$<
	GREP -qFx 'c++ -MMD$(if $(ZMK.test.IsOutOfTreeBuild), -MF prog4-main.d) -c --sysroot=/path -o prog4-main.o $(ZMK.test.OutOfTreeSourcePath)main.cxx' <$<
	GREP -qFx 'c++ --sysroot=/path -o prog4 prog4-main.o' <$<
	GREP -qFx 'c++ -MMD$(if $(ZMK.test.IsOutOfTreeBuild), -MF prog5-main.d) -c --sysroot=/path -o prog5-main.o $(ZMK.test.OutOfTreeSourcePath)main.cc' <$<
	GREP -qFx 'c++ --sysroot=/path -o prog5 prog5-main.o' <$<
	GREP -qFx 'cc -MMD$(if $(ZMK.test.IsOutOfTreeBuild), -MF src/prog6-main.d) -c --sysroot=/path -o src/prog6-main.o $(ZMK.test.OutOfTreeSourcePath)src/main.c' <$<
	GREP -qFx 'cc --sysroot=/path -o prog6 src/prog6-main.o' <$<
	GREP -qFx 'cc -MMD$(if $(ZMK.test.IsOutOfTreeBuild), -MF subdir/prog7-main.d) -c --sysroot=/path -o subdir/prog7-main.o $(ZMK.test.OutOfTreeSourcePath)main.c' <$<
	GREP -qFx 'cc --sysroot=/path -o subdir/prog7 subdir/prog7-main.o' <$<
install: install.log
	# C/C++/ObjC programs can be installed.
	GREP -qFx 'install -d /usr/local/bin' <$<
	GREP -qFx 'install -m 0755 prog1 /usr/local/bin/prog1' <$<
	GREP -qFx 'install -m 0755 prog2 /usr/local/bin/prog2' <$<
	GREP -qFx 'install -m 0755 prog3 /usr/local/bin/prog3' <$<
	GREP -qFx 'install -m 0755 prog4 /usr/local/bin/prog4' <$<
	GREP -qFx 'install -m 0755 prog5 /usr/local/bin/prog5' <$<
	GREP -qFx 'install -m 0755 prog6 /usr/local/bin/prog6' <$<
	GREP -qFx 'install -m 0755 subdir/prog7 /usr/local/bin/prog7' <$<
uninstall: uninstall.log
	# C/C++/ObjC programs can be uninstalled.
	GREP -qFx 'rm -f /usr/local/bin/prog1' <$<
	GREP -qFx 'rm -f /usr/local/bin/prog2' <$<
	GREP -qFx 'rm -f /usr/local/bin/prog3' <$<
	GREP -qFx 'rm -f /usr/local/bin/prog4' <$<
	GREP -qFx 'rm -f /usr/local/bin/prog5' <$<
	GREP -qFx 'rm -f /usr/local/bin/prog6' <$<
	GREP -qFx 'rm -f /usr/local/bin/prog7' <$<
clean: clean.log
	# C/C++/ObjC programs can be cleaned.
	GREP -qFx 'rm -f ./prog1-main.o'  <$<
	GREP -qFx 'rm -f ./prog1-main.d'  <$<
	GREP -qFx 'rm -f prog1' <$<
	GREP -qFx 'rm -f ./prog2-main.o'  <$<
	GREP -qFx 'rm -f ./prog2-main.d'  <$<
	GREP -qFx 'rm -f prog2' <$<
	GREP -qFx 'rm -f ./prog3-main.o'  <$<
	GREP -qFx 'rm -f ./prog3-main.d'  <$<
	GREP -qFx 'rm -f prog3' <$<
	GREP -qFx 'rm -f ./prog4-main.o'  <$<
	GREP -qFx 'rm -f ./prog4-main.d'  <$<
	GREP -qFx 'rm -f prog4' <$<
	GREP -qFx 'rm -f ./prog5-main.o'  <$<
	GREP -qFx 'rm -f ./prog5-main.d'  <$<
	GREP -qFx 'rm -f prog5' <$<
	GREP -qFx 'rm -f src/prog6-main.o'  <$<
	GREP -qFx 'rm -f src/prog6-main.d'  <$<
	GREP -qFx 'rm -f prog6' <$<
	GREP -qFx 'rm -f subdir/prog7' <$<


t:: all-exe
all-exe.log: ZMK.makeOverrides += exe=.exe
all-exe: all-exe.log
	# C/C++ programs respect the .exe suffix (during building)
	GREP -qFx 'cc -MMD$(if $(ZMK.test.IsOutOfTreeBuild), -MF prog1-main.d) -c -o prog1-main.o $(ZMK.test.OutOfTreeSourcePath)main.c' <$<
	GREP -qFx 'cc -o prog1.exe prog1-main.o' <$<
	GREP -qFx 'c++ -MMD$(if $(ZMK.test.IsOutOfTreeBuild), -MF prog2-main.d) -c -o prog2-main.o $(ZMK.test.OutOfTreeSourcePath)main.cpp' <$<
	GREP -qFx 'c++ -o prog2.exe prog2-main.o' <$<


t:: install-custom-install-name
install-custom-install-name.log: ZMK.makeOverrides += prog1.InstallName=Prog1 subdir/prog7.InstallName=Prog7
install-custom-install-name: install-custom-install-name.log
	# Program can have a custom InstallName
	GREP -qFx 'install -d /usr/local/bin' <$<
	GREP -qFx 'install -m 0755 prog1 /usr/local/bin/Prog1' <$<
	GREP -qFx 'install -m 0755 subdir/prog7 /usr/local/bin/Prog7' <$<

t:: install-custom-install-mode
install-custom-install-mode.log: ZMK.makeOverrides += prog1.InstallMode=0700
install-custom-install-mode: install-custom-install-mode.log
	# Program can have a custom InstallMode
	GREP -qFx 'install -m 0700 prog1 /usr/local/bin/prog1' <$<

t:: install-custom-install-dir
install-custom-install-dir.log: ZMK.makeOverrides += prog1.InstallDir=/usr/local/sbin subdir/prog7.InstallDir=/usr/local/sbin
install-custom-install-dir: install-custom-install-dir.log
	# Program can have a custom InstallDir
	GREP -qFx 'install -m 0755 prog1 /usr/local/sbin/prog1' <$<
	GREP -qFx 'install -m 0755 subdir/prog7 /usr/local/sbin/prog7' <$<

t:: install-custom-deep-install-dir
install-custom-deep-install-dir.log: ZMK.makeOverrides += prog1.InstallDir=/usr/local/lib/custom/bin subdir/prog7.InstallDir=/usr/local/lib/custom/bin
install-custom-deep-install-dir: install-custom-deep-install-dir.log
	# Program with nested directories in InstallDir creates each directory.
	GREP -qFx 'install -d /usr/local/lib' <$<
	GREP -qFx 'install -d /usr/local/lib/custom' <$<
	GREP -qFx 'install -d /usr/local/lib/custom/bin' <$<
	GREP -qFx 'install -m 0755 prog1 /usr/local/lib/custom/bin/prog1' <$<
	GREP -qFx 'install -m 0755 subdir/prog7 /usr/local/lib/custom/bin/prog7' <$<

t:: install-program-prefix
install-program-prefix.log: ZMK.makeOverrides += Configure.ProgramPrefix=prefix-
install-program-prefix: install-program-prefix.log
	# Configured program prefix is used during the install phase.
	GREP -qFx 'cc -MMD$(if $(ZMK.test.IsOutOfTreeBuild), -MF prog1-main.d) -c -o prog1-main.o $(ZMK.test.OutOfTreeSourcePath)main.c' <$<
	GREP -qFx 'cc -o prog1 prog1-main.o' <$<
	GREP -qFx 'install -m 0755 prog1 /usr/local/bin/prefix-prog1' <$<
	GREP -qFx 'install -m 0755 subdir/prog7 /usr/local/bin/prefix-prog7' <$<

t:: install-program-suffix
install-program-suffix.log: ZMK.makeOverrides += Configure.ProgramSuffix=-suffix
install-program-suffix: install-program-suffix.log
	# Configured program suffix is used during the install phase.
	GREP -qFx 'cc -MMD$(if $(ZMK.test.IsOutOfTreeBuild), -MF prog1-main.d) -c -o prog1-main.o $(ZMK.test.OutOfTreeSourcePath)main.c' <$<
	GREP -qFx 'cc -o prog1 prog1-main.o' <$<
	GREP -qFx 'install -m 0755 prog1 /usr/local/bin/prog1-suffix' <$<
	GREP -qFx 'install -m 0755 subdir/prog7 /usr/local/bin/prog7-suffix' <$<

t:: install-program-transform-name
install-program-transform-name.log: ZMK.makeOverrides += Configure.ProgramTransformName='s/prog\([1-9]\)/potato\1/g'
install-program-transform-name: install-program-transform-name.log
	# Configured program transform expression is applied during the install phase.
	GREP -qFx 'cc -MMD$(if $(ZMK.test.IsOutOfTreeBuild), -MF prog1-main.d) -c -o prog1-main.o $(ZMK.test.OutOfTreeSourcePath)main.c' <$<
	GREP -qFx 'cc -o prog1 prog1-main.o' <$<
	GREP -qFx 'install -m 0755 prog1 /usr/local/bin/potato1' <$<
	GREP -qFx 'install -m 0755 subdir/prog7 /usr/local/bin/potato7' <$<

t:: install-exe
install-exe.log: ZMK.makeOverrides += exe=.exe
install-exe: install-exe.log
	# C/C++ programs respect the .exe suffix (during installation)
	GREP -qFx 'install -m 0755 prog1.exe /usr/local/bin/prog1.exe' <$<
