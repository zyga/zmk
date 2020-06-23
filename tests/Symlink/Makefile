include z.mk

name.InstallDir = /some/path
name.SymlinkTarget=target
$(eval $(call ZMK.Expand,Symlink,name))

subdir/name.InstallDir = /other/path
subdir/name.SymlinkTarget=../target
$(eval $(call ZMK.Expand,Symlink,subdir/name))
