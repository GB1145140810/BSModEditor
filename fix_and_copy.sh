#!/bin/bash

# 一键修复并复制到新文件夹
echo "=== 一键修复并复制到新文件夹 ==="
echo "开始时间: $(date)"

# 1. 应用优化配置
echo "1. 应用优化配置..."
if [ -f "app/build_optimized.gradle.kts" ]; then
    cp app/build_optimized.gradle.kts app/build.gradle.kts
    echo "✓ 已应用优化构建配置"
fi

if [ -f "gradle_optimized.properties" ]; then
    cp gradle_optimized.properties gradle.properties
    echo "✓ 已应用优化Gradle配置"
fi

# 2. 创建新文件夹并复制项目
echo "2. 复制项目到新文件夹..."
TARGET_DIR="/sdcard/ModEditor"
mkdir -p "$TARGET_DIR"

# 复制所有文件
cp -r . "$TARGET_DIR"/

# 复制隐藏文件
cp -r .github "$TARGET_DIR"/ 2>/dev/null || true
cp -r .gitignore "$TARGET_DIR"/ 2>/dev/null || true
cp -r .devcontainer "$TARGET_DIR"/ 2>/dev/null || true

# 3. 设置执行权限
echo "3. 设置执行权限..."
chmod +x "$TARGET_DIR/gradlew" 2>/dev/null || true
chmod +x "$TARGET_DIR"/*.sh 2>/dev/null || true

# 4. 创建必要目录和文件
echo "4. 创建必要目录和文件..."
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

# 5. 生成构建脚本
echo "5. 生成构建脚本..."
cat > "$TARGET_DIR/build.sh" << 'EOF'
#!/bin/bash

echo "=== ModEditor 构建脚本 ==="
echo "开始时间: $(date)"

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
    echo "3. 查看详细错误日志: ./gradlew assembleDebug --stacktrace"
fi

echo "=== 构建完成 ==="
echo "完成时间: $(date)"
EOF

chmod +x "$TARGET_DIR/build.sh"

# 6. 显示结果
echo ""
echo "=== 修复和复制完成 ==="
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