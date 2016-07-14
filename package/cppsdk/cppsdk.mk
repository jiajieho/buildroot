################################################################################
#
# cppsdk
#
################################################################################

CPPSDK_VERSION = 8d67371b74765372a649391464fd2a6fab2a9586
CPPSDK_SITE_METHOD = git
CPPSDK_SITE = git@github.com:Metrological/cppsdk.git
CPPSDK_INSTALL_STAGING = YES
CPPSDK_DEPENDENCIES = zlib

CPPSDK_CONF_OPTS += -DBUILDREF_CPPSDK=$(shell $(GIT) rev-parse HEAD)

ifeq ($(BR2_PACKAGE_RPI_USERLAND),y)
CPPSDK_CONF_OPTS += -DCPPSDK_PLATFORM=RPI
CPPSDK_DEPENDENCIES += rpi-userland
else ifeq ($(BR2_PACKAGE_BCM_REFSW)$(BR2_arm),yy) 
CPPSDK_CONF_OPTS += -DCPPSDK_PLATFORM=EOS
CPPSDK_DEPENDENCIES += bcm-refsw
else ifeq ($(BR2_PACKAGE_BCM_REFSW)$(BR2_mipsel),yy)
CPPSDK_CONF_OPTS += -DCPPSDK_PLATFORM=DAWN
CPPSDK_DEPENDENCIES += bcm-refsw
else ifeq ($(BR2_PACKAGE_INTELCE_SDK),y)
CPPSDK_CONF_OPTS += -DCPPSDK_PLATFORM=INTELCE
CPPSDK_DEPENDENCIES += intelce-osal
else ifeq ($(BR2_PACKAGE_HORIZON_SDK),y)
CPPSDK_CONF_OPTS += -DCPPSDK_PLATFORM=INTELCE
CPPSDK_DEPENDENCIES += horizon-sdk
else
$( error "-DCPPSDK_PLATFORM not set")
endif

ifeq ($(BR2_ENABLE_DEBUG),y)
CPPSDK_CONF_OPTS += -DCPPSDK_DEBUG=ON
else ifeq ($(BR2_PACKAGE_CPPSDK_DEBUG),y)
CPPSDK_CONF_OPTS += -DCPPSDK_DEBUG=ON
endif

ifeq ($(BR2_PACKAGE_CPPSDK_DEADLOCK_DETECTION),y)
CPPSDK_CONF_OPTS += -DCPPSDK_DEADLOCK_DETECTION=ON
endif

ifeq ($(BR2_PACKAGE_CPPSDK_GENERICS),y)
CPPSDK_CONF_OPTS += -DCPPSDK_GENERICS=ON
endif

ifeq ($(BR2_PACKAGE_CPPSDK_CRYPTALGO),y)
CPPSDK_CONF_OPTS += -DCPPSDK_CRYPTALGO=ON
endif

ifeq ($(BR2_PACKAGE_CPPSDK_WEBSOCKET),y)
CPPSDK_CONF_OPTS += -DCPPSDK_WEBSOCKET=ON
CPPSDK_DEPENDENCIES += zlib
endif

ifeq ($(BR2_PACKAGE_CPPSDK_TRACING),y)
CPPSDK_CONF_OPTS += -DCPPSDK_TRACING=ON
endif

ifeq ($(BR2_PACKAGE_CPPSDK_PROFILER),y)
CPPSDK_CONF_OPTS += -DCPPSDK_PROFILER=ON
endif

ifeq ($(BR2_PACKAGE_CPPSDK_RPC),y)
CPPSDK_CONF_OPTS += -DCPPSDK_RPC=ON
endif

ifeq ($(BR2_PACKAGE_CPPSDK_PROCESS),y)
CPPSDK_CONF_OPTS += -DCPPSDK_PROCESS=ON
endif

ifeq ($(BR2_PACKAGE_CPPSDK_DEVICES),y)
CPPSDK_CONF_OPTS += -DCPPSDK_DEVICES=ON
endif

ifeq ($(BR2_PACKAGE_CPPSDK_MQC),y)
CPPSDK_CONF_OPTS += -DCPPSDK_MQC=ON
endif

$(eval $(cmake-package))
