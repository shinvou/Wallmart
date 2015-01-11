GO_EASY_ON_ME = 1

TARGET = iphone:clang:latest:8.0
ARCHS = armv7 armv7s arm64

THEOS_DEVICE_IP = 127.0.0.1
THEOS_DEVICE_PORT = 2222
THEOS_PACKAGE_DIR_NAME = deb

include theos/makefiles/common.mk

TWEAK_NAME = Wallmart
Wallmart_FILES = Tweak.xm WallmartEvent.xm
Wallmart_FRAMEWORKS = UIKit AssetsLibrary
Wallmart_PRIVATE_FRAMEWORKS = PhotoLibrary

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += WallmartSettings

include $(THEOS_MAKE_PATH)/aggregate.mk

internal-stage::
	@mkdir -p $(THEOS_STAGING_DIR)/Library/Activator/Listeners/com.shinvou.wallmartevent
	@cp Info.plist $(THEOS_STAGING_DIR)/Library/Activator/Listeners/com.shinvou.wallmartevent/Info.plist
before-stage::
	find . -name ".DS_Store" -delete
after-install::
	install.exec "killall -9 backboardd"
