# Prebuilt 文件

编译 TWRP 前，此目录需包含以下文件：

| 文件 | 说明 |
|------|------|
| `kernel` | 从 LineageOS 或官方 boot.img 提取的 GKI 内核 |
| `dtb.img` | 设备树 blob（可从 dtbo.img 获取） |

## 获取方式

### 方式一：从 boot.img 提取 kernel

```bash
# 从已 root 设备或 ROM 包中提取 boot.img 后
python3 - <<'EOF'
import struct
with open('boot.img', 'rb') as f:
    data = f.read()
kernel_size = struct.unpack_from('<I', data, 8)[0]
header_size = struct.unpack_from('<I', data, 20)[0]
page_size = 4096
kernel_offset = ((header_size + page_size - 1) // page_size) * page_size
with open('kernel', 'wb') as f:
    f.write(data[kernel_offset:kernel_offset + kernel_size])
print(f"Extracted {kernel_size} bytes")
EOF
```

### 方式二：GitHub Actions 自动下载

推送仓库后，在 Actions 中手动触发 `Build TWRP for Xiaomi Pad 7 (uke)` workflow，会自动下载 prebuilt 并编译。

### 方式三：LineageOS 构建产物

从 [LineageOS uke 构建](https://sourceforge.net/projects/irawansprojekt/files/uke/) 下载 `boot.img` 和 `dtbo.img`，分别提取 kernel 并将 dtbo.img 重命名为 dtb.img。
