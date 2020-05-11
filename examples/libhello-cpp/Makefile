NAME = hello                                            # Define name of the project
include z.mk                                            # Include the zmk library

$(eval $(call ZMK.Expand,Header,hello.h))               # Expand template for header files with the name hello.h

$(eval $(call ZMK.Import,Toolchain))                    # Import module "toolchain" to know about shared library types

libhello.a.Sources = hello.cpp                          # Define the source files to compile into libhello.a
$(eval $(call ZMK.Expand,Library.A,libhello.a))         # Expand template for static libraries with the name libhello.a

ifeq ($(Toolchain.CXX.ImageFormat),ELF)                 # If the C++ compiler is producing ELF files then ...
libhello.so.1.Sources = hello.cpp                       # Define the source files to compile into libhello.so.1
libhello.so.1.VersionScript =                           # Indicate that we don't have a version script for this library
$(eval $(call ZMK.Expand,Library.So,libhello.so.1))     # Expand template for .so shared libraries with the name libhello.so.1
endif                                                   # End the if statement opened earlier

ifeq ($(Toolchain.CXX.ImageFormat),Mach-O)              # If the C++ compiler is producing Mach-O files then ...
libhello.1.dylib.Sources = hello.cpp                    # Define the source files to compile into libhello.1.dylib
libhello.1.dylib.ExportList =                           # Indicate that we don't have an export list for this library
$(eval $(call ZMK.Expand,Library.DyLib,libhello.1.dylib))   # Expand template for .dylib shared libraries with the name libhello.1.dylib
endif                                                   # End the if statement opened earlier
