ARCHS = armv7 arm64

include theos/makefiles/common.mk

BUNDLE_NAME = WallmartSettings
WallmartSettings_FILES = WallmartSettings.mm
WallmartSettings_INSTALL_PATH = /Library/PreferenceBundles
WallmartSettings_FRAMEWORKS = UIKit AssetsLibrary
WallmartSettings_PRIVATE_FRAMEWORKS = Preferences
WallmartSettings_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/WallmartSettings.plist$(ECHO_END)
