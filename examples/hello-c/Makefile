NAME = hello                                            # Define name of the project
include z.mk                                            # Include the zmk library

hello.Sources = hello.c                                 # Define the source files to compile into hello
$(eval $(call ZMK.Expand,Program,hello))                # Expand template for programs with the name hello
