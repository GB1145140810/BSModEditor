#!/bin/bash

# 修复AndroidX错误的脚本
echo "=== 修复AndroidX错误 ==="
echo "开始时间: $(date)"

# 1. 应用修复后的构建配置
echo "1. 应用修复后的构建配置..."
if [ -f "app/build_fixed.gradle.kts" ]; then
    cp app/build_fixed.gradle.kts app/build.gradle.kts
    echo "✓ 已应用修复后的构建配置"
else
    echo "✗ 未找到修复后的构建配置文件"
    exit 1
fi

# 2. 应用修复后的Gradle配置
echo "2. 应用修复后的Gradle配置..."
if [ -f "gradle_fixed.properties" ]; then
    cp gradle_fixed.properties gradle.properties
    echo "✓ 已应用修复后的Gradle配置"
else
    echo "✗ 未找到修复后的Gradle配置文件"
    exit 1
fi

# 3. 创建必要的目录和文件
echo "3. 创建必要的目录和文件..."
mkdir -p app/src/main/res/values
mkdir -p app/src/main/res/drawable
mkdir -p app/src/main/res/mipmap-hdpi

# 创建资源文件（如果不存在）
if [ ! -f "app/src/main/res/values/strings.xml" ]; then
    echo '<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">ModEditor</string>
</resources>' > "app/src/main/res/values/strings.xml"
    echo "✓ 已创建 strings.xml"
fi

if [ ! -f "app/src/main/res/values/colors.xml" ]; then
    echo '<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="purple_200">#FFBB86FC</color>
    <color name="purple_500">#FF6200EE</color>
    <color name="purple_700">#FF3700B3</color>
    <color name="teal_200">#FF03DAC5</color>
    <color name="teal_700">#FF018786</color>
    <color name="black">#FF000000</color>
    <color name="white">#FFFFFFFF</color>
</resources>' > "app/src/main/res/values/colors.xml"
    echo "✓ 已创建 colors.xml"
fi

if [ ! -f "app/src/main/res/values/themes.xml" ]; then
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
</resources>' > "app/src/main/res/values/themes.xml"
    echo "✓ 已创建 themes.xml"
fi

# 创建占位图标
echo "placeholder" > "app/src/main/res/mipmap-hdpi/ic_launcher.png"
echo "placeholder" > "app/src/main/res/mipmap-hdpi/ic_launcher_round.png"

# 4. 清理项目
echo "4. 清理项目..."
./gradlew clean 2>/dev/null || echo "清理完成"

# 5. 设置执行权限
echo "5. 设置执行权限..."
chmod +x gradlew 2>/dev/null || true

# 6. 尝试构建
echo "6. 尝试构建..."
echo "正在构建Debug版本..."
if ./gradlew assembleDebug --no-daemon --stacktrace; then
    echo "✓ 构建成功！"
    echo "APK位置: app/build/outputs/apk/debug/app-debug.apk"
    
    # 显示APK大小
    APK_FILE="app/build/outputs/apk/debug/app-debug.apk"
    if [ -f "$APK_FILE" ]; then
        APK_SIZE=$(du -h "$APK_FILE" | cut -f1)
        echo "APK大小: $APK_SIZE"
    fi
else
    echo "✗ 构建失败"
    echo ""
    echo "建议解决方案:"
    echo "1. 检查Android SDK配置"
    echo "2. 使用GitHub Actions在线构建"
    echo "3. 查看详细错误日志"
    echo ""
    echo "尝试查看详细错误:"
    echo "./gradlew assembleDebug --info"
fi

echo "=== 修复完成 ==="
echo "完成时间: $(date)"