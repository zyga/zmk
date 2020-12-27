include z.mk
NAME = test
VERSION = 1

$(NAME)_$(VERSION).tar.gz.Files += foo.txt Makefile
$(eval $(call ZMK.Expand,Tarball.Src,$(NAME)_$(VERSION).tar.gz))
