TARGET := iphone:clang:latest:12.2
ARCHS = arm64e arm64
VALID_ARCHS = arm64e arm64
INSTALL_TARGET_PROCESSES = SpringBoard backboardd vot assistivetouchd
SDKVERSION = 12.2
SYSROOT = $(THEOS)/sdks/iPhoneOS12.2.sdk
DEBUG=0
GO_EASY_ON_ME = 1
TWEAK_NAME = celestia

celestia_PRIVATEFRAMEWORKS = SpringBoard VoiceOverTouch
celestia_FRAMEWORKS = UIKit GameController LocalAuthentication
celestia_EXTRA_FRAMEWORKS = Cephei
celestia_FILES =Celestia.x
celestia_CFLAGS += -fobjc-arc -Wno-deprecated-declarations $(IMPORTS) -DTHEOS -Wno-incompatible-pointer-types -Wno-format -Wno-protocol -Wno-unicode-whitespace
include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += celestiaprefs
include $(THEOS_MAKE_PATH)/aggregate.mk

#after-install::
#	install.exec "killall -9 SpringBoard backboardd vot assistivetouchd"
