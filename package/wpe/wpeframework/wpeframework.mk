################################################################################
#
# wpeframework
#
################################################################################

WPEFRAMEWORK_VERSION = c1dfbe980fa5addce6ab7692a1221d236ce139b7
WPEFRAMEWORK_SITE = $(call github,rdkcentral,Thunder,$(WPEFRAMEWORK_VERSION))
WPEFRAMEWORK_INSTALL_STAGING = YES
WPEFRAMEWORK_DEPENDENCIES = zlib $(call qstrip,$(BR2_PACKAGE_SDK_INSTALL)) host-wpeframework-tools

WPEFRAMEWORK_CONF_OPTS += -DBUILD_REFERENCE=$(WPEFRAMEWORK_VERSION) -DTREE_REFERENCE=$(shell $(GIT) rev-parse HEAD)
WPEFRAMEWORK_CONF_OPTS += -DPORT=$(BR2_PACKAGE_WPEFRAMEWORK_PORT)
WPEFRAMEWORK_CONF_OPTS += -DBINDING=$(BR2_PACKAGE_WPEFRAMEWORK_BIND)
WPEFRAMEWORK_CONF_OPTS += -DIDLE_TIME=$(BR2_PACKAGE_WPEFRAMEWORK_IDLE_TIME)
WPEFRAMEWORK_CONF_OPTS += -DPERSISTENT_PATH=$(BR2_PACKAGE_WPEFRAMEWORK_PERSISTENT_PATH)
WPEFRAMEWORK_CONF_OPTS += -DVOLATILE_PATH=$(BR2_PACKAGE_WPEFRAMEWORK_VOLATILE_PATH)
WPEFRAMEWORK_CONF_OPTS += -DDATA_PATH=$(BR2_PACKAGE_WPEFRAMEWORK_DATA_PATH)
WPEFRAMEWORK_CONF_OPTS += -DSYSTEM_PATH=$(BR2_PACKAGE_WPEFRAMEWORK_SYSTEM_PATH)
WPEFRAMEWORK_CONF_OPTS += -DPROXYSTUB_PATH=$(BR2_PACKAGE_WPEFRAMEWORK_PROXYSTUB_PATH)
WPEFRAMEWORK_CONF_OPTS += -DOOMADJUST=$(BR2_PACKAGE_WPEFRAMEWORK_OOM_ADJUST)
WPEFRAMEWORK_CONF_OPTS += -DHIDE_NON_EXTERNAL_SYMBOLS=OFF

# WPEFRAMEWORK_CONF_OPTS += -DWEBSERVER_PATH=
# WPEFRAMEWORK_CONF_OPTS += -DWEBSERVER_PORT=
# WPEFRAMEWORK_CONF_OPTS += -DCONFIG_INSTALL_PATH=
# WPEFRAMEWORK_CONF_OPTS += -DIPV6_SUPPORT=
# WPEFRAMEWORK_CONF_OPTS += -DPRIORITY=
# WPEFRAMEWORK_CONF_OPTS += -DPOLICY=
# WPEFRAMEWORK_CONF_OPTS += -DSTACKSIZE=

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_EXCEPTIONS_ENABLE),y)
	WPEFRAMEWORK_CONF_OPTS += -DEXCEPTIONS_ENABLE=ON
else
	WPEFRAMEWORK_CONF_OPTS += -DEXCEPTIONS_ENABLE=OFF
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_BUILD_TYPE_DEBUG),y)
	WPEFRAMEWORK_CONF_OPTS += -DBUILD_TYPE=Debug
else ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_BUILD_TYPE_DEBUG_OPTIMIZED),y)
	WPEFRAMEWORK_CONF_OPTS += -DBUILD_TYPE=DebugOptimized
else ifeq ($( BR2_PACKAGE_WPEFRAMEWORK_BUILD_TYPE_RELEASE_WITH_SYMBOLS),y)
	WPEFRAMEWORK_CONF_OPTS += -DBUILD_TYPE=ReleaseSymbols
else ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_BUILD_TYPE_RELEASE),y)
	WPEFRAMEWORK_CONF_OPTS += -DBUILD_TYPE=Release
else ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_BUILD_TYPE_PRODUCTION),y)
	WPEFRAMEWORK_CONF_OPTS += -DBUILD_TYPE=Production
endif

ifneq ($(BR2_PACKAGE_WPEFRAMEWORK_TRACE_SETTINGS),"")
WPEFRAMEWORK_CONF_OPTS += -DTRACE_SETTINGS="$(call qstrip,$(BR2_PACKAGE_WPEFRAMEWORK_TRACE_SETTINGS))"
endif

ifneq ($(BR2_PACKAGE_WPEFRAMEWORK_SYSTEM_PREFIX),"")
WPEFRAMEWORK_CONF_OPTS += -DSYSTEM_PREFIX="$(call qstrip,$(BR2_PACKAGE_WPEFRAMEWORK_SYSTEM_PREFIX))"
endif

ifeq ($(BR2_PACKAGE_BLUEZ5_UTILS),y)
WPEFRAMEWORK_CONF_OPTS += -DBLUETOOTH_SUPPORT=ON -DBLUETOOTH=ON
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_BLUETOOTH),y)
WPEFRAMEWORK_EXTERN_EVENTS += Bluetooth
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_SECURE_SOCKET),y)
WPEFRAMEWORK_DEPENDENCIES += openssl
WPEFRAMEWORK_CONF_OPTS += -DSECURE_SOCKET=ON
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_BROADCAST),y)
WPEFRAMEWORK_CONF_OPTS += -DBROADCAST=ON
ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_BROADCAST_SI_PARSING),y)
WPEFRAMEWORK_CONF_OPTS += -DBROADCAST_SI_PARSING=ON
endif
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_CRYPTOGRAPHY),y)
WPEFRAMEWORK_CONF_OPTS += -DCRYPTOGRAPHY=ON
ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_CRYPTOGRAPHY_IMPLEMENTATION_NEXUS),y)
WPEFRAMEWORK_CONF_OPTS += -DCRYPTOGRAPHY_IMPLEMENTATION=Nexus
else ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_CRYPTOGRAPHY_IMPLEMENTATION_OPENSSL),y)
WPEFRAMEWORK_CONF_OPTS += -DCRYPTOGRAPHY_IMPLEMENTATION=OpenSSL
else ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_CRYPTOGRAPHY_IMPLEMENTATION_THUNDER),y)
WPEFRAMEWORK_CONF_OPTS += -DCRYPTOGRAPHY_IMPLEMENTATION=Thunder
else
$(error Missing a cryptography implementation)
endif
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_PROCESSCONTAINERS),y)
WPEFRAMEWORK_CONF_OPTS += -DPROCESSCONTAINERS=ON
ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_PROCESSCONTAINERS_BE_LXC),y)
WPEFRAMEWORK_CONF_OPTS += -DPROCESSCONTAINERS_LXC=ON
WPEFRAMEWORK_DEPENDENCIES += lxc
endif
ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_PROCESSCONTAINERS_BE_RUNC),y)
WPEFRAMEWORK_CONF_OPTS += -DPROCESSCONTAINERS_RUNC=ON
endif
ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_PROCESSCONTAINERS_BE_CRUN),y)
WPEFRAMEWORK_CONF_OPTS += -DPROCESSCONTAINERS_CRUN=ON
WPEFRAMEWORK_DEPENDENCIES += crun
endif
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_CDM),y)
WPEFRAMEWORK_CONF_OPTS += -DCDMI=ON
ifeq ($(BR2_PACKAGE_HAS_NEXUS_SAGE),y)
WPEFRAMEWORK_CONF_OPTS += -DCDMI_BCM_NEXUS_SVP=ON
WPEFRAMEWORK_CONF_OPTS += -DCDMI_ADAPTER_IMPLEMENTATION="broadcom-svp"
WPEFRAMEWORK_DEPENDENCIES += gst1-bcm
else
WPEFRAMEWORK_CONF_OPTS += -DCDMI_ADAPTER_IMPLEMENTATION="gstreamer"
endif
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_PROVISIONING),y)
WPEFRAMEWORK_EXTERN_EVENTS += Provisioning
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_LOCATIONSYNC),y)
WPEFRAMEWORK_EXTERN_EVENTS += Internet
WPEFRAMEWORK_EXTERN_EVENTS += Location
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_TIMESYNC),y)
WPEFRAMEWORK_EXTERN_EVENTS += Time
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_COMPOSITOR),y)
WPEFRAMEWORK_EXTERN_EVENTS += Platform
WPEFRAMEWORK_EXTERN_EVENTS += Graphics
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_NETWORKCONTROL),y)
WPEFRAMEWORK_EXTERN_EVENTS += Network
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_CDMI),y)
WPEFRAMEWORK_EXTERN_EVENTS += Decryption
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_STREAMER),y)
PEFRAMEWORK_EXTERN_EVENTS += Streaming
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_WEBKITBROWSER),y)
WPEFRAMEWORK_CONF_OPTS += -DPLUGIN_WEBKITBROWSER=ON
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_WEBSERVER),y)
WPEFRAMEWORK_EXTERN_EVENTS += WebSource
WPEFRAMEWORK_CONF_OPTS += -DPLUGIN_WEBSERVER=ON
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_ESPIAL),y)
WPEFRAMEWORK_CONF_OPTS += -DPLUGIN_ESPIAL=ON
endif

WPEFRAMEWORK_CONF_OPTS += -DEXTERN_EVENTS="${WPEFRAMEWORK_EXTERN_EVENTS}"

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_NETWORKCONTROL),y)
define WPEFRAMEWORK_POST_TARGET_INITD
	mkdir -p $(TARGET_DIR)/etc/init.d
	$(INSTALL) -D -m 0755 $(WPEFRAMEWORK_PKGDIR)/S80WPEFramework $(TARGET_DIR)/etc/init.d/S40WPEFramework
endef
else
define WPEFRAMEWORK_POST_TARGET_INITD
	mkdir -p $(TARGET_DIR)/etc/init.d
	$(INSTALL) -D -m 0755 $(WPEFRAMEWORK_PKGDIR)/S80WPEFramework $(TARGET_DIR)/etc/init.d
endef
endif

define WPEFRAMEWORK_POST_TARGET_REMOVE_STAGING_ARTIFACTS
	mkdir -p $(TARGET_DIR)/etc/WPEFramework
	rm -rf $(TARGET_DIR)/usr/share/WPEFramework/cmake
endef

define WPEFRAMEWORK_POST_TARGET_REMOVE_HEADERS
	rm -rf $(TARGET_DIR)/usr/include/WPEFramework
endef

define WPEFRAMEWORK_POST_STAGING_CDM_HEADER
	ln -sfn $(STAGING_DIR)/usr/include/WPEFramework/interfaces/IDRM.h $(STAGING_DIR)/usr/include/cdmi.h
endef

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_CDM),y)
WPEFRAMEWORK_POST_INSTALL_STAGING_HOOKS += WPEFRAMEWORK_POST_STAGING_CDM_HEADER
endif

ifneq ($(BR2_PACKAGE_WPEFRAMEWORK_DISABLE_INITD),y)
WPEFRAMEWORK_POST_INSTALL_TARGET_HOOKS += WPEFRAMEWORK_POST_TARGET_INITD
endif

WPEFRAMEWORK_POST_INSTALL_TARGET_HOOKS += WPEFRAMEWORK_POST_TARGET_REMOVE_STAGING_ARTIFACTS
ifneq ($(BR2_PACKAGE_WPEFRAMEWORK_INSTALL_HEADERS),y)
WPEFRAMEWORK_POST_INSTALL_TARGET_HOOKS += WPEFRAMEWORK_POST_TARGET_REMOVE_HEADERS
endif

# Temporary fix for vss platforms
ifeq ($(BR2_PACKAGE_VSS_SDK_MOVE_GSTREAMER),y)
WPEFRAMEWORK_PKGDIR = "$(TOP_DIR)/package/wpe/wpeframework"

define WPEFRAMEWORK_APPLY_LOCAL_PATCHES
 # this platform needs to run this gstreamer version parallel
 # to an older version.
 $(APPLY_PATCHES) $(@D) $(WPEFRAMEWORK_PKGDIR) 9999-link_to_wpe_gstreamer.patch.conditional
endef
WPEFRAMEWORK_POST_PATCH_HOOKS += WPEFRAMEWORK_APPLY_LOCAL_PATCHES
endif

$(eval $(cmake-package))
