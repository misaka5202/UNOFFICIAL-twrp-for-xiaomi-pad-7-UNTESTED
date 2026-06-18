# TWRP Device Tree - Xiaomi Pad 7 (uke)

## 设备规格

| 项目 | 规格 |
|------|------|
| 代号 | uke |
| 型号 | 2410CRP4CG |
| 芯片 | Snapdragon 7+ Gen 3 (SM7675, crow) |
| 架构 | ARM64 |
| 屏幕 | 3200 x 2136（横屏） |
| Android | 14 (SDK 34) |
| 分区 | Virtual A/B (VAB) |
| 加密 | FBE (aes-256-xts) |

---

## 编译说明

### 1. 安装编译依赖（Ubuntu 20.04/22.04）

```bash
sudo apt install git-core gnupg flex bison build-essential zip curl \
zlib1g-dev libc6-dev-i386 libncurses-dev lib32ncurses-dev \
x11proto-core-dev libx11-dev lib32z1-dev libgl1-mesa-dev \
libxml2-utils xsltproc unzip fontconfig python3
```

### 2. 初始化 TWRP 源码

```bash
mkdir twrp && cd twrp
repo init --depth=1 -u https://github.com/minimal-manifest-twrp/platform_manifest_twrp_aosp.git -b twrp-12.1
repo sync -j$(nproc) --no-clone-bundle --no-tags
```

### 3. 克隆设备树

```bash
git clone <your-repo-url> device/xiaomi/uke
```

### 4. 准备 prebuilt 文件

将 `kernel` 和 `dtb.img` 放入 `device/xiaomi/uke/prebuilt/`，详见 [prebuilt/README.md](prebuilt/README.md)。

### 5. 编译

```bash
. build/envsetup.sh
lunch twrp_uke-eng
mka vendorbootimage -j$(nproc)
```

### 6. 刷入

```bash
fastboot flash vendor_boot out/target/product/uke/vendor_boot.img
```

---

## 注意事项

- 本设备使用 Virtual A/B，recovery 嵌入在 `vendor_boot.img` 中，无独立 recovery 分区
- 完整 HyperOS fstab（含 mi_ext overlay、system_dlkm）已包含，适配小米系统分区布局
- FBE 解密已启用，完整解密可能需要厂商 crypto 库支持
- GitHub Actions 可自动下载 prebuilt 并编译，workflow 位于 `.github/workflows/build.yml`
