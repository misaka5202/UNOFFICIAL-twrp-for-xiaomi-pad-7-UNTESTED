LOCAL_PATH := device/xiaomi/uke

# A/B
AB_OTA_UPDATER := true
AB_OTA_PARTITIONS += \
    boot \
    init_boot \
    dtbo \
    vendor_boot \
    system \
    system_ext \
    system_dlkm \
    product \
    mi_ext \
    vendor \
    vendor_dlkm \
    odm

# Dynamic partitions
PRODUCT_USE_DYNAMIC_PARTITIONS := true

# Boot control HAL（高通 A/B 切槽必须，recovery 后缀版本供 TWRP 使用）
PRODUCT_PACKAGES += \
    android.hardware.boot@1.2-impl-qti \
    android.hardware.boot@1.2-impl-qti.recovery \
    android.hardware.boot@1.2-service

# Update engine（sideload 刷 OTA 包必须）
PRODUCT_PACKAGES += \
    update_engine \
    update_engine_sideload \
    update_verifier

# Fastbootd（刷写 logical 分区必须）
PRODUCT_PACKAGES += \
    android.hardware.fastboot@1.1-impl-mock \
    fastbootd

# 强制包含 log 组件
PRODUCT_PACKAGES += \
    logd \
    logcat

# Recovery fstab
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/recovery/root/system/etc/recovery.fstab:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.qcom \
    $(LOCAL_PATH)/recovery/root/system/etc/recovery.fstab:$(TARGET_COPY_OUT_RECOVERY)/root/system/etc/recovery.fstab

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += $(LOCAL_PATH)
