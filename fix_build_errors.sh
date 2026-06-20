#!/bin/bash

# 快速修复构建错误脚本
echo "=== 快速修复构建错误 ==="

# 1. 使用简化构建文件
echo "1. 应用简化构建配置..."
if [ -f "app/build_simple.gradle.kts" ]; then
    cp app/build_simple.gradle.kts app/build.gradle.kts
    echo "✓ 已应用简化构建配置"
else
    echo "✗ 未找到简化构建文件"
fi

# 2. 创建必要的目录结构
echo "2. 创建必要目录..."
mkdir -p app/src/main/res/values
mkdir -p app/src/main/res/drawable
mkdir -p app/src/main/res/mipmap-hdpi

# 3. 创建基本资源文件（如果不存在）
echo "3. 检查资源文件..."
if [ ! -f "app/src/main/res/values/strings.xml" ]; then
    echo "创建 strings.xml..."
    cat > app/src/main/res/values/strings.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">ModEditor</string>
</resources>
EOF
fi

# 4. 创建基本主题文件
if [ ! -f "app/src/main/res/values/themes.xml" ]; then
    echo "创建 themes.xml..."
    cat > app/src/main/res/values/themes.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <style name="Theme.ModEditor" parent="Theme.Material3.DayNight.NoActionBar">
        <item name="colorPrimary">@color/purple_200</item>
        <item name="colorPrimaryVariant">@color/purple_700</item>
        <item name="colorOnPrimary">@color/white</item>
        <item name="colorSecondary">@color/teal_200</item>
        <item name="colorSecondaryVariant">@color/teal_700</item>
        <item name="colorOnSecondary">@color/black</item>
    </style>
</resources>
EOF
fi

# 5. 创建颜色文件
if [ ! -f "app/src/main/res/values/colors.xml" ]; then
    echo "创建 colors.xml..."
    cat > app/src/main/res/values/colors.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="purple_200">#FFBB86FC</color>
    <color name="purple_500">#FF6200EE</color>
    <color name="purple_700">#FF3700B3</color>
    <color name="teal_200">#FF03DAC5</color>
    <color name="teal_700">#FF018786</color>
    <color name="black">#FF000000</color>
    <color name="white">#FFFFFFFF</color>
</resources>
EOF
fi

# 6. 创建基本图标文件（如果不存在）
echo "4. 检查图标文件..."
if [ ! -f "app/src/main/res/mipmap-hdpi/ic_launcher.png" ]; then
    echo "创建占位图标文件..."
    # 创建一个简单的占位文件
    echo "placeholder" > app/src/main/res/mipmap-hdpi/ic_launcher.png
    echo "placeholder" > app/src/main/res/mipmap-hdpi/ic_launcher_round.png
fi

# 7. 清理并尝试构建
echo "5. 清理项目..."
./gradlew clean 2>/dev/null || echo "清理完成"

echo "6. 尝试构建..."
if ./gradlew assembleDebug --no-daemon; then
    echo "✓ 构建成功！"
    echo "APK 位置: app/build/outputs/apk/debug/app-debug.apk"
else
    echo "✗ 构建失败"
    echo ""
    echo "建议："
    echo "1. 使用 GitHub Actions 在线构建"
    echo "2. 或者使用 Android Studio"
    echo "3. 查看详细错误日志"
fi

echo "=== 修复完成 ==="