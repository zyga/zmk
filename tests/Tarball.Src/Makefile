include z.mk
NAME = test
VERSION = 1

$(NAME)_$(VERSION).tar.gz.Files += foo.txt
$(eval $(call ZMK.Expand,Tarball.Src,$(NAME)_$(VERSION).tar.gz))