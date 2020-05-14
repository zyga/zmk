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
# The code below imports the configure module and spawns an instance of the
# program template, with a unique name "hello".
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
#
# The hello.sources variable lists the source files that form a particular
# program, here just the "hello.c" file. By setting the environment variable
# DEBUG=spawn you can see all the variables of each spawned template instance.

# Notes about Objective C. Unlike C and C++, objective C is differs across
# platforms. MacOS has support for Objective C 2.0 from Apple while Linux
# and other similar operating systems get Objective C 1.x and the GNU Step
# implementation of the Foundation libraries. As such, instead of trying to
# be clever, be practical and allow the author specify exactly what they need
# manually.
#
# Practical applications will most likely add to CFLAGS the following:
# 	$(shell gnustep-config --base-libs): for headless Linux programs
#   -framework Foundation: for headless MacOS programs
#   $(shell gnustep-config --gui-libs): for the rare GNU Step GUI program
#   -framework Cocoa: for the graphical MacOS programs
# Note that CFLAGS are used as a compromise across MacOS make, stuck at an
# old version before GPL-3 and Linux make, which is up-to-date.
hello.sources = hello.m
$(eval $(call spawn,Template.program,hello))
