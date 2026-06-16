DEVICE_PATH := device/xiaomi/uke

# Architecture
TARGET_SUPPORTS_64_BIT_APPS := true
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := generic
# crow (Snapdragon 7+ Gen3) 的大核是 Cortex-A720
# 如需精确确认: adb shell getprop ro.bionic.cpu_variant
TARGET_CPU_VARIANT_RUNTIME := cortex-a720

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := generic
TARGET_2ND_CPU_VARIANT_RUNTIME := cortex-a720

# Bootloader
TARGET_BOOTLOADER_BOARD_NAME := uke
TARGET_NO_BOOTLOADER := true

# Platform
# Snapdragon 7+ Gen3 (SM7675) 内核平台代号为 crow
TARGET_BOARD_PLATFORM := crow
QCOM_BOARD_PLATFORMS += crow

# Kernel
# 从 vendor_boot.img 解包确认：HEADER_VER=4，PAGESIZE=4096
# GKI 高通设备 base 和所有 offset 均为 0（cmdline 带 bootconfig 关键字印证）
BOARD_BOOT_HEADER_VERSION := 4
BOARD_KERNEL_BASE := 0x00000000
BOARD_KERNEL_PAGESIZE := 4096
BOARD_RAMDISK_OFFSET := 0x00000000
BOARD_KERNEL_TAGS_OFFSET := 0x00000000
BOARD_KERNEL_OFFSET := 0x00008000

BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOT_HEADER_VERSION)
BOARD_MKBOOTIMG_ARGS += --ramdisk_offset $(BOARD_RAMDISK_OFFSET)
BOARD_MKBOOTIMG_ARGS += --tags_offset $(BOARD_KERNEL_TAGS_OFFSET)
BOARD_MKBOOTIMG_ARGS += --dtb $(DEVICE_PATH)/prebuilt/dtb.img

TARGET_KERNEL_ARCH := arm64
BOARD_KERNEL_IMAGE_NAME := Image
# 使用预编译内核，不重新编译内核源码
TARGET_NO_KERNEL_OVERRIDE := true

# Android Verified Boot
# --flags 3 禁用 AVB 校验，TWRP 不需要 recovery key
BOARD_AVB_ENABLE := true
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flags 3

# Partitions
# 从 vendor_boot.img 解包：PAGESIZE=4096，block size = pagesize * 64
BOARD_FLASH_BLOCK_SIZE := 262144
BOARD_BOOTIMAGE_PARTITION_SIZE := 201326592
# init_boot 是独立分区（解包确认 init_boot.img RAMDISK_SZ=2309000）
BOARD_INIT_BOOT_IMAGE_PARTITION_SIZE := 8388608
BOARD_VENDOR_BOOTIMAGE_PARTITION_SIZE := 100663296

# Dynamic Partitions (Virtual A/B)
BOARD_SUPER_PARTITION_SIZE := 9663676416
BOARD_SUPER_PARTITION_GROUPS := xiaomi_dynamic_partitions
# 分区列表根据 fstab.qcom 中 logical 标记的分区确认，含 mi_ext 和 system_dlkm
BOARD_XIAOMI_DYNAMIC_PARTITIONS_PARTITION_LIST := \
    system \
    system_ext \
    system_dlkm \
    product \
    mi_ext \
    vendor \
    vendor_dlkm \
    odm
# BOARD_SUPER_PARTITION_SIZE - 4MB 预留
BOARD_XIAOMI_DYNAMIC_PARTITIONS_SIZE := 9659482112

# 文件系统类型（从 fstab.qcom 确认，动态分区均为 erofs）
BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_SYSTEM_EXTIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_SYSTEM_DLKMIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_PRODUCTIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_MI_EXTIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_VENDOR_DLKMIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_ODMIMAGE_FILE_SYSTEM_TYPE := erofs

TARGET_COPY_OUT_SYSTEM := system
TARGET_COPY_OUT_SYSTEM_EXT := system_ext
TARGET_COPY_OUT_SYSTEM_DLKM := system_dlkm
TARGET_COPY_OUT_PRODUCT := product
TARGET_COPY_OUT_MI_EXT := mi_ext
TARGET_COPY_OUT_VENDOR := vendor
TARGET_COPY_OUT_VENDOR_DLKM := vendor_dlkm
TARGET_COPY_OUT_ODM := odm

# File System
BOARD_HAS_LARGE_FILESYSTEM := true
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true

# Recovery
TARGET_RECOVERY_PIXEL_FORMAT := RGBA_8888
TARGET_RECOVERY_QCOM_RTC_FIX := true
TARGET_USES_MKE2FS := true
TARGET_RECOVERY_FSTAB := device/xiaomi/uke/recovery/root/system/etc/recovery.fstab
# Virtual A/B
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

# Recovery ramdisk 位于 vendor_boot（vendor_boot.img 解包确认 RAMDISK_SZ=34052356）
# boot.img 的 RAMDISK_SZ=0 也印证了这一点
BOARD_MOVE_RECOVERY_RESOURCES_TO_VENDOR_BOOT := true

# Metadata 分区（A/B + 动态分区必须）
BOARD_USES_METADATA_PARTITION := true

# Kernel modules
# vendor_ramdisk 目录结构确认：模块全部在 lib/modules/ 下
# modules.load.recovery 定义了 recovery 阶段需要加载的模块子集
TW_LOAD_VENDOR_MODULES := "modules.load.recovery"

# Crypto
# 将安全补丁日期设为未来值，绕过 FBE 解密时的版本校验
# fstab.qcom 确认 userdata 使用 f2fs + inlinecrypt + wrappedkey_v0
PLATFORM_VERSION := 99.87.36
PLATFORM_VERSION_LAST_STABLE := $(PLATFORM_VERSION)
PLATFORM_SECURITY_PATCH := 2099-12-31
VENDOR_SECURITY_PATCH := $(PLATFORM_SECURITY_PATCH)
BOOT_SECURITY_PATCH := $(PLATFORM_SECURITY_PATCH)

TW_INCLUDE_CRYPTO := true
TW_INCLUDE_CRYPTO_FBE := true
TW_INCLUDE_FBE_METADATA_DECRYPT := true
BOARD_USES_QCOM_FBE_DECRYPTION := true

# TWRP Config
TW_THEME := portrait_hdpi
RECOVERY_SDCARD_ON_DATA := true
TW_EXCLUDE_DEFAULT_USB_INIT := true
TW_EXTRA_LANGUAGES := true
TW_DEFAULT_LANGUAGE := zh_CN
TW_INCLUDE_NTFS_3G := true
TW_USE_TOOLBOX := true
TW_BRIGHTNESS_PATH := "/sys/class/backlight/panel0-backlight/brightness"
TW_MAX_BRIGHTNESS := 2047
TW_DEFAULT_BRIGHTNESS := 900
TW_Y_OFFSET := 0
TW_H_OFFSET := 0
TW_FRAMERATE := 60
TW_NO_SCREEN_BLANK := true
TW_EXCLUDE_APEX := true
TW_INCLUDE_RESETPROP := true
TW_INCLUDE_LIBRESETPROP := true
TW_EXCLUDE_TWRPAPP := true
# fstab.qcom 中存在 /recovery 分区条目，说明有独立 recovery 分区，不设此项
# TW_HAS_NO_RECOVERY_PARTITION := true  ← 已删除
TW_INCLUDE_FASTBOOTD := true
TW_INCLUDE_PYTHON := false
TW_SCREEN_BLANK_ON_BOOT := false

# Screen
TW_THEME := portrait_hdpi

# Debug
TARGET_USES_LOGD := true
TWRP_INCLUDE_LOGCAT := true
