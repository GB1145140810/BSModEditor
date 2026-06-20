#!/bin/bash

echo "=== 工作区构建脚本 ==="
echo "当前目录: $(pwd)"

# 1. 检查Java环境
echo "1. 检查Java环境..."
if ! command -v java &> /dev/null; then
    echo "错误: 未找到Java环境"
    echo "尝试查找Java..."
    find /usr -name "java" -type f 2>/dev/null | head -5
    find /usr -name "javac" -type f 2>/dev/null | head -5
    exit 1
fi

echo "Java版本:"
java -version

# 2. 检查项目文件
echo "2. 检查项目文件..."
if [ ! -f "app/build.gradle.kts" ]; then
    echo "错误: 未找到app/build.gradle.kts"
    exit 1
fi

if [ ! -f "gradle.properties" ]; then
    echo "错误: 未找到gradle.properties"
    exit 1
fi

echo "✓ 项目文件检查通过"

# 3. 检查Android SDK
echo "3. 检查Android SDK..."
if [ -z "$ANDROID_HOME" ]; then
    echo "警告: ANDROID_HOME未设置"
    echo "尝试查找Android SDK..."
    
    # 尝试常见路径
    if [ -d "/root/Android" ]; then
        export ANDROID_HOME="/root/Android"
        echo "✓ 找到Android SDK: $ANDROID_HOME"
    elif [ -d "/opt/android-sdk" ]; then
        export ANDROID_HOME="/opt/android-sdk"
        echo "✓ 找到Android SDK: $ANDROID_HOME"
    elif [ -d "/usr/local/android-sdk" ]; then
        export ANDROID_HOME="/usr/local/android-sdk"
        echo "✓ 找到Android SDK: $ANDROID_HOME"
    else
        echo "✗ 未找到Android SDK"
        echo "请设置ANDROID_HOME环境变量"
        exit 1
    fi
else
    echo "✓ Android SDK路径: $ANDROID_HOME"
fi

# 4. 检查Android SDK组件
echo "4. 检查Android SDK组件..."
if [ -d "$ANDROID_HOME/platforms" ]; then
    echo "可用平台:"
    ls -la "$ANDROID_HOME/platforms"
else
    echo "警告: 未找到platforms目录"
fi

# 5. 尝试使用Gradle Wrapper
echo "5. 尝试使用Gradle Wrapper..."
if [ -f "gradlew" ]; then
    chmod +x gradlew
    echo "✓ Gradle Wrapper已就绪"
    
    # 尝试构建
    echo "6. 尝试构建..."
    if ./gradlew assembleDebug --no-daemon --stacktrace; then
        echo "✓ 构建成功！"
        echo "APK位置: app/build/outputs/apk/debug/app-debug.apk"
        if [ -f "app/build/outputs/apk/debug/app-debug.apk" ]; then
            APK_SIZE=$(du -h "app/build/outputs/apk/debug/app-debug.apk" | cut -f1)
            echo "APK大小: $APK_SIZE"
        fi
    else
        echo "✗ 构建失败"
        echo ""
        echo "建议解决方案:"
        echo "1. 使用GitHub Actions在线构建"
        echo "2. 检查Android SDK配置"
        echo "3. 查看详细错误日志"
    fi
else
    echo "✗ 未找到Gradle Wrapper"
    echo "尝试使用系统Gradle..."
    
    if command -v gradle &> /dev/null; then
        echo "✓ 找到系统Gradle"
        gradle assembleDebug
    else
        echo "✗ 未找到Gradle命令"
        exit 1
    fi
fi

echo "=== 构建脚本完成 ==="