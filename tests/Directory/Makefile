include z.mk

$(eval $(call ZMK.Import,Directories))

# Relative directory in the build tree
$(eval $(call ZMK.Expand,Directory,subdir/subsubdir))

# Sub-directory of a known directory.
$(eval $(call ZMK.Expand,Directory,$(libdir)/extra))

# Custom directory with duplicates and trailing slash.
$(eval $(call ZMK.Expand,Directory,/foo))
$(eval $(call ZMK.Expand,Directory,/foo))
$(eval $(call ZMK.Expand,Directory,/foo/))

# Custom directories with implicitly defined parents.
$(eval $(call ZMK.Expand,Directory,/custom/long/path))

# Custom directories with explicitly defined parents.
$(eval $(call ZMK.Expand,Directory,/))
$(eval $(call ZMK.Expand,Directory,/other))
$(eval $(call ZMK.Expand,Directory,/other/custom/))
$(eval $(call ZMK.Expand,Directory,/other/custom/path))

debug:: subdir/subsubdir $(addprefix $(DESTDIR),$(libdir)/extra /foo /custom/long/path /other/custom/path)
