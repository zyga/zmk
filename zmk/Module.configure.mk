# Copyright 2019-2020 Zygmunt Krynicki.
#
# This file is part of zmk.
#
# Zmk is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License.
#
# Zmk is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with Zmk.  If not, see <https://www.gnu.org/licenses/>.

# Include optional generated makefile from the configuration system.
-include GNUmakefile.configure.mk
$(if $(findstring configure,$(DEBUG)),$(info DEBUG: prefix=$(prefix)))

# Configuration depends on directory definitions.
$(eval $(call import,Module.directories))
$(eval $(call import,Module.toolchain))

# Configuration system defaults, also changed by GNUMakefile.configure.mk
CONFIGURED ?=
HOST_ARCH_TRIPLET ?=
BUILD_ARCH_TRIPLET ?=

# Include optional generated makefile from the configuration system.
-include GNUmakefile.configure.mk
$(if $(findstring configure,$(DEBUG)),$(info DEBUG: prefix=$(prefix)))

# If we are configured then check for cross compilation by mismatch
# of host and build triplets. When this happens set CC and CXX.
ifneq (,$(and $(CONFIGURED),$(HOST_ARCH_TRIPLET),$(BUILD_ARCH_TRIPLET)))
ifneq ($(BUILD_ARCH_TRIPLET),$(HOST_ARCH_TRIPLET))
Toolchain.Cross = yes
ifeq ($(origin CC),default)
CC = $(HOST_ARCH_TRIPLET)-gcc
$(if $(findstring configure,$(DEBUG)),$(info DEBUG: cross-compiler selected CC=$(CC)))
endif
ifeq ($(origin CXX),default)
CXX = $(HOST_ARCH_TRIPLET)-g++
$(if $(findstring configure,$(DEBUG)),$(info DEBUG: cross-compiler selected CXX=$(CXX)))
endif
endif # !cross-compiling
endif # !configured

# Remove the generate makefile when dist-cleaning
distclean:: clean
	rm -f GNUmakefile.configure.mk
