# Release name
PRODUCT_RELEASE_NAME := Xiaomi Pad 7

# Inherit from AOSP base
$(call inherit-product, $(SRC_TARGET_DIR)/product/base.mk)

# 声明该设备只运行 64 位应用
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)

# Virtual A/B：recovery ramdisk 加载到 vendor_boot
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/launch_with_vendor_ramdisk.mk)

# Inherit TWRP common config
$(call inherit-product, vendor/twrp/config/common.mk)

# Inherit device configuration
$(call inherit-product, device/xiaomi/uke/device.mk)

## Device identifier
PRODUCT_DEVICE := uke
PRODUCT_NAME := twrp_uke
PRODUCT_BRAND := Xiaomi
PRODUCT_MODEL := 2410CRP4CG
PRODUCT_MANUFACTURER := Xiaomi
