TARGET := iphone:clang:latest:12.2

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = celestiaprefs

celestiaprefs_FILES = CLARootListController.m
celestiaprefs_FRAMEWORKS = UIKit
celestiaprefs_PRIVATE_FRAMEWORKS = Preferences
celestiaprefs_INSTALL_PATH = /Library/PreferenceBundles
celestiaprefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk
