NAME = true_false

include z.mk

true.sources = true_false.c
$(eval $(call spawn,Template.program,true))
true$(exe): CPPFLAGS += -DEXIT_CODE=EXIT_SUCCESS

false.sources = true_false.c
$(eval $(call spawn,Template.program,false))
false$(exe): CPPFLAGS += -DEXIT_CODE=EXIT_FAILURE
