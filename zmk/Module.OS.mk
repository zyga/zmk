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

# Guesstimate the OS used.
OS := $(shell uname -s | tr '/' '-')
$(if $(findstring os,$(DEBUG)),$(info DEBUG: guessed OS=$(OS)))

# XXX: maybe better?
OS.has_a ?= yes
OS.has_elf ?=
OS.has_macho ?=
OS.has_dll ?=

ifneq (,$(findstring $(OS),Linux FreeBSD NetBSD OpenBSD GNU GNU-kFreeBSD SunOS))
OS.has_elf = yes
endif
ifeq ($(OS),Darwin)
OS.has_macho = yes
endif
ifeq ($(OS),SunOS)
# Solaris doesn't seem to provide any aliases or symlinks for gcc.
CC := gcc
endif

$(if $(findstring os,$(DEBUG)),$(info DEBUG: OS.has_a=$(OS.has_a)))
$(if $(findstring os,$(DEBUG)),$(info DEBUG: OS.has_elf=$(OS.has_elf)))
$(if $(findstring os,$(DEBUG)),$(info DEBUG: OS.has_macho=$(OS.has_macho)))
$(if $(findstring os,$(DEBUG)),$(info DEBUG: OS.has_dll=$(OS.has_dll)))
