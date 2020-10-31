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

$(eval $(call ZMK.Import,Silent))

# Is zmk debugging enabled for this module?
Configure.debug ?= $(findstring configure,$(DEBUG))

# Configuration system defaults, also changed by GNUmakefile.configure.mk
Configure.HostArchTriplet ?=
Configure.BuildArchTriplet ?=
Configure.DependencyTracking ?= yes
Configure.MaintainerMode ?= yes
Configure.SilentRules ?=
Configure.ProgramPrefix ?=
Configure.ProgramSuffix ?=
Configure.ProgramTransformName ?=
Configure.Configured ?=
Configure.Options ?=

# Include optional, generated makefile from the configuration system.
# This makefile can only set one of the variables listed above.  The name
# of the makefile is unique to the project. This prevents make from
# traversing PATH and, by accident, including this file from unexpected
# location. One place where this happens is zmk test suite.
ifneq (,$(Project.Name))
-include GNUmakefile.$(Project.Name).configure.mk
endif

# Enable silent rules if configured.
ifneq (,$(Configure.Configured))
override Silent.Active = $(Configure.SilentRules)
endif

$(if $(Configure.debug),$(foreach v,$(filter Configure.%,$(.VARIABLES)),$(info DEBUG: $v=$($v))))

ifneq ($(Project.Name),)
# ZMK provides a custom configuration script, this is is the full text
define Configure.script
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

# This script was automatically generated by zmk version $(ZMK.Version)
# for the $(Project.Name) project. Executing this script creates a configuration
# file called GNUmakefile.$(Project.Name).configure.mk which influences the build
# process of $(Project.Name).

while [ "$$#" -ge 1 ]; do
    case "$$1" in
        -h|--help)
            echo "Usage: ./configure [OPTIONS]"
            echo
            echo "Compilation options:"
            echo "  --build=GNU_TRIPLET         Describe the build machine with the given GNU_TRIPLET"
            echo "  --host=GNU_TRIPLET          Describe the host machine with the given GNU_TRIPLET"
            echo "  --enable-dependency-tracking"
            echo "                              Track dependencies between files (implicit)"
            echo "  --disable-dependency-tracking"
            echo "                              Do not generate or use dependency data during builds"
            echo "  --enable-maintainer-mode    Enable maintainer mode (implicit)"
            echo "  --disable-maintainer-mode   Disable maintainer mode"
            echo
            echo "Build-time directory selection:"
            echo "  --prefix=PREFIX             Set prefix for all directories to PREFIX"
            echo "  --exec-prefix=PREFIX        Set prefix for libraries and programs to PREFIX"
            echo
            echo "  --bindir=DIR                Install user programs to DIR"
            echo "  --sbindir=DIR               Install super-user programs to DIR"
            echo "  --libdir=DIR                Install runtime and development libraries to DIR"
            echo "  --libexecdir=DIR            Install library-internal programs to DIR"
            echo "  --includedir=DIR            Install development header files to DIR"
            echo "  --mandir=DIR                Install manual pages to DIR"
            echo "  --infodir=DIR               Install GNU info pages to DIR"
            echo "  --sysconfdir=DIR            Install system configuration files to DIR"
            echo "  --datadir=DIR               Install read-only data files to DIR"
            echo
            echo "  --localstatedir=DIR         Store persistent state specific to a machine in DIR"
            echo "  --runstatedir=DIR           Store ephemeral state specific to a machine in DIR"
            echo "  --sharedstatedir=DIR        Store state shared across machines in DIR"
            echo
            echo "Options for altering program names:"
            echo "  --program-prefix=PREFIX     Put PREFIX before installed program names"
            echo "  --program-suffix=SUFFIX     Put SUFFIX after installed program names"
            echo "  --program-transform-name=PROGRAM"
            echo "                              Use sed PROGRAM to transform installed program names"
            echo
            echo "Miscellaneous options:"
            echo "  --enable-option-checking    Report unrecognized configuration options (implicit)"
            echo "  --disable-option-checking   Ignore unrecognized configuration options"
            echo "  --enable-silent-rules       Do not display commands while building"
            echo "  --disable-silent-rules      Display commands while building (implicit)"
            echo
            echo "Memorized environment variables:"
            echo "  CC                          Name of the C compiler"
            echo "  CXX                         Name of the C++ compiler"
            echo "  CFLAGS                      Options for the C compiler"
            echo "  CXXFLAGS                    Options for the C++ compiler"
            echo "  CPPFLAGS                    Options for the preprocessor"
            echo "  LDFLAGS                     Options for the linker"
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

# Given key=value or key="value value", print the value
rhs() {
    echo "$$*" | cut -d '=' -f 2- | sed -e 's/^"//' -e 's/"$$//'
}

configureOptions="$$*"
srcdir="$$(dirname "$$0")"

while [ "$$#" -ge 1 ]; do
    case "$$1" in
        --build=*)                      buildArchTriplet="$$(rhs "$$1")" && shift ;;
        --host=*)                       hostArchTriplet="$$(rhs "$$1")" && shift ;;

        --enable-dependency-tracking)   dependencyTracking=yes && shift ;;
        --disable-dependency-tracking)  dependencyTracking=no && shift ;;

        --enable-maintainer-mode)       maintainerMode=yes && shift ;;
        --disable-maintainer-mode)      maintainerMode=no && shift ;;

        --enable-silent-rules)          silentRules=yes && shift ;;
        --disable-silent-rules)         silentRules=no && shift ;;

        --enable-option-checking)       disableOptionChecking=no && shift ;;
        --disable-option-checking)      disableOptionChecking=yes && shift ;;

        --program-prefix=*)             programPrefix="$$(rhs "$$1")" && shift ;;
        --program-suffix=*)             programSuffix="$$(rhs "$$1")" && shift ;;
        --program-transform-name=*)     programTransformName="$$(rhs "$$1")" && shift ;;

        --exec-prefix=*)                exec_prefix="$$(rhs "$$1")" && shift ;;
        --prefix=*)                     prefix="$$(rhs "$$1")" && shift ;;

        --bindir=*)                     bindir="$$(rhs "$$1")" && shift ;;
        --sbindir=*)                    sbindir="$$(rhs "$$1")" && shift ;;
        --libdir=*)                     libdir="$$(rhs "$$1")" && shift ;;
        --libexecdir=*)                 libexecdir="$$(rhs "$$1")" && shift ;;
        --datadir=*)                    datadir="$$(rhs "$$1")" && shift ;;
        --includedir=*)                 includedir="$$(rhs "$$1")" && shift ;;
        --infodir=*)                    infodir="$$(rhs "$$1")" && shift ;;
        --mandir=*)                     mandir="$$(rhs "$$1")" && shift ;;
        --sysconfdir=*)                 sysconfdir="$$(rhs "$$1")" && shift ;;

        --localstatedir=*)              localstatedir="$$(rhs "$$1")" && shift ;;
        --runstatedir=*)                runstatedir="$$(rhs "$$1")" && shift ;;
        --sharedstatedir=*)             sharedstatedir="$$(rhs "$$1")" && shift ;;

        CC=*)                           CC="$$(rhs "$$1")" && shift ;;
        CXX=*)                          CXX="$$(rhs "$$1")" && shift ;;
        CFLAGS=*)                       CFLAGS="$$(rhs "$$1")" && shift ;;
        CXXFLAGS=*)                     CXXFLAGS="$$(rhs "$$1")" && shift ;;
        OBJCFLAGS=*)                    OBJCFLAGS="$$(rhs "$$1")" && shift ;;
        OBJCXXFLAGS=*)                  OBJCXXFLAGS="$$(rhs "$$1")" && shift ;;
        CPPFLAGS=*)                     CPPFLAGS="$$(rhs "$$1")" && shift ;;
        LDFLAGS=*)                      LDFLAGS="$$(rhs "$$1")" && shift ;;
        ZMK.SrcDir=*)                   srcdir="$$(rhs "$$1")" && shift ;;

        *)
            if [ "$${disableOptionChecking:-}" != yes ]; then
                echo "configure: unknown option $$1" >&2
                exit 1
            fi
            shift
            ;;
    esac
done

{
    echo "# Generated by zmk configuration script version $(ZMK.Version)"
    echo "# Invoked as: $$srcdir/configure $$configureOptions"
    echo
    echo "# Location of the source code."
    echo "ZMK.SrcDir=$$srcdir"
    echo
    echo "# Build and host architecture triplets."
    echo "# Note that those impact compiler selection unless CC and CXX are overridden."
    test -n "$${buildArchTriplet:-}"    && echo "Configure.BuildArchTriplet=$$buildArchTriplet"     || echo "#   Configure.BuildArchTriplet was not specified."
    test -n "$${hostArchTriplet:-}"     && echo "Configure.HostArchTriplet=$$hostArchTriplet"       || echo "#   Configure.HostArchTriplet was not specified."
    echo
    echo "# Build-time configuration of application directories."
    test -n "$${prefix:-}"          && echo "prefix=$$prefix"                   || echo "#   prefix was not specified."
    test -n "$${exec_prefix:-}"     && echo "exec_prefix=$$exec_prefix"         || echo "#   exec_prefix was not specified."
    test -n "$${bindir:-}"          && echo "bindir=$$bindir"                   || echo "#   bindir was not specified."
    test -n "$${sbindir:-}"         && echo "sbindir=$$sbindir"                 || echo "#   sbindir was not specified."
    test -n "$${datadir:-}"         && echo "datadir=$$datadir"                 || echo "#   datadir was not specified."
    test -n "$${includedir:-}"      && echo "includedir=$$includedir"           || echo "#   includedir was not specified."
    test -n "$${infodir:-}"         && echo "infodir=$$infodir"                 || echo "#   infodir was not specified."
    test -n "$${libdir:-}"          && echo "libdir=$$libdir"                   || echo "#   libdir was not specified."
    test -n "$${libexecdir:-}"      && echo "libexecdir=$$libexecdir"           || echo "#   libexecdir was not specified."
    test -n "$${localstatedir:-}"   && echo "localstatedir=$$localstatedir"     || echo "#   localstatedir was not specified."
    test -n "$${mandir:-}"          && echo "mandir=$$mandir"                   || echo "#   mandir was not specified."
    test -n "$${runstatedir:-}"     && echo "runstatedir=$$runstatedir"         || echo "#   runstatedir was not specified."
    test -n "$${sharedstatedir:-}"  && echo "sharedstatedir=$$sharedstatedir"   || echo "#   sharedstatedir was not specified."
    test -n "$${sysconfdir:-}"      && echo "sysconfdir=$$sysconfdir"           || echo "#   sysconfdir was not specified."
    echo
    echo "# Inherited environment variables and overrides."
    test -n "$$CC"                  && echo "CC=$$CC"                           || echo "#   CC was not specified."
    test -n "$$CXX"                 && echo "CXX=$$CXX"                         || echo "#   CXX was not specified."
    test -n "$$CFLAGS"              && echo "CFLAGS=$$CFLAGS"                   || echo "#   CFLAGS was not specified."
    test -n "$$CXXFLAGS"            && echo "CXXFLAGS=$$CXXFLAGS"               || echo "#   CXXFLAGS was not specified."
    test -n "$$OBJCFLAGS"           && echo "OBJCFLAGS=$$OBJCFLAGS"             || echo "#   OBJCFLAGS was not specified."
    test -n "$$OBJCXXFLAGS"         && echo "OBJCXXFLAGS=$$OBJCXXFLAGS"         || echo "#   OBJCXXFLAGS was not specified."
    test -n "$$CPPFLAGS"            && echo "CPPFLAGS=$$CPPFLAGS"               || echo "#   CPPFLAGS was not specified."
    test -n "$$LDFLAGS"             && echo "LDFLAGS=$$LDFLAGS"                 || echo "#   LDFLAGS was not specified."
    echo
    echo "# Track dependencies between objects and source and header files."
    case "$${dependencyTracking:-implicit}" in
        yes)
            echo "Configure.DependencyTracking=yes"
            ;;
        no)
            echo "Configure.DependencyTracking="
            ;;
        implicit)
            echo "#   Configure.DependencyTracking was not specified."
            echo "#   This feature is enabled by default."
            ;;
    esac
    echo
    echo "# Additional options for package maintainers."
    case "$${maintainerMode:-implicit}" in
        yes)
            echo "Configure.MaintainerMode=yes"
            ;;
        no)
            echo "Configure.MaintainerMode="
            ;;
        implicit)
            echo "#   Configure.MaintainerMode was not specified."
            echo "#   This feature is enabled by default."
            ;;
    esac
    echo
    echo "# Silence shell commands used by make."
    case "$${silentRules:-implicit}" in
        yes)
            echo "Configure.SilentRules=yes"
            ;;
        no)
            echo "Configure.SilentRules="
            ;;
        implicit)
            echo "#   Configure.SilentRules was not specified."
            echo "#   This feature is disabled by default."
            ;;
    esac
    echo
    echo "# Program name customization options."
    test -n "$${programPrefix:-}"           && echo "Configure.ProgramPrefix=$$programPrefix"               || echo "#   Configure.ProgramPrefix was not specified."
    test -n "$${programSuffix:-}"           && echo "Configure.ProgramSuffix=$$programSuffix"               || echo "#   Configure.ProgramSuffix was not specified."
    test -n "$${programTransformName:-}"    && echo "Configure.ProgramTransformName=$$programTransformName" || echo "#   Configure.ProgramTransformName was not specified."
    echo
    echo "# Remember that the configuration script was executed."
    echo "Configure.Configured=yes"
    echo "Configure.Options=$$configureOptions"
} >"$${ZMK_CONFIGURE_MAKEFILE:=GNUmakefile.$(Project.Name).configure.mk}"

if [ ! -e Makefile ] && [ ! -e GNUmakefile ]; then
    if [ -e "$$srcdir"/GNUmakefile ]; then
        ln -s "$$srcdir"/GNUmakefile GNUmakefile
    fi
    if [ -e "$$srcdir"/Makefile ]; then
        ln -s "$$srcdir"/Makefile Makefile
    fi
fi
endef
# In maintainer mode the configure script is automatically updated.
ifeq ($(Configure.MaintainerMode),yes)
$(CURDIR)/configure configure: export ZMK_CONFIGURE_SCRIPT = $(Configure.script)
$(CURDIR)/configure configure: $(ZMK.Path)/z.mk $(wildcard $(ZMK.Path)/zmk/*.mk)
	@echo "$${ZMK_CONFIGURE_SCRIPT}" >$@
	$(call Silent.Say,GENERATE,$@)
	$(Silent.Command)chmod +x $@

# In maintainer mode, re-configure in response to updates to the configuration script.
ifeq ($(Configure.Configured),yes)
GNUmakefile.$(Project.Name).configure.mk: configure
	$(call Silent.Say,CONFIGURE,$(sort $(Configure.Options) ZMK.SrcDir=$(ZMK.SrcDir)))
	$(if Configure.SilentRules,,@echo "re-configuring, $< script is newer than $@")
	$(Silent.Command)$(strip sh $< $(sort $(Configure.Options) ZMK.SrcDir=$(ZMK.SrcDir)))
# Enable silent rules if configured to do so.
override Silent.Active = $(Configure.SilentRules)
endif # !configured
endif # !maintainer mode
distclean::
	$(call Silent.Say,RM,GNUmakefile.$(Project.Name).configure.mk)
	$(Silent.Command)rm -f GNUmakefile.$(Project.Name).configure.mk
endif # !project name set
