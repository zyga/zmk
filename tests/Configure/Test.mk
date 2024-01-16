#!/usr/bin/make -f
include zmk/internalTest.mk

t:: \
	configure-shellcheck \
	configure-enable-option-checking \
	configure-disable-option-checking \
	debug-defaults \
	debug-configure \
	config-defaults \
	config-build \
	config-host \
	config-target \
	config-with-libtool-sysroot \
	config-enable-dependency-tracking \
	config-disable-dependency-tracking \
	config-enable-maintainer-mode \
	config-disable-maintainer-mode \
	config-enable-silent-rules \
	config-disable-silent-rules \
	config-enable-static \
	config-disable-static \
	config-enable-dynamic \
	config-disable-dynamic \
	config-enable-debug \
	config-disable-debug \
	config-program-prefix \
	config-program-suffix \
	config-program-transform-name \
	config-prefix \
	config-exec-prefix \
	config-exec_prefix \
	config-bindir \
	config-sbindir \
	config-libdir \
	config-libexecdir \
	config-includedir \
	config-oldincludedir \
	config-mandir \
	config-infodir \
	config-sysconfdir \
	config-datadir \
	config-localstatedir \
	config-runstatedir \
	config-sharedstatedir \
	config-env-CC \
	config-env-CXX \
	config-env-OBJC \
	config-env-CFLAGS \
	config-env-CXXFLAGS \
	config-env-OBJCFLAGS \
	config-env-CPPFLAGS

# Test logs will contain debugging messages specific to the configure module
%.log: ZMK.makeOverrides += DEBUG=configure

# The configure script is generated.
configure: MAKEFLAGS=B
configure: Makefile $(ZMK.test.Path)/z.mk $(wildcard $(ZMK.test.Path)/zmk/*.mk)
	$(MAKE) --no-print-directory -I $(ZMK.test.Path) -f $(ZMK.test.SrcDir)/Makefile $@
c::
	rm -f configure

# The configure script writes a configuration file. Note that normally the file
# is config.$(NAME).mk but the test redirects that to a different file to
# enable parallelism.
configureOptions ?=
configureOptions += $(if $(ZMK.test.IsOutOfTreeBuild),ZMK.SrcDir=$(ZMK.test.SrcDir))
configureEnvironment ?=
config.%.mk: configure Test.mk
	$(strip ZMK_CONFIGURE_MAKEFILE=$@ $(configureEnvironment) ./$< $(configureOptions))
c::
	rm -f config.*.mk

configure-shellcheck: configure
	if [ "`command -v shellcheck`" != "" ]; then shellcheck $<; fi

configure-enable-option-checking: export ZMK_CONFIGURE_MAKEFILE=config.enable-option-checking.mk
configure-enable-option-checking: configure
	./$< --enable-option-checking --foo 2>&1 | GREP -qFx 'configure: unknown option --foo'
	! ./$< --enable-option-checking --foo 2>/dev/null
	test ! -e $(ZMK_CONFIGURE_MAKEFILE)

configure-disable-option-checking: export ZMK_CONFIGURE_MAKEFILE=config.disable-option-checking.mk
configure-disable-option-checking: configure
	./$< --disable-option-checking --foo

debug-defaults: debug-defaults.log
	# Debug messages show the state of internal variables.
	# Note that here we also measure the default values of an un-configured build.
	GREP -qFx 'DEBUG: Configure.HostArchTriplet=' <$<
	GREP -qFx 'DEBUG: Configure.BuildArchTriplet=' <$<
	GREP -qFx 'DEBUG: Configure.TargetArchTriplet=' <$<
	GREP -qFx 'DEBUG: Configure.SysRoot=' <$<
	GREP -qFx 'DEBUG: Configure.DependencyTracking=yes' <$<
	GREP -qFx 'DEBUG: Configure.MaintainerMode=yes' <$<
	GREP -qFx 'DEBUG: Configure.SilentRules=' <$<
	GREP -qFx 'DEBUG: Configure.StaticLibraries=yes' <$<
	GREP -qFx 'DEBUG: Configure.DynamicLibraries=yes' <$<
	GREP -qFx 'DEBUG: Configure.DebugBuild=' <$<
	GREP -qFx 'DEBUG: Configure.ProgramPrefix=' <$<
	GREP -qFx 'DEBUG: Configure.ProgramSuffix=' <$<
	GREP -qFx 'DEBUG: Configure.ProgramTransformName=' <$<
	GREP -qFx 'DEBUG: Configure.Configured=' <$<
	GREP -qFx 'DEBUG: Configure.Options=' <$<

debug-configure.log: ZMK.makeTarget=configure
debug-configure: debug-configure.log
	# The configure script can be remade.
	GREP -qFx 'echo "$${ZMK_CONFIGURE_SCRIPT}" >configure' <$<

config-defaults: config.defaults.mk
	# Minimal defaults are set
	GREP -qFx 'ZMK.SrcDir=$(ZMK.test.SrcDir)' <$<
	GREP -qFx 'Configure.Configured=yes' <$<
	GREP -qFx 'Configure.Options=$(if $(ZMK.test.IsOutOfTreeBuild),ZMK.SrcDir=$(ZMK.test.SrcDir))' <$<
	# Other options are not explicitly set.
	# Note the lack of whole-line matching (-x).
	GREP -v -qF 'Configure.BuildArchTriplet=' <$<
	GREP -v -qF 'Configure.HostArchTriplet=' <$<
	GREP -v -qF 'Configure.TargetArchTriplet=' <$<
	GREP -v -qF 'Configure.SysRoot=' <$<
	GREP -v -qF 'Configure.DependencyTracking=' <$<
	GREP -v -qF 'Configure.MaintainerMode=' <$<
	GREP -v -qF 'Configure.SilentRules=' <$<
	GREP -v -qF 'Configure.StaticLibraries=' <$<
	GREP -v -qF 'Configure.DynamicLibraries=' <$<
	GREP -v -qF 'Configure.DebugBuild=' <$<
	GREP -v -qF 'Configure.ProgramPrefix=' <$<
	GREP -v -qF 'Configure.ProgramSuffix=' <$<
	GREP -v -qF 'Configure.ProgramTransformName=' <$<

config.CC.mk: configureEnvironment += CC=foo-cc
config-CC: config.CC.mk
	# CC=foo-cc configure sets Toolchain.C.BuildArchTriplet
	GREP -qFx 'Configure.BuildArchTriplet=foo-linux-gnu' <$<
	GREP -qFx 'Configure.Options=$(if $(ZMK.test.IsOutOfTreeBuild),ZMK.SrcDir=$(ZMK.test.SrcDir) )--build=foo-linux-gnu' <$<

config.build.mk: configureOptions += --build=foo-linux-gnu
config-build: config.build.mk
	# configure --build= sets Configure.BuildArchTriplet
	GREP -qFx 'Configure.BuildArchTriplet=foo-linux-gnu' <$<
	GREP -qFx 'Configure.Options=$(if $(ZMK.test.IsOutOfTreeBuild),ZMK.SrcDir=$(ZMK.test.SrcDir) )--build=foo-linux-gnu' <$<

config.host.mk: configureOptions += --host=foo-linux-gnu
config-host: config.host.mk
	# configure --host= sets Configure.HostArchTriplet
	GREP -qFx 'Configure.HostArchTriplet=foo-linux-gnu' <$<
	GREP -qFx 'Configure.Options=$(if $(ZMK.test.IsOutOfTreeBuild),ZMK.SrcDir=$(ZMK.test.SrcDir) )--host=foo-linux-gnu' <$<

config.target.mk: configureOptions += --target=foo-linux-gnu
config-target: config.target.mk
	# configure --target= sets Configure.TargetArchTriplet
	GREP -qFx 'Configure.TargetArchTriplet=foo-linux-gnu' <$<
	GREP -qFx 'Configure.Options=$(if $(ZMK.test.IsOutOfTreeBuild),ZMK.SrcDir=$(ZMK.test.SrcDir) )--target=foo-linux-gnu' <$<

config.with-libtool-sysroot.mk: configureOptions += --with-libtool-sysroot=/path
config-with-libtool-sysroot: config.with-libtool-sysroot.mk
	# configure --with-libtool-sysroot= sets Configure.SysRoot
	GREP -qFx 'Configure.SysRoot=/path' <$<
	GREP -qFx 'Configure.Options=$(if $(ZMK.test.IsOutOfTreeBuild),ZMK.SrcDir=$(ZMK.test.SrcDir) )--with-libtool-sysroot=/path' <$<

config.enable-dependency-tracking.mk: configureOptions += --enable-dependency-tracking
config-enable-dependency-tracking: config.enable-dependency-tracking.mk
	# configure --enable-dependency-tracking sets Configure.DependencyTracking=yes
	GREP -qFx 'Configure.DependencyTracking=yes' <$<

config.disable-dependency-tracking.mk: configureOptions += --disable-dependency-tracking
config-disable-dependency-tracking: config.disable-dependency-tracking.mk
	# configure --disable-dependency-tracking sets Configure.DependencyTracking= (empty but set)
	GREP -qFx 'Configure.DependencyTracking=' <$<

config.enable-maintainer-mode.mk: configureOptions += --enable-maintainer-mode
config-enable-maintainer-mode: config.enable-maintainer-mode.mk
	# configure --enable-maintainer-mode sets Configure.MaintainerMode=yes
	GREP -qFx 'Configure.MaintainerMode=yes' <$<

config.disable-maintainer-mode.mk: configureOptions += --disable-maintainer-mode
config-disable-maintainer-mode: config.disable-maintainer-mode.mk
	# configure --disable-dependency-tracking sets Configure.MaintainerMode= (empty but set)
	GREP -qFx 'Configure.MaintainerMode=' <$<

config.enable-silent-rules.mk: configureOptions += --enable-silent-rules
config-enable-silent-rules: config.enable-silent-rules.mk
	# configure --enable-silent-rules sets Configure.SilentRules=yes
	GREP -qFx 'Configure.SilentRules=yes' <$<

config.disable-silent-rules.mk: configureOptions += --disable-silent-rules
config-disable-silent-rules: config.disable-silent-rules.mk
	# configure --disable-dependency-tracking sets Configure.SilentRules= (empty but set)
	GREP -qFx 'Configure.SilentRules=' <$<

config.enable-static.mk: configureOptions += --enable-static
config-enable-static: config.enable-static.mk
	# configure --enable-static sets Configure.StaticLibraries=yes
	GREP -qFx 'Configure.StaticLibraries=yes' <$<

config.disable-static.mk: configureOptions += --disable-static
config-disable-static: config.disable-static.mk
	# configure --disable-static sets Configure.StaticLibraries= (empty but set)
	GREP -qFx 'Configure.StaticLibraries=' <$<

config.enable-dynamic.mk: configureOptions += --enable-dynamic
config-enable-dynamic: config.enable-dynamic.mk
	# configure --enable-dynamic sets Configure.DynamicLibraries=yes
	GREP -qFx 'Configure.DynamicLibraries=yes' <$<

config.disable-dynamic.mk: configureOptions += --disable-dynamic
config-disable-dynamic: config.disable-dynamic.mk
	# configure --disable-dynamic sets Configure.DynamicLibraries= (empty but set)
	GREP -qFx 'Configure.DynamicLibraries=' <$<

config.enable-debug.mk: configureOptions += --enable-debug
config-enable-debug: config.enable-debug.mk
	# configure --enable-debug sets Configure.DebugBuild=yes
	GREP -qFx 'Configure.DebugBuild=yes' <$<

config.disable-debug.mk: configureOptions += --disable-debug
config-disable-debug: config.disable-debug.mk
	# configure --disable-debug sets Configure.DebugBuild= (empty but set)
	GREP -qFx 'Configure.DebugBuild=' <$<

config.program-prefix.mk: configureOptions += --program-prefix=awesome-
config-program-prefix: config.program-prefix.mk
	# configure --program-prefix=foo sets Configure.ProgramPrefix=foo
	GREP -qFx 'Configure.ProgramPrefix=awesome-' <$<

config.program-suffix.mk: configureOptions += --program-suffix=-real
config-program-suffix: config.program-suffix.mk
	# configure --program-suffix=foo sets Configure.ProgramSuffix=foo
	GREP -qFx 'Configure.ProgramSuffix=-real' <$<

config.program-transform-name.mk: configureOptions += --program-transform-name=s/foo/bar/
config-program-transform-name: config.program-transform-name.mk
	# configure --program-transform-name=foo sets Configure.ProgramTransformName=foo
	GREP -qFx 'Configure.ProgramTransformName=s/foo/bar/' <$<

config.prefix.mk: configureOptions += --prefix=/foo
config-prefix: config.prefix.mk
	# configure --prefix=/foo sets prefix=/foo
	GREP -qFx 'prefix=/foo' <$<

config.exec-prefix.mk: configureOptions += --exec-prefix=/foo
config-exec-prefix: config.exec-prefix.mk
	# configure --exec-prefix=/foo sets exec_prefix=/foo
	GREP -qFx 'exec_prefix=/foo' <$<

config.exec_prefix.mk: configureOptions += --exec_prefix=/foo
config-exec_prefix: config.exec_prefix.mk
	# configure --exec_prefix=/foo sets exec_prefix=/foo
	GREP -qFx 'exec_prefix=/foo' <$<

dirs=bindir sbindir libdir libexecdir includedir mandir infodir sysconfdir datadir localstatedir runstatedir sharedstatedir
$(foreach d,$(dirs),config.$d.mk): configureOptions += --$*=/foo
$(addprefix config-,$(dirs)): config-%: config.%.mk
	# configure --$*=/foo sets $*=/foo
	GREP -qFx '$*=/foo' <$<

config.oldincludedir.mk: configureOptions += --oldincludedir=/unused
config-oldincludedir: config.oldincludedir.mk
	# configure --oldincludedir=/unused doesn't do anything
	GREP -v -qFx '/unused' <$<

config.env-CC.mk: configureEnvironment += CC=potato-cc
config-env-CC: config.env-CC.mk
	GREP -qFx 'CC=potato-cc' <$<

config.env-CXX.mk: configureEnvironment += CXX=potato-c++
config-env-CXX: config.env-CXX.mk
	GREP -qFx 'CXX=potato-c++' <$<

# XFAIL: At present this is not implemented.
config.env-OBJC.mk: configureEnvironment += OBJC=potato-objc
config-env-OBJC: config.env-OBJC.mk
	! GREP -qFx 'OBJC=potato-objc' <$<

config.env-CFLAGS.mk: configureEnvironment += CFLAGS=-fpotato
config-env-CFLAGS: config.env-CFLAGS.mk
	GREP -qFx 'CFLAGS=-fpotato' <$<

config.env-CXXFLAGS.mk: configureEnvironment += CXXFLAGS=-fpotato
config-env-CXXFLAGS: config.env-CXXFLAGS.mk
	GREP -qFx 'CXXFLAGS=-fpotato' <$<

config.env-OBJCFLAGS.mk: configureEnvironment += OBJCFLAGS=-fpotato
config-env-OBJCFLAGS: config.env-OBJCFLAGS.mk
	GREP -qFx 'OBJCFLAGS=-fpotato' <$<

config.env-CPPFLAGS.mk: configureEnvironment += CPPFLAGS=-Ipotato
config-env-CPPFLAGS: config.env-CPPFLAGS.mk
	GREP -qFx 'CPPFLAGS=-Ipotato' <$<
