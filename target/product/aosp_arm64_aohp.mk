#
# aosp_arm64_aohp: AOSP arm64 GSI + AOHP (Android Open Harness Project) agent harness.
# Flash over a Treble device's stock vendor (tested target: Pixel 6 "oriole").
#
$(call inherit-product, $(SRC_TARGET_DIR)/product/aosp_arm64.mk)

# aosp_arm64.mk guards these behind ifeq (aosp_arm64,$(TARGET_PRODUCT)); replicate for our product name.
PRODUCT_ENFORCE_ARTIFACT_PATH_REQUIREMENTS := relaxed
MODULE_BUILD_FROM_SOURCE ?= true
$(call inherit-product, $(SRC_TARGET_DIR)/product/gsi_release.mk)
PRODUCT_SOONG_DEFINED_SYSTEM_IMAGE := aosp_arm64_aohp_system_image
USE_SOONG_DEFINED_SYSTEM_IMAGE := true

PRODUCT_NAME := aosp_arm64_aohp
PRODUCT_MODEL := AOHP on ARM64

# AOHP harness (see device/google/cuttlefish/vsoc_x86_64/phone/aosp_cf_aohp.mk for the Cuttlefish variant).
# This product ships the AOHP Driver (org.aohp.driver: runtime/harness/terminal/web UI + the
# agent bridge on 127.0.0.1:6666) instead of the stock AOHPAgentDriver demo app, plus the
# OpenClaw Android app (ai.openclaw.app, presigned with its own key, plain system app).
# AOHPDriver is platform-signed but not privileged: its permissions are all signature-level,
# so no privapp-permissions allowlist is needed (privapp-permissions-aohp.xml is for the stock app).
PRODUCT_PACKAGES += \
    AOHPDriver \
    OpenClawAndroid \
    aohp-containerd \
    aohp-rootfs-debian \
    aohp_cgroup_conf

PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/app/AOHPDriver/AOHPDriver.apk \
    system/app/AOHPDriver/oat/% \
    system/app/OpenClawAndroid/OpenClawAndroid.apk \
    system/app/OpenClawAndroid/oat/% \
    system/app/OpenClawAndroid/lib/% \
    system/bin/aohp-containerd \
    system/etc/init/aohp-containerd.rc \
    system/etc/aohp/rootfs-templates/debian.tar.gz \
    system/etc/aohp/cgroup.conf

# GSI has no vendor image of ours and generic_system.mk forbids system props: use the product partition (folded into system.img on GSI).
PRODUCT_PRODUCT_PROPERTIES += ro.aohp.virtual_display_policy=true


# Note: the Cuttlefish product also ships a product overlay config forcing gestural navigation
# (aohp_overlay_config.xml). Not carried here: Soong-defined GSI images reject Kati-only files and
# prebuilt_* modules cannot target product/overlay/config. Pick navigation style in Settings.
