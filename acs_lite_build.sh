#!/bin/bash

# ACS Lite 专用构建脚本
# 这个脚本会尝试使用最简单的配置进行构建

echo "=== ACS Lite 构建脚本 ==="
echo "开始时间: $(date)"

# 检查当前目录
echo "当前目录: $(pwd)"

# 检查必要文件
echo "1. 检查项目文件..."
if [ ! -f "app/build.gradle.kts" ]; then
    echo "错误: 未找到 app/build.gradle.kts"
    echo "请确保在正确的项目目录中运行此脚本"
    exit 1
fi

# 备份原始构建文件
echo "2. 备份原始构建文件..."
if [ -f "app/build.gradle.kts" ]; then
    cp app/build.gradle.kts app/build.gradle.kts.backup
    echo "已备份: app/build.gradle.kts.backup"
fi

# 使用简化构建文件
echo "3. 使用简化构建文件..."
if [ -f "app/build_simple.gradle.kts" ]; then
    cp app/build_simple.gradle.kts app/build.gradle.kts
    echo "已使用简化构建文件"
else
    echo "警告: 未找到简化构建文件，使用原始文件"
fi

# 设置执行权限
echo "4. 设置执行权限..."
chmod +x gradlew 2>/dev/null || true

# 检查 Gradle Wrapper
echo "5. 检查 Gradle Wrapper..."
if [ ! -f "gradlew" ]; then
    echo "警告: 未找到 gradlew，尝试创建..."
    if command -v gradle &> /dev/null; then
        gradle wrapper --gradle-version 7.5
        chmod +x gradlew
    else
        echo "错误: 未找到 gradle 命令"
        echo "请安装 Gradle 或使用 Android Studio"
        exit 1
    fi
fi

# 尝试构建
echo "6. 尝试构建项目..."
echo "这可能需要几分钟时间..."

# 首先尝试清理
echo "清理项目..."
./gradlew clean 2>/dev/null || echo "清理失败，继续构建..."

# 尝试构建 Debug 版本
echo "构建 Debug 版本..."
if ./gradlew assembleDebug --no-daemon --stacktrace; then
    echo "✓ Debug APK 构建成功"
    
    # 查找生成的 APK
    APK_PATH=$(find . -name "*.apk" -type f | grep debug | head -1)
    if [ -n "$APK_PATH" ]; then
        echo "APK 位置: $APK_PATH"
        APK_SIZE=$(du -h "$APK_PATH" | cut -f1)
        echo "APK 大小: $APK_SIZE"
    fi
else
    echo "✗ Debug APK 构建失败"
    echo ""
    echo "常见问题解决:"
    echo "1. 检查 Android SDK 配置"
    echo "2. 确保网络连接正常"
    echo "3. 查看详细错误信息"
    echo ""
    echo "尝试使用 GitHub Actions 在线构建:"
    echo "1. 将代码推送到 GitHub"
    echo "2. 启用 GitHub Actions"
    echo "3. 等待自动构建完成"
fi

# 恢复原始构建文件
echo "7. 恢复原始构建文件..."
if [ -f "app/build.gradle.kts.backup" ]; then
    mv app/build.gradle.kts.backup app/build.gradle.kts
    echo "已恢复原始构建文件"
fi

echo "=== 构建完成 ==="
echo "完成时间: $(date)"