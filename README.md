# zmk is a collection of reusable makefiles

ZMK is a feature-rich library for writing Makefiles. It provides a good degree
of features of the classic auto{conf,make} + libtool tool-chain, while being
easier to understand, highly-parallel and, most importantly, devoid of
generated cruft that's just unreadable by humans.

```
include z.mk

Project.Name = hello
Project.Version = 1

hello.Sources = hello.c
$(eval $(call ZMK.Expand,Program,hello))
```

ZMK integrates nicely with package managers which expect autotools, it comes
with a short, readable configuration script that accepts many of the same
options that autoconf would expose. It's just a `make configure` away.

## Features

 - Describe programs, test programs, static libraries, shared libraries,
   development headers, manual pages and more
 - Use familiar targets like "all", "check", "install" and "clean"
 - Works out of the box on popular distributions of Linux and MacOS
 - Friendly to distribution packaging expecting autotools
 - Compile natively with gcc, clang, tcc or the open-watcom compilers
 - Cross compile with gcc and open-watcom
 - Efficient and incremental, including the install target

## Examples

Please browse the examples present in the git repository. If you had installed
zmk through the Debian package, the examples are added to the `zmk-doc`
package. Use `dpkg -L zmk-doc` to find them.

## Stability Guarantee

ZMK is a responsible library. The project promises not to introduce
backwards-incompatible changes in normal circumstances. ZMK is implemented as a
Make library, which effectively means there are only make rules and variables.
ZMK considers all capitalized symbols, such as `ZMK.Program` to be the public
API covered by the stability guarantee. Internal symbols either start with a
lower case character, or have one immediately follwing a dot, for example
`zmk.foo` or `ZMK.foo`.
character, for example `ZMK.test`
