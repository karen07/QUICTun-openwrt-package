include $(TOPDIR)/rules.mk

PKG_NAME:=QUICTun
PKG_VERSION:=1.0.0
PKG_RELEASE:=1

ifeq ("$(wildcard ../QUICTun)", "")
PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/karen07/QUICTun.git
PKG_SOURCE_VERSION:=v$(PKG_VERSION)
PKG_MIRROR_HASH:=skip
endif

PKG_MAINTAINER:=Khachatryan Karen <karen0734@gmail.com>
PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=LICENSE

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/QUICTun
  SECTION:=net
  CATEGORY:=Network
  DEPENDS:=+libopenssl3
  TITLE:=QUICTun
  URL:=https://github.com/karen07/QUICTun
endef

define Package/QUICTun/description
  QUICTun
endef

define Package/QUICTun/conffiles
/etc/config/QUICTun
endef

ifneq ("$(wildcard ../QUICTun)", "")
define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ../QUICTun/* $(PKG_BUILD_DIR)/
endef
endif

define Package/QUICTun/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/QUICTun $(1)/usr/bin/QUICTun

	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) files/etc/init.d/QUICTun $(1)/etc/init.d/QUICTun

	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) files/etc/config/QUICTun $(1)/etc/config/QUICTun
endef

$(eval $(call BuildPackage,QUICTun))
