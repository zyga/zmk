include z.mk

Project.Name = hello

haveSysdir.Info = Is the sysdir.h header file available?
haveSysdir.Macro = HAVE_SYSDIR
define haveSysdir.ProbeProgramText
#include <sysdir.h>
int main(void) {
	return 0;
}
endef
$(eval $(call ZMK.Expand,Probe,haveSysdir))

hello.Sources = hello.c
$(eval $(call ZMK.Expand,Program,hello))
