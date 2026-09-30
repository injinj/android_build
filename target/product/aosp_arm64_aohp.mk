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

# AOHP harness (see device/google/cuttlefish/vsoc_x86_64/phone/aosp_cf_aohp.mk for the Cuttlefish variant)
PRODUCT_PACKAGES += \
    AOHPAgentDriver \
    privapp-permissions-aohp \
    aohp-containerd \
    aohp-rootfs-debian \
    aohp_cgroup_conf

PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/etc/permissions/privapp-permissions-aohp.xml \
    system/priv-app/AOHPAgentDriver/AOHPAgentDriver.apk \
    system/bin/aohp-containerd \
    system/etc/init/aohp-containerd.rc \
    system/etc/aohp/rootfs-templates/debian.tar.gz \
    system/etc/aohp/cgroup.conf

# GSI has no vendor image of ours: carry the AOHP property on the system partition.
PRODUCT_SYSTEM_PROPERTIES += ro.aohp.virtual_display_policy=true

PRODUCT_COPY_FILES += \
    device/google/cuttlefish/vsoc_x86_64/phone/aohp_overlay_config.xml:$(TARGET_COPY_OUT_PRODUCT)/overlay/config/config.xml
