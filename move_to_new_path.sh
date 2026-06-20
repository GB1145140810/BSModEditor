#!/bin/bash

# 简化版移动脚本
echo "=== 移动项目到新路径 ==="

# 源目录
SOURCE_DIR="/storage/emulated/0/国服模组/模组json相关内容/ModEditor"

# 目标目录（避免中文路径）
TARGET_DIR="/sdcard/ModEditor"

echo "源目录: $SOURCE_DIR"
echo "目标目录: $TARGET_DIR"

# 1. 检查源目录
if [ ! -d "$SOURCE_DIR" ]; then
    echo "错误: 源目录不存在"
    exit 1
fi

# 2. 创建目标目录
echo "1. 创建目标目录..."
mkdir -p "$TARGET_DIR"

# 3. 复制项目文件
echo "2. 复制项目文件..."
cp -r "$SOURCE_DIR"/* "$TARGET_DIR"/

# 4. 复制隐藏文件
echo "3. 复制隐藏文件..."
cp -r "$SOURCE_DIR"/.github "$TARGET_DIR"/ 2>/dev/null || true
cp -r "$SOURCE_DIR"/.gitignore "$TARGET_DIR"/ 2>/dev/null || true
cp -r "$SOURCE_DIR"/.devcontainer "$TARGET_DIR"/ 2>/dev/null || true

# 5. 应用优化配置
echo "4. 应用优化配置..."
if [ -f "$TARGET_DIR/app/build_optimized.gradle.kts" ]; then
    cp "$TARGET_DIR/app/build_optimized.gradle.kts" "$TARGET_DIR/app/build.gradle.kts"
    echo "✓ 已应用优化构建配置"
fi

# 6. 设置执行权限
echo "5. 设置执行权限..."
chmod +x "$TARGET_DIR/gradlew" 2>/dev/null || true
chmod +x "$TARGET_DIR"/*.sh 2>/dev/null || true

# 7. 创建必要目录和文件
echo "6. 创建必要目录和文件..."
mkdir -p "$TARGET_DIR/app/src/main/res/values"
mkdir -p "$TARGET_DIR/app/src/main/res/drawable"
mkdir -p "$TARGET_DIR/app/src/main/res/mipmap-hdpi"

# 创建资源文件（如果不存在）
if [ ! -f "$TARGET_DIR/app/src/main/res/values/strings.xml" ]; then
    echo '<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">ModEditor</string>
</resources>' > "$TARGET_DIR/app/src/main/res/values/strings.xml"
fi

if [ ! -f "$TARGET_DIR/app/src/main/res/values/colors.xml" ]; then
    echo '<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="purple_200">#FFBB86FC</color>
    <color name="purple_500">#FF6200EE</color>
    <color name="purple_700">#FF3700B3</color>
    <color name="teal_200">#FF03DAC5</color>
    <color name="teal_700">#FF018786</color>
    <color name="black">#FF000000</color>
    <color name="white">#FFFFFFFF</color>
</resources>' > "$TARGET_DIR/app/src/main/res/values/colors.xml"
fi

if [ ! -f "$TARGET_DIR/app/src/main/res/values/themes.xml" ]; then
    echo '<?xml version="1.0" encoding="utf-8"?>
<resources>
    <style name="Theme.ModEditor" parent="Theme.Material3.DayNight.NoActionBar">
        <item name="colorPrimary">@color/purple_200</item>
        <item name="colorPrimaryVariant">@color/purple_700</item>
        <item name="colorOnPrimary">@color/white</item>
        <item name="colorSecondary">@color/teal_200</item>
        <item name="colorSecondaryVariant">@color/teal_700</item>
        <item name="colorOnSecondary">@color/black</item>
    </style>
</resources>' > "$TARGET_DIR/app/src/main/res/values/themes.xml"
fi

# 创建占位图标
echo "placeholder" > "$TARGET_DIR/app/src/main/res/mipmap-hdpi/ic_launcher.png"
echo "placeholder" > "$TARGET_DIR/app/src/main/res/mipmap-hdpi/ic_launcher_round.png"

# 8. 生成构建脚本
echo "7. 生成构建脚本..."
cat > "$TARGET_DIR/build.sh" << 'EOF'
#!/bin/bash

echo "=== ModEditor 构建脚本 ==="

# 检查Java环境
if ! command -v java &> /dev/null; then
    echo "错误: 未找到Java环境"
    echo "请安装JDK 8或更高版本"
    exit 1
fi

# 设置执行权限
chmod +x gradlew

# 清理项目
echo "清理项目..."
./gradlew clean

# 构建Debug版本
echo "构建Debug版本..."
if ./gradlew assembleDebug --no-daemon; then
    echo "✓ Debug APK构建成功"
    APK_FILE="app/build/outputs/apk/debug/app-debug.apk"
    if [ -f "$APK_FILE" ]; then
        APK_SIZE=$(du -h "$APK_FILE" | cut -f1)
        echo "APK位置: $APK_FILE"
        echo "APK大小: $APK_SIZE"
    fi
else
    echo "✗ Debug APK构建失败"
    echo ""
    echo "建议解决方案:"
    echo "1. 检查Android SDK配置"
    echo "2. 使用GitHub Actions在线构建"
    echo "3. 查看详细错误日志"
fi

echo "=== 构建完成 ==="
EOF

chmod +x "$TARGET_DIR/build.sh"

# 9. 显示结果
echo ""
echo "=== 移动完成 ==="
echo "项目位置: $TARGET_DIR"
echo ""
echo "目录结构:"
ls -la "$TARGET_DIR"
echo ""
echo "下一步操作:"
echo "1. 进入项目目录: cd $TARGET_DIR"
echo "2. 运行构建: ./build.sh"
echo "3. 或者使用Android Studio打开: $TARGET_DIR"
echo ""
echo "如果构建失败，请尝试:"
echo "1. 检查Android SDK配置"
echo "2. 使用GitHub Actions在线构建"
echo "3. 查看错误日志: ./gradlew assembleDebug --stacktrace"

echo "=== 完成 ==="