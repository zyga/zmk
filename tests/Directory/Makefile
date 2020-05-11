NAME = test
include z.mk

$(eval $(call ZMK.Expand,Directory,/foo))
# Duplicates are not a problem and do not cause clashing rules to be generated.
$(eval $(call ZMK.Expand,Directory,/foo))

install:: $(DESTDIR)/foo
