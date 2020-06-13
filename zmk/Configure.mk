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

# Configuration system defaults, also changed by GNUMakefile.configure.mk
Configure.Configured ?=
Configure.DependencyTracking ?=
Configure.HostArchTriplet ?=
Configure.BuildArchTriplet ?=

# Include optional generated makefile from the configuration system.
# This makefile can only set one of the variables listed above.
-include GNUmakefile.configure.mk

# Is zmk debugging enabled for this module?
Configure.debug ?= $(findstring configure,$(DEBUG))

# $(if $(Configure.debug),$(info DEBUG: prefix=$(prefix)))
$(if $(Configure.debug),$(info DEBUG: Configure.Configured=$(Configure.Configured)))
$(if $(Configure.debug),$(info DEBUG: Configure.HostArchTriplet=$(Configure.HostArchTriplet)))
$(if $(Configure.debug),$(info DEBUG: Configure.BuildArchTriplet=$(Configure.BuildArchTriplet)))
$(if $(Configure.debug),$(info DEBUG: Configure.DependencyTracking=$(Configure.DependencyTracking)))

# ZMK provides a custom configuration script, this is is the full text
define Configure.Script
#!/bin/sh
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

# Configure script for integration with distribution packaging preferences.

while [ "$$#" -ge 1 ]; do
    case "$$1" in
        --help)
            echo "Usage: ./configure [OPTIONS]"
            echo
            echo "Available options:"
            echo "  --build=GNU_TRIPLET     Describe the build machine with the given GNU_TRIPLET"
            echo "  --host=GNU_TRIPLET      Describe the host machine with the given GNU_TRIPLET"
            echo " tip: using different build and host triplets enables cross-compilation"
            echo "  --disable-dependency-tracking"
            echo "                          Do not generate or use dependency data during builds"
            echo
            echo "Build-time directory selection:"
            echo "  --prefix=PREFIX        Set prefix for all directories to PREFIX"
            echo "  --exec-prefix=PREFIX   Set prefix for libraries and executables to PREFIX"
            echo
            echo "  --bindir=DIR           Install user executables to DIR"
            echo "  --sbindir=DIR          Install super-user executables to DIR"
            echo "  --libexecdir=DIR       Install library-internal executables to DIR"
            echo "  --libdir=DIR           Install runtime and development libraries to DIR"
            echo "  --includedir=DIR       Install development header files to DIR"
            echo "  --includedir=DIR       Install development header files to DIR"
            echo "  --mandir=DIR           Install manual pages to DIR"
            echo "  --infodir=DIR          Install GNU info pages to DIR"
            echo "  --sysconfdir=DIR       Install system configuration files to DIR"
            echo "  --datadir=DIR          Install read-only data files to DIR"
            echo
            echo "  --sharedstatedir=DIR   Store state shared across machines in DIR"
            echo "  --localstatedir=DIR    Store persistent state specific to a machine in DIR"
            echo "  --runstatedir=DIR      Store ephemeral state specific to a machine in DIR"
            echo
            echo "Unimplemented and ignored options:"
            echo "  --disable-maintainer-mode"
            echo "  --disable-silent-rules"
            echo "  --program-prefix=PREFIX"
            echo "  --disable-option-checking"
            echo
            echo "Memorised environment variables:"
            echo "  CC                      Path of the C compiler"
            echo "  CXX                     Path of the C++ compiler"
            echo "  CFLAGS                  Options for the C compiler"
            echo "  CXXFLAGS                Options for the C++ compiler"
            echo "  CPPFLAGS                Options for the preprocessor"
            echo "  LDFLAGS                 Options for the linker"
            exit 0
            ;;
        --version)
            echo "z.mk configure script version $(ZMK.Version)"
            exit 0
            ;;
        *)
            break
            ;;
    esac
done

{
    # Given key=value or key="value value", print the value
    rhs() {
        echo "$$*" | cut -d '=' -f 2- | sed -e 's/^"//' -e 's/"$$//'
    }

    while [ "$$#" -ge 1 ]; do
        case "$$1" in
            --build=*)          echo "Configure.BuildArchTriplet=$$(rhs "$$1")" && shift ;;
            --enable-dependency-tracking)   echo Configure.DependencyTracking=yes" && shift ;;
            --disable-dependency-tracking)  echo Configure.DependencyTracking=" && shift ;;
            --disable-maintainer-mode)      shift ;;
            --disable-silent-rules)         shift ;;
            --disable-option-checking)      shift ;;
            --host=*)           echo "Configure.HostArchTriplet=$$(rhs "$$1")" && shift ;;
            --program-prefix=)              shift ;;
            --bindir=*)         echo "bindir=$$(rhs "$$1")" && shift ;;
            --datadir=*)        echo "datadir=$$(rhs "$$1")" && shift ;;
            --exec-prefix=*)    echo "exec_prefix=$$(rhs "$$1")" && shift ;;
            --includedir=*)     echo "includedir=$$(rhs "$$1")" && shift ;;
            --infodir=*)        echo "infodir=$$(rhs "$$1")" && shift ;;
            --libdir=*)         echo "libdir=$$(rhs "$$1")" && shift ;;
            --libexecdir=*)     echo "libexecdir=$$(rhs "$$1")" && shift ;;
            --mandir=*)         echo "mandir=$$(rhs "$$1")" && shift ;;
            --prefix=*)         echo "prefix=$$(rhs "$$1")" && shift ;;
            --sbindir=*)        echo "sbindir=$$(rhs "$$1")" && shift ;;
            --sharedstatedir=*) echo "sharedstatedir=$$(rhs "$$1")" && shift ;;
            --sysconfdir=*)     echo "sysconfdir=$$(rhs "$$1")" && shift ;;
            --localstatedir=*)  echo "localstatedir=$$(rhs "$$1")" && shift ;;
            --runstatedir=*)    echo "runstatedir=$$(rhs "$$1")" && shift ;;
            CC=*)               CC="$$(rhs "$$1")" && shift ;;
            CXX=*)              CXX="$$(rhs "$$1")" && shift ;;
            CFLAGS=*)           CFLAGS="$$(rhs "$$1")" && shift ;;
            OBJCFLAGS=*)        OBJCFLAGS="$$(rhs "$$1")" && shift ;;
            CXXFLAGS=*)         CXXFLAGS="$$(rhs "$$1")" && shift ;;
            CPPFLAGS=*)         CPPFLAGS="$$(rhs "$$1")" && shift ;;
            LDFLAGS=*)          LDFLAGS="$$(rhs "$$1")" && shift ;;
            *)
                echo "configure: unknown option $$1" >&2
                exit 1
                ;;
        esac
    done
    if [ -n "$${srcdir:-}" ]; then
        echo "srcdir=$$srcdir"
    else
        echo "srcdir=$$(dirname "$$0")"
    fi
    echo "VPATH=\$$(srcdir)"

    test -n "$$CC" && echo "CC=$$CC"
    test -n "$$CXX" && echo "CC=$$CXX"
    test -n "$$CFLAGS" && echo "CFLAGS=$$CFLAGS"
    test -n "$$CXXFLAGS" && echo "CXXFLAGS=$$CXXFLAGS"
    test -n "$$OBJCFLAGS" && echo "OBJCFLAGS=$$OBJCFLAGS"
    test -n "$$CPPFLAGS" && echo "CPPFLAGS=$$CPPFLAGS"
    test -n "$$LDFLAGS" && echo "LDFLAGS=$$LDFLAGS"
    echo Configure.Configured=yes
} > GNUmakefile.configure.mk

if [ ! -e Makefile ] && [ ! -e GNUmakefile ]; then
    ln -s "$$(dirname "$$0")"/GNUmakefile GNUmakefile
fi
endef

# ZMK can synthesize the configuration script.
configure: export ZMK_CONFIGURE_SCRIPT = $(Configure.Script)
configure:
	echo "$${ZMK_CONFIGURE_SCRIPT}" >$@
	chmod +x $@

# Remove the generate makefile when dist-cleaning
distclean:: clean
	rm -f GNUmakefile.configure.mk configure
