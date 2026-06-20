#!/bin/bash

# ModEditor 编译脚本
# 使用方法: ./build.sh [debug|release|test]

set -e

echo "=== ModEditor 编译脚本 ==="
echo "开始时间: $(date)"

# 检查Java环境
if ! command -v java &> /dev/null; then
    echo "错误: 未找到Java环境"
    echo "请安装JDK 11或更高版本"
    exit 1
fi

# 检查Java版本
java_version=$(java -version 2>&1 | head -n 1 | cut -d'"' -f2 | cut -d'.' -f1)
if [ "$java_version" -lt 11 ]; then
    echo "错误: Java版本过低，需要JDK 11+"
    echo "当前版本: $java_version"
    exit 1
fi

echo "Java版本: $(java -version 2>&1 | head -n 1)"

# 设置执行权限
chmod +x gradlew 2>/dev/null || true

# 解析参数
BUILD_TYPE=${1:-debug}

case $BUILD_TYPE in
    "debug")
        echo "构建Debug版本..."
        ./gradlew assembleDebug
        echo "Debug APK构建完成: app/build/outputs/apk/debug/app-debug.apk"
        ;;
    "release")
        echo "构建Release版本..."
        ./gradlew assembleRelease
        echo "Release APK构建完成: app/build/outputs/apk/release/app-release-unsigned.apk"
        ;;
    "test")
        echo "运行测试..."
        ./gradlew test
        echo "测试完成"
        ;;
    "clean")
        echo "清理构建..."
        ./gradlew clean
        echo "清理完成"
        ;;
    *)
        echo "用法: $0 [debug|release|test|clean]"
        echo "  debug   - 构建Debug版本"
        echo "  release - 构建Release版本"
        echo "  test    - 运行测试"
        echo "  clean   - 清理构建"
        exit 1
        ;;
esac

echo "完成时间: $(date)"
echo "=== 编译完成 ==="