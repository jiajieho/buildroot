################################################################################
#
# wpewebkit
#
################################################################################

WPEWEBKIT_VERSION = 73879248fb299340a3e9611dc4ae0618fcfae6ea
WPEWEBKIT_SITE = $(call github,WebPlatformForEmbedded,WPEWebKit,$(WPEWEBKIT_VERSION))
WPEWEBKIT_INSTALL_STAGING = YES
WPEWEBKIT_LICENSE = LGPL-2.1+, BSD-2-Clause
WPEWEBKIT_LICENSE_FILES = \
	Source/WebCore/LICENSE-APPLE \
	Source/WebCore/LICENSE-LGPL-2.1
WPEWEBKIT_DEPENDENCIES = host-gperf host-python host-ruby \
	harfbuzz cairo icu jpeg libepoxy libgcrypt libgles libsoup libtasn1 \
	libpng libxslt openjpeg webp libwpe

WPEWEBKIT_CONF_OPTS = \
	-DPORT=WPE \
	-DENABLE_ACCESSIBILITY=OFF \
	-DENABLE_API_TESTS=OFF \
	-DENABLE_MINIBROWSER=OFF \
	-DSILENCE_CROSS_COMPILATION_NOTICES=ON

ifeq ($(BR2_PACKAGE_WPEWEBKIT_SANDBOX),y)
WPEWEBKIT_CONF_OPTS += \
	-DENABLE_BUBBLEWRAP_SANDBOX=ON \
	-DBWRAP_EXECUTABLE=/usr/bin/bwrap \
	-DDBUS_PROXY_EXECUTABLE=/usr/bin/xdg-dbus-proxy
WPEWEBKIT_DEPENDENCIES += libseccomp
else
WPEWEBKIT_CONF_OPTS += -DENABLE_BUBBLEWRAP_SANDBOX=OFF
endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT_MULTIMEDIA),y)
WPEWEBKIT_CONF_OPTS += \
	-DENABLE_VIDEO=ON \
	-DENABLE_WEB_AUDIO=ON
WPEWEBKIT_DEPENDENCIES += gstreamer1 gst1-libav gst1-plugins-base gst1-plugins-good
else
WPEWEBKIT_CONF_OPTS += \
	-DENABLE_VIDEO=OFF \
	-DENABLE_WEB_AUDIO=OFF
endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT_USE_GSTREAMER_GL),y)
WPEWEBKIT_CONF_OPTS += -DUSE_GSTREAMER_GL=ON
else
WPEWEBKIT_CONF_OPTS += -DUSE_GSTREAMER_GL=OFF
endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT_WEBDRIVER),y)
WPEWEBKIT_CONF_OPTS += -DENABLE_WEBDRIVER=ON
else
WPEWEBKIT_CONF_OPTS += -DENABLE_WEBDRIVER=OFF
endif

ifeq ($(BR2_PACKAGE_WOFF2),y)
WPEWEBKIT_CONF_OPTS += -DUSE_WOFF2=ON
WPEWEBKIT_DEPENDENCIES += woff2
else
WPEWEBKIT_CONF_OPTS += -DUSE_WOFF2=OFF
endif

# JIT is not supported for MIPS r6, but the WebKit build system does not
# have a check for these processors. Disable JIT forcibly here and use
# the CLoop interpreter instead.
#
# Upstream bug: https://bugs.webkit.org/show_bug.cgi?id=191258
ifeq ($(BR2_MIPS_CPU_MIPS32R6)$(BR2_MIPS_CPU_MIPS64R6),y)
WPEWEBKIT_CONF_OPTS += -DENABLE_JIT=OFF -DENABLE_C_LOOP=ON
endif

# Holepunch options.
ifeq ($(BR2_PACKAGE_WPEWEBKIT_USE_PUNCH_HOLE_GSTREAMER),y)
WPEWEBKIT_CONF_OPTS += -DUSE_GSTREAMER_HOLEPUNCH=ON
else ifeq ($(BR2_PACKAGE_WPEWEBKIT_USE_PUNCH_HOLE_EXTERNAL),y)
WPEWEBKIT_CONF_OPTS += -DUSE_EXTERNAL_HOLEPUNCH=ON
endif

# Platform definitions.
ifeq ($(BR2_PACKAGE_WESTEROS),y)
WPEWEBKIT_DEPENDENCIES += westeros
WPEWEBKIT_CONF_OPTS += -DUSE_WPEWEBKIT_PLATFORM_WESTEROS=ON
ifeq ($(BR2_PACKAGE_WESTEROS_SINK),y)
WPEWEBKIT_DEPENDENCIES += westeros-sink
WPEWEBKIT_CONF_OPTS += -DUSE_WESTEROS_SINK=ON -DUSE_GSTREAMER_HOLEPUNCH=ON
else
WPEWEBKIT_CONF_OPTS += -DUSE_GSTREAMER_HOLEPUNCH=OFF
endif
else ifeq ($(BR2_PACKAGE_HAS_NEXUS),y)
WPEWEBKIT_CONF_OPTS += -DUSE_WPEWEBKIT_PLATFORM_BCM_NEXUS=ON
else ifeq ($(BR2_PACKAGE_HORIZON_SDK),y)
WPEWEBKIT_CONF_OPTS += -DUSE_WPEWEBKIT_PLATFORM_INTEL_CE=ON
else ifeq ($(BR2_PACKAGE_INTELCE_SDK),y)
WPEWEBKIT_CONF_OPTS += -DUSE_WPEWEBKIT_PLATFORM_INTEL_CE=ON
else ifeq ($(BR2_PACKAGE_RPI_FIRMWARE),y)
WPEWEBKIT_CONF_OPTS += -DUSE_WPEWEBKIT_PLATFORM_RPI=ON
endif


$(eval $(cmake-package))
