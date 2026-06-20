#!/bin/bash

# GitHub 上传和自动构建脚本
echo "=== GitHub 上传脚本 ==="
echo "当前目录: $(pwd)"

# 配置信息
REPO_NAME="ModEditor"
GITHUB_USERNAME="YOUR_USERNAME"  # 请替换为您的 GitHub 用户名

echo "GitHub 用户名: $GITHUB_USERNAME"
echo "仓库名: $REPO_NAME"

# 1. 检查 Git 配置
echo "1. 检查 Git 配置..."
if ! command -v git &> /dev/null; then
    echo "错误: 未找到 Git 命令"
    echo "请安装 Git: https://git-scm.com/downloads"
    exit 1
fi

echo "Git 版本: $(git --version)"

# 2. 初始化 Git 仓库
echo "2. 初始化 Git 仓库..."
if [ ! -d ".git" ]; then
    git init
    echo "✓ Git 仓库已初始化"
else
    echo "✓ Git 仓库已存在"
fi

# 3. 添加所有文件
echo "3. 添加所有文件..."
git add .
echo "✓ 文件已添加"

# 4. 提交代码
echo "4. 提交代码..."
git commit -m "初始提交: ModEditor 基础框架 - $(date)"
echo "✓ 代码已提交"

# 5. 设置远程仓库
echo "5. 设置远程仓库..."
REMOTE_URL="https://github.com/$GITHUB_USERNAME/$REPO_NAME.git"

# 检查是否已设置远程仓库
if git remote get-url origin &> /dev/null; then
    echo "✓ 远程仓库已设置: $(git remote get-url origin)"
else
    git remote add origin $REMOTE_URL
    echo "✓ 远程仓库已添加: $REMOTE_URL"
fi

# 6. 推送代码
echo "6. 推送代码到 GitHub..."
echo "正在推送到 $REMOTE_URL ..."

# 设置分支
git branch -M main

# 推送代码
if git push -u origin main; then
    echo "✓ 代码已成功推送到 GitHub"
    echo ""
    echo "🎉 项目已成功上传到 GitHub！"
    echo "仓库地址: https://github.com/$GITHUB_USERNAME/$REPO_NAME"
    echo ""
    echo "下一步操作:"
    echo "1. 访问仓库页面: https://github.com/$GITHUB_USERNAME/$REPO_NAME"
    echo "2. 点击 'Actions' 选项卡"
    echo "3. 启用 GitHub Actions"
    echo "4. 等待自动构建完成"
    echo "5. 在 'Artifacts' 部分下载 APK 文件"
else
    echo "✗ 推送失败"
    echo ""
    echo "可能的原因:"
    echo "1. GitHub 用户名错误"
    echo "2. 仓库不存在"
    echo "3. 认证失败"
    echo "4. 网络问题"
    echo ""
    echo "请检查:"
    echo "1. GitHub 用户名是否正确"
    echo "2. 是否已在 GitHub 创建仓库"
    echo "3. 是否已配置 Git 认证"
fi

echo "=== 上传脚本完成 ==="