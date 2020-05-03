# NAME defines the name of the "project". It is used in several places, like
# the location of documentation files /usr/share/doc/$(NAME)/ and as a name of
# several support archives and analysis reports.
NAME = hello

# This is include statement is importing zmk from either the current working
# directory or from the system-wide location like /usr/include. The former case
# is typical when building an application from source code provided in a
# release archive. The latter is typical when working with a version control
# system checkout. Note that this design does not force zmk as a
# build-dependency. Only upstream developers need zmk installed on their
# system.
include z.mk

# zmk provides a simple module system, where particular modules can import
# other modules and the import graph forms a direct acyclic graph. This is
# built on top of the raw Make include system, using a pair of eval/call
# functions.
#
# Note that there are two ways to import a module, all modules called
# Module.something can be imported just like you would typically expect.
# Template modules are *spawned* with a particular instance name.
#
# The code below imports the configure module and spawns an instance of the two
# kinds of library templates, with a unique name of "libhello.a" and
# "libhello.so" or "libhello.dylib", depending on the type of OS used.
#
# You can see additional build system details by setting the DEBUG environment
# variable. It takes a comma-separated list of words corresponding to an
# action, such as "import" or "spawn", or module names, such as "toolchain" or
# "OS". Try DEBUG=spawn to learn more about how this example works.
$(eval $(call import,Module.configure))

# zmk uses a style of declaring what looks like instance variables before
# spawning a particular template. Each template and module is documented in a
# distinct manual page. For example, the program template is documented in
# zmk.Template.program(5) manual page.

# The hello library has a public header file that gets installed to the
# appropriate directory. Note that unlike some of the other templates used in
# zmk, this one does not require any additional variables to use.
$(eval $(call spawn,Template.header,hello.h))

# Our library will be offered in two flavours, as a static library, linked into
# the executable at build time, and as a dynamic library, linked into the
# executable at runtime.

# This static library is comprised of just one object file, that built from the
# "hello.c" file. Remember that ordering matters, we must define all variables
# that influence a template *before* using the spawn function.
#
# For more information about building static libraries with zmk, see the
# zmk.Template.library.a(5) manual page.
libhello.a.sources = hello.c
$(eval $(call spawn,Template.library.a,libhello.a))

# The .so (standing for "shared object") is a kind of dynamically linked
# library used on many systems using the ELF file format. Shared objects have a
# so-called "soname". Read all about it here if you are not familiar with the
# concept https://en.wikipedia.org/wiki/Soname
#
# Shared libraries can also define a linker script, which contains more precise
# definition of the public symbols and allows for using ELF symbol versions,
# although we are not providing one here.
ifneq (,$(OS.has_elf))
libhello.so.sources = hello.c
libhello.so.soname = hello.so.1
# libhello.so.version-script hello.map
$(eval $(call spawn,Template.library.so,libhello.so))
endif

ifneq (,$(OS.has_macho))
# The .dylib is a kind of dynamically linked library used on MacOS.  Note that
# the position of the version number differs between .so files and .dylib
# files.
libhello.dylib.sources = hello.c
libhello.dylib.soname = hello.1.dylib
$(eval $(call spawn,Template.library.dylib,libhello.dylib))
endif
