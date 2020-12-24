#!/usr/bin/make -f
# This file is a part of zmk test system.
include zmk/internalTest.mk

t:: all install uninstall clean \
    all-silent-rules install-silent-rules uninstall-silent-rules clean-silent-rules \
    all-destdir install-destdir uninstall-destdir clean-destdir

$(eval $(ZMK.isolateHostToolchain))
# Test logs will contain debugging messages
%.log: ZMK.makeOverrides += DEBUG=library.a
# Some logs have silent rules enabled
%-silent-rules.log: ZMK.makeOverrides += Silent.Active=yes
# Some logs have DESTDIR set to /destdir
%-destdir.log: ZMK.makeOverrides += DESTDIR=/destdir
# Test depends on source files
%.log: foo.c

all: all.log
	# Default target compiles source to object files belonging to the library.
	GREP -qFx 'cc -MMD -c -o libfoo.a-foo.o $(ZMK.test.OutOfTreeSourcePath)foo.c' <$<
	# Default target combines object files into an archive
	GREP -qFx 'ar -cr libfoo.a libfoo.a-foo.o' <$<
install: install.log
	# Installing creates the prerequisite directories
	GREP -qFx 'install -d /usr' <$<
	GREP -qFx 'install -d /usr/local' <$<
	# Installing creates the library directory
	GREP -qFx 'install -d /usr/local/lib' <$<
	# Installing copies the library
	GREP -qFx 'install -m 0644 libfoo.a /usr/local/lib/libfoo.a' <$<
uninstall: uninstall.log
	# Uninstalling removes the library
	GREP -qFx 'rm -f /usr/local/lib/libfoo.a' <$<
clean: clean.log
	# Cleaning removes the library
	GREP -qFx 'rm -f libfoo.a' <$<
	# Cleaning removes the object files belonging to the library
	GREP -qFx 'rm -f ./libfoo.a-foo.o' <$<
	# Cleaning removes the dependency files
	GREP -qFx 'rm -f ./libfoo.a-foo.d' <$<

all-silent-rules: all-silent-rules.log
	# Default target compiles source to object files belonging to the library.
	GREP -qFx 'printf "  %-16s %s\n" "CC" "libfoo.a-foo.o"' <$<
	GREP -qFx '#cc -MMD -c -o libfoo.a-foo.o $(ZMK.test.OutOfTreeSourcePath)foo.c' <$<
	# Default target combines object files into an archive
	GREP -qFx 'printf "  %-16s %s\n" "AR" "libfoo.a"' <$<
	GREP -qFx '#ar -cr libfoo.a libfoo.a-foo.o' <$<
install-silent-rules: install-silent-rules.log
	# Installing creates the prerequisite directories
	GREP -qFx 'printf "  %-16s %s\n" "MKDIR" "/usr"' <$<
	GREP -qFx '#install -d /usr' <$<
	GREP -qFx 'printf "  %-16s %s\n" "MKDIR" "/usr/local"' <$<
	GREP -qFx '#install -d /usr/local' <$<
	# Installing creates the library directory
	GREP -qFx 'printf "  %-16s %s\n" "MKDIR" "/usr/local/lib"' <$<
	GREP -qFx '#install -d /usr/local/lib' <$<
	# Installing copies the library
	GREP -qFx 'printf "  %-16s %s\n" "INSTALL" "/usr/local/lib/libfoo.a"' <$<
	GREP -qFx '#install -m 0644 libfoo.a /usr/local/lib/libfoo.a' <$<
uninstall-silent-rules: uninstall-silent-rules.log
	GREP -qFx '#rm -f /usr/local/lib/libfoo.a' <$<
clean-silent-rules: clean-silent-rules.log
	# Cleaning removes the library
	GREP -qFx '#rm -f libfoo.a' <$<
	# Cleaning removes the object files belonging to the library
	GREP -qFx '#rm -f ./libfoo.a-foo.o' <$<
	# Cleaning removes the dependency files
	GREP -qFx '#rm -f ./libfoo.a-foo.d' <$<

all-destdir: all-destdir.log
	# Default target compiles source to object files belonging to the library.
	GREP -qFx 'cc -MMD -c -o libfoo.a-foo.o $(ZMK.test.OutOfTreeSourcePath)foo.c' <$<
	# Default target combines object files into an archive
	GREP -qFx 'ar -cr libfoo.a libfoo.a-foo.o' <$<
install-destdir: install-destdir.log
	# Installing creates the prerequisite directories
	GREP -qFx 'mkdir -p /destdir' <$<
	GREP -qFx 'install -d /destdir/usr' <$<
	GREP -qFx 'install -d /destdir/usr/local' <$<
	# Installing creates the library directory
	GREP -qFx 'install -d /destdir/usr/local/lib' <$<
	# Installing copies the library
	GREP -qFx 'install -m 0644 libfoo.a /destdir/usr/local/lib/libfoo.a' <$<
uninstall-destdir: uninstall-destdir.log
	# Uninstalling removes the library
	GREP -qFx 'rm -f /destdir/usr/local/lib/libfoo.a' <$<
clean-destdir: clean-destdir.log
	# Cleaning removes the library
	GREP -qFx 'rm -f libfoo.a' <$<
	# Cleaning removes the object files belonging to the library
	GREP -qFx 'rm -f ./libfoo.a-foo.o' <$<
	# Cleaning removes the dependency files
	GREP -qFx 'rm -f ./libfoo.a-foo.d' <$<
