include z.mk

name1.InstallDir = /some/path
name1.SymlinkTarget=target
$(eval $(call ZMK.Expand,Symlink,name1))

name2.InstallDir = /other/path
name2.InstallName = custom-install-name2
name2.SymlinkTarget=target
$(eval $(call ZMK.Expand,Symlink,name2))

subdir/name3.InstallDir = /other/path
subdir/name3.SymlinkTarget=../target
$(eval $(call ZMK.Expand,Symlink,subdir/name3))

subdir/name4.InstallDir = /other/path
subdir/name4.InstallName = custom-install-name4
subdir/name4.SymlinkTarget=../target
$(eval $(call ZMK.Expand,Symlink,subdir/name4))

