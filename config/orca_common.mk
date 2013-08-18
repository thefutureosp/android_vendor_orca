# Set audio
PRODUCT_PROPERTY_OVERRIDES += \
    ro.config.ringtone=Themos.ogg \
    ro.config.notification_sound=Proxima.ogg \
    ro.config.alarm_alert=Cesium.ogg

# Orca Packages
PRODUCT_PACKAGES += \
    VoicePlus \
    OrcaWallpapers \
    SunBeam  

# APPS TO COPY
PRODUCT_COPY_FILES += \
    vendor/orca/prebuilt/common/apk/GooManager.apk:system/app/GooManager.apk

# Camera support
PRODUCT_COPY_FILES += \
    vendor/orca/prebuilt/common/media/LMprec_508.emd:system/media/LMprec_508.emd \
    vendor/orca/prebuilt/common/media/PFFprec_600.emd:system/media/PFFprec_600.emd
    
# init.d support
PRODUCT_COPY_FILES += \
    vendor/orca/prebuilt/common/bin/sysinit:system/bin/sysinit \
    vendor/orca/prebuilt/common/etc/init.orca.rc:root/init.orca.rc

# userinit support
PRODUCT_COPY_FILES += \
    vendor/orca/prebuilt/common/etc/init.d/90userinit:system/etc/init.d/90userinit

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/orca/prebuilt/common/bin/backuptool.sh:system/bin/backuptool.sh \
    vendor/orca/prebuilt/common/bin/backuptool.functions:system/bin/backuptool.functions \
    vendor/orca/prebuilt/common/bin/50-backupScript.sh:system/addon.d/50-backupScript.sh

# Gesture enabled JNI
PRODUCT_COPY_FILES += \
    vendor/orca/prebuilt/common/lib/libjni_latinime.so:system/lib/libjni_latinime.so

# Bring in all video files
$(call inherit-product, frameworks/base/data/videos/VideoPackage2.mk)

# Exclude prebuilt paprefs from builds if the flag is set
ifneq ($(PREFS_FROM_SOURCE),true)
    PRODUCT_COPY_FILES += \
        vendor/orca/prebuilt/common/apk/ParanoidPreferences.apk:system/app/ParanoidPreferences.apk
else
    # Build paprefs from sources
    PRODUCT_PACKAGES += \
        ParanoidPreferences
endif

# ParanoidOTA
ifneq ($(NO_OTA_BUILD),true)
    PRODUCT_PACKAGES += \
        ParanoidOTA
endif

ifneq ($(ORCA_BOOTANIMATION_NAME),)
    PRODUCT_COPY_FILES += \
        vendor/orca/prebuilt/common/bootanimation/$(ORCA_BOOTANIMATION_NAME).zip:system/media/bootanimation.zip
else
    PRODUCT_COPY_FILES += \
        vendor/orca/prebuilt/common/bootanimation/XHDPI.zip:system/media/bootanimation.zip
endif

# Embed superuser into settings
SUPERUSER_EMBEDDED := true
SUPERUSER_PACKAGE_PREFIX := com.android.settings.cyanogenmod.superuser

# Enable root for adb+apps
PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.root_access=3

# Superuser
PRODUCT_PACKAGES += \
    Superuser \
    su

# device common prebuilts
ifneq ($(DEVICE_COMMON),)
    -include vendor/orca/prebuilt/$(DEVICE_COMMON)/prebuilt.mk
endif

# device specific prebuilts
-include vendor/orca/prebuilt/$(TARGET_PRODUCT)/prebuilt.mk

BOARD := $(subst orca_,,$(TARGET_PRODUCT))

# Orca Overlays
PRODUCT_PACKAGE_OVERLAYS += vendor/orca/overlay/common
PRODUCT_PACKAGE_OVERLAYS += vendor/orca/overlay/$(TARGET_PRODUCT)

# Allow device family to add overlays and use a same prop.conf
ifneq ($(OVERLAY_TARGET),)
    PRODUCT_PACKAGE_OVERLAYS += vendor/orca/overlay/$(OVERLAY_TARGET)
    PA_CONF_SOURCE := $(OVERLAY_TARGET)
else
    PA_CONF_SOURCE := $(TARGET_PRODUCT)
endif

PRODUCT_COPY_FILES += \
    vendor/orca/prebuilt/$(PA_CONF_SOURCE).conf:system/etc/paranoid/properties.conf \
    vendor/orca/prebuilt/$(PA_CONF_SOURCE).conf:system/etc/paranoid/backup.conf

ORCA_VERSION_MAJOR = 3
ORCA_VERSION_MINOR = 0
ORCA_VERSION_MAINTENANCE = 3
PA_PREF_REVISION = 1

TARGET_CUSTOM_RELEASETOOL := source vendor/orca/tools/squisher

VERSION := $(ORCA_VERSION_MAJOR).$(ORCA_VERSION_MINOR)$(ORCA_VERSION_MAINTENANCE)
ifeq ($(DEVELOPER_VERSION),true)
    ORCA_VERSION := dev_$(BOARD)-$(VERSION)-$(shell date -u +%Y%m%d)
else
    ORCA_VERSION := $(TARGET_PRODUCT)-$(VERSION)-$(shell date -u +%Y%m%d)
endif

PRODUCT_PROPERTY_OVERRIDES += \
    ro.modversion=$(ORCA_VERSION) \
    ro.pa.family=$(PA_CONF_SOURCE) \
    ro.orca.version=$(VERSION) \
    ro.papref.revision=$(PA_PREF_REVISION)

# goo.im properties
ifneq ($(DEVELOPER_VERSION),true)
    PRODUCT_PROPERTY_OVERRIDES += \
      ro.goo.developerid=drewgaren \
      ro.goo.rom=Orca_Nightlies \
      ro.goo.version=$(shell date +%s)
endif