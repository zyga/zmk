# NAME defines the name of the "project". It is used in several places,
# like the location of documentation files /usr/share/doc/$(NAME)/ and as
# a name of several support archives and analysis reports.
NAME = hello

include z.mk
$(eval $(call import,Module.configure))
hello.sources = hello.c
$(eval $(call spawn,Template.program,hello))
