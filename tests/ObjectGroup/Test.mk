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

t:: build build-sysroot clean

$(eval $(ZMK.isolateHostToolchain))
# MacOS uses c++, GNU uses g++ by default.
# Pick one for test consistency.
%.log: ZMK.makeOverrides += CXX=c++
# Some logs behave as if a sysroot was requested.
%-sysroot.log: ZMK.makeOverrides += Toolchain.SysRoot=/path
# Test depends on source files
%.log: main.c main.cc main.cpp main.cxx main.m src/main.c

build: build.log
	# C/C++/ObjC object files can be built.
	GREP -qFx 'cc -MMD$(if $(ZMK.test.IsOutOfTreeBuild), -MF group1-main.d) -c -o group1-main.o $(ZMK.test.OutOfTreeSourcePath)main.c' <$<
	GREP -qFx 'c++ -MMD$(if $(ZMK.test.IsOutOfTreeBuild), -MF group2-main.d) -c -o group2-main.o $(ZMK.test.OutOfTreeSourcePath)main.cpp' <$<
	GREP -qFx 'cc -MMD$(if $(ZMK.test.IsOutOfTreeBuild), -MF group3-main.d) -c -o group3-main.o $(ZMK.test.OutOfTreeSourcePath)main.m' <$<
	GREP -qFx 'c++ -MMD$(if $(ZMK.test.IsOutOfTreeBuild), -MF group4-main.d) -c -o group4-main.o $(ZMK.test.OutOfTreeSourcePath)main.cxx' <$<
	GREP -qFx 'c++ -MMD$(if $(ZMK.test.IsOutOfTreeBuild), -MF group5-main.d) -c -o group5-main.o $(ZMK.test.OutOfTreeSourcePath)main.cc' <$<
	GREP -qFx 'cc -MMD$(if $(ZMK.test.IsOutOfTreeBuild), -MF src/group6-main.d) -c -o src/group6-main.o $(ZMK.test.OutOfTreeSourcePath)src/main.c' <$<

build-sysroot: build-sysroot.log
	# C/C++/ObjC object files can be built against an explicitly configured sysroot.
	GREP -qFx 'cc -MMD$(if $(ZMK.test.IsOutOfTreeBuild), -MF group1-main.d) -c --sysroot=/path -o group1-main.o $(ZMK.test.OutOfTreeSourcePath)main.c' <$<
	GREP -qFx 'c++ -MMD$(if $(ZMK.test.IsOutOfTreeBuild), -MF group2-main.d) -c --sysroot=/path -o group2-main.o $(ZMK.test.OutOfTreeSourcePath)main.cpp' <$<
	GREP -qFx 'cc -MMD$(if $(ZMK.test.IsOutOfTreeBuild), -MF group3-main.d) -c --sysroot=/path -o group3-main.o $(ZMK.test.OutOfTreeSourcePath)main.m' <$<
	GREP -qFx 'c++ -MMD$(if $(ZMK.test.IsOutOfTreeBuild), -MF group4-main.d) -c --sysroot=/path -o group4-main.o $(ZMK.test.OutOfTreeSourcePath)main.cxx' <$<
	GREP -qFx 'c++ -MMD$(if $(ZMK.test.IsOutOfTreeBuild), -MF group5-main.d) -c --sysroot=/path -o group5-main.o $(ZMK.test.OutOfTreeSourcePath)main.cc' <$<
	GREP -qFx 'cc -MMD$(if $(ZMK.test.IsOutOfTreeBuild), -MF src/group6-main.d) -c --sysroot=/path -o src/group6-main.o $(ZMK.test.OutOfTreeSourcePath)src/main.c' <$<

clean: clean.log
	# C/C++/ObjC object files can be cleaned.
	GREP -qFx 'rm -f ./group1-main.o'  <$<
	GREP -qFx 'rm -f ./group1-main.d'  <$<
	GREP -qFx 'rm -f ./group2-main.o'  <$<
	GREP -qFx 'rm -f ./group2-main.d'  <$<
	GREP -qFx 'rm -f ./group3-main.o'  <$<
	GREP -qFx 'rm -f ./group3-main.d'  <$<
	GREP -qFx 'rm -f ./group4-main.o'  <$<
	GREP -qFx 'rm -f ./group4-main.d'  <$<
	GREP -qFx 'rm -f ./group5-main.o'  <$<
	GREP -qFx 'rm -f ./group5-main.d'  <$<
	GREP -qFx 'rm -f src/group6-main.o'  <$<
	GREP -qFx 'rm -f src/group6-main.d'  <$<
