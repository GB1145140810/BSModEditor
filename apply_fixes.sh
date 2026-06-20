#!/bin/bash

echo "=== 应用优化配置 ==="

# 1. 应用优化后的构建配置
echo "1. 应用优化后的构建配置..."
cp app/build_fixed.gradle.kts app/build.gradle.kts
echo "✓ 已应用优化构建配置"

# 2. 应用优化后的Gradle配置
echo "2. 应用优化后的Gradle配置..."
cp gradle_fixed.properties gradle.properties
echo "✓ 已应用优化Gradle配置"

# 3. 检查并创建gradlew
echo "3. 检查gradlew文件..."
if [ ! -f "gradlew" ]; then
    echo "创建Gradle Wrapper..."
    # 尝试使用gradle命令创建wrapper
    if command -v gradle &> /dev/null; then
        gradle wrapper --gradle-version 7.5
        chmod +x gradlew
        echo "✓ 已创建Gradle Wrapper"
    else
        echo "⚠️ 未找到gradle命令，请手动创建gradlew文件"
    fi
else
    echo "✓ gradlew文件已存在"
    chmod +x gradlew
fi

# 4. 清理项目
echo "4. 清理项目..."
./gradlew clean 2>/dev/null || echo "清理完成"

# 5. 检查Android SDK
echo "5. 检查Android SDK..."
if [ -z "$ANDROID_HOME" ]; then
    echo "⚠️ ANDROID_HOME未设置"
    echo "请设置Android SDK路径"
else
    echo "✓ Android SDK路径: $ANDROID_HOME"
fi

# 6. 尝试构建
echo "6. 尝试构建..."
if ./gradlew assembleDebug --no-daemon; then
    echo "✓ 构建成功！"
    echo "APK位置: app/build/outputs/apk/debug/app-debug.apk"
else
    echo "✗ 构建失败"
    echo ""
    echo "建议解决方案:"
    echo "1. 检查Android SDK配置"
    echo "2. 使用GitHub Actions在线构建"
    echo "3. 查看详细错误日志: ./gradlew assembleDebug --stacktrace"
fi

echo "=== 配置应用完成 ==="