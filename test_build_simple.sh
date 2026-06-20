#!/bin/bash

echo "=== 简单构建测试 ==="

# 检查Java环境
echo "1. 检查Java环境..."
if ! command -v java &> /dev/null; then
    echo "错误: 未找到Java环境"
    exit 1
fi

java -version
echo "✓ Java环境正常"

# 检查Gradle wrapper
echo "2. 检查Gradle wrapper..."
if [ ! -f "gradlew" ]; then
    echo "错误: 未找到gradlew文件"
    exit 1
fi

chmod +x gradlew
echo "✓ Gradle wrapper已就绪"

# 尝试构建
echo "3. 尝试构建..."
if ./gradlew assembleDebug --no-daemon --stacktrace; then
    echo "✓ 构建成功！"
    echo "APK位置: app/build/outputs/apk/debug/app-debug.apk"
else
    echo "✗ 构建失败"
    echo ""
    echo "可能的解决方案:"
    echo "1. 检查Android SDK配置"
    echo "2. 使用GitHub Actions在线构建"
    echo "3. 查看详细错误日志"
fi

echo "=== 测试完成 ==="