#!/bin/bash

echo "=== 简化构建脚本 ==="
echo "当前目录: $(pwd)"

# 检查Java环境
if ! command -v java &> /dev/null; then
    echo "错误: 未找到Java环境"
    exit 1
fi

echo "Java版本: $(java -version 2>&1 | head -n 1)"

# 检查Android SDK
if [ -z "$ANDROID_HOME" ]; then
    echo "警告: ANDROID_HOME未设置"
    if [ -d "/root/Android" ]; then
        export ANDROID_HOME="/root/Android"
    else
        echo "错误: 未找到Android SDK"
        exit 1
    fi
fi

echo "Android SDK: $ANDROID_HOME"

# 检查Android SDK组件
if [ -d "$ANDROID_HOME/platforms" ]; then
    echo "可用平台:"
    ls -la "$ANDROID_HOME/platforms"
else
    echo "警告: 未找到platforms目录"
fi

# 尝试使用系统Gradle
echo "尝试使用系统Gradle..."
if command -v gradle &> /dev/null; then
    echo "✓ 找到系统Gradle"
    
    # 创建简单的构建脚本
    echo "创建构建脚本..."
    cat > build_simple.gradle << 'EOF'
task assembleDebug {
    doLast {
        println "Debug build task executed"
    }
}
EOF
    
    # 运行构建
    echo "运行构建..."
    gradle assembleDebug
    
else
    echo "✗ 未找到Gradle命令"
    echo ""
    echo "建议解决方案:"
    echo "1. 使用GitHub Actions在线构建"
    echo "2. 安装Gradle到系统"
    echo "3. 手动下载Gradle Wrapper"
fi

echo "=== 构建脚本完成 ==="