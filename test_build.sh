#!/bin/bash

# 测试构建脚本
# 这个脚本会模拟GitHub Actions的构建过程

echo "=== 测试构建脚本 ==="
echo "开始时间: $(date)"

# 检查Java环境
if ! command -v java &> /dev/null; then
    echo "错误: 未找到Java环境"
    echo "请安装JDK 11或更高版本"
    exit 1
fi

# 检查Gradle wrapper
if [ ! -f "gradlew" ]; then
    echo "错误: 未找到gradlew文件"
    exit 1
fi

# 设置执行权限
chmod +x gradlew

echo "1. 检查项目结构..."
if [ ! -f "app/build.gradle.kts" ]; then
    echo "错误: 未找到app/build.gradle.kts"
    exit 1
fi

echo "2. 清理项目..."
./gradlew clean

echo "3. 构建Debug版本..."
if ./gradlew assembleDebug; then
    echo "✓ Debug APK构建成功"
    echo "APK位置: app/build/outputs/apk/debug/app-debug.apk"
else
    echo "✗ Debug APK构建失败"
    exit 1
fi

echo "4. 运行测试..."
if ./gradlew test; then
    echo "✓ 测试通过"
else
    echo "⚠ 测试失败，但继续构建"
fi

echo "5. 构建Release版本..."
if ./gradlew assembleRelease; then
    echo "✓ Release APK构建成功"
    echo "APK位置: app/build/outputs/apk/release/app-release-unsigned.apk"
else
    echo "⚠ Release APK构建失败"
fi

echo "=== 构建完成 ==="
echo "完成时间: $(date)"

# 列出生成的APK文件
echo "生成的APK文件:"
find . -name "*.apk" -type f | while read file; do
    echo "  - $file"
done