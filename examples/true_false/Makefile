include z.mk                                            # Include the zmk library

true.Sources = true_false.c                             # Define the source files to compile into true
$(eval $(call ZMK.Expand,Program,true))                 # Expand template for programs with the name true
true$(exe): CPPFLAGS += -DEXIT_CODE=EXIT_SUCCESS        # Pass macro definition when compiling true

false.Sources = true_false.c                            # Define the source files to compile into false
$(eval $(call ZMK.Expand,Program,false))                # Expand template for programs with the name false
false$(exe): CPPFLAGS += -DEXIT_CODE=EXIT_FAILURE       # Pass macro definition when compiling false
