# GitHub 仓库设置和自动构建指南

## 第一步：创建 GitHub 仓库

### 1. 访问 GitHub
打开浏览器，访问：https://github.com

### 2. 登录您的账户
使用您的 GitHub 用户名和密码登录

### 3. 创建新仓库
1. 点击右上角的 "+" 图标
2. 选择 "New repository"
3. 填写仓库信息：
   - **Repository name**: `ModEditor`
   - **Description**: `模组可视化编辑工具 - Android 应用`
   - **Visibility**: 选择 "Public"（公开）或 "Private"（私有）
   - **重要**: 不要勾选 "Add a README file"
4. 点击 "Create repository"

## 第二步：上传代码到 GitHub

### 方法 1: 使用 GitHub Desktop（推荐）

1. **下载 GitHub Desktop**
   - 访问：https://desktop.github.com
   - 下载并安装

2. **登录 GitHub Desktop**
   - 打开 GitHub Desktop
   - 使用您的 GitHub 账户登录

3. **添加本地仓库**
   - 点击 "File" → "Add local repository"
   - 选择您的 ModEditor 文件夹
   - 点击 "选择文件夹"

4. **发布仓库**
   - 点击 "Publish repository"
   - 选择仓库名：`ModEditor`
   - 选择可见性：Public 或 Private
   - 点击 "Publish Repository"

### 方法 2: 使用命令行（Git）

在您的设备上执行以下命令：

```bash
# 1. 进入项目目录
cd /data/user/0/com.ai.assistance.operit/files/workspace/ModEditor

# 2. 初始化 Git 仓库
git init

# 3. 添加所有文件
git add .

# 4. 提交代码
git commit -m "初始提交: ModEditor 基础框架"

# 5. 设置远程仓库（替换 YOUR_USERNAME）
git remote add origin https://github.com/YOUR_USERNAME/ModEditor.git

# 6. 推送代码
git branch -M main
git push -u origin main
```

## 第三步：启用 GitHub Actions

### 1. 访问仓库页面
打开浏览器，访问：https://github.com/YOUR_USERNAME/ModEditor

### 2. 启用 GitHub Actions
1. 点击 "Actions" 选项卡
2. 点击 "I understand my workflows, go ahead and enable them"
3. GitHub Actions 会自动检测到 `.github/workflows/android.yml` 文件

### 3. 查看构建状态
1. 在 "Actions" 选项卡查看构建状态
2. 绿色 ✓ 表示构建成功
3. 红色 ✗ 表示构建失败

## 第四步：下载 APK 文件

### 1. 查看构建结果
1. 在 "Actions" 选项卡点击具体的构建任务
2. 查看构建详情和日志

### 2. 下载 APK 文件
1. 在构建详情页面，向下滚动到 "Artifacts" 部分
2. 点击 "debug-apk" 或 "release-apk" 下载
3. 保存到您的设备

### 3. 安装 APK
1. 将 APK 文件传输到 Android 设备
2. 在设备上安装 APK
3. 测试应用功能

## 第五步：自动构建配置

### GitHub Actions 配置说明

项目中已包含 GitHub Actions 配置文件：`.github/workflows/android.yml`

```yaml
name: Android CI

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v3
      
    - name: Set up JDK 11
      uses: actions/setup-java@v3
      with:
        java-version: '11'
        distribution: 'temurin'
        
    - name: Grant execute permission for gradlew
      run: chmod +x gradlew
      
    - name: Build Debug APK
      run: ./gradlew assembleDebug
      
    - name: Build Release APK
      run: ./gradlew assembleRelease
      
    - name: Upload Debug APK
      uses: actions/upload-artifact@v3
      with:
        name: debug-apk
        path: app/build/outputs/apk/debug/app-debug.apk
        
    - name: Upload Release APK
      uses: actions/upload-artifact@v3
      with:
        name: release-apk
        path: app/build/outputs/apk/release/app-release-unsigned.apk
        
    - name: Run tests
      run: ./gradlew test
      
    - name: Upload test results
      if: always()
      uses: actions/upload-artifact@v3
      with:
        name: test-results
        path: app/build/reports/tests/
```

## 常见问题解决

### 问题 1: 推送失败
**解决方案**:
1. 检查 GitHub 用户名是否正确
2. 确保仓库已创建
3. 检查 Git 认证配置

### 问题 2: 构建失败
**解决方案**:
1. 查看构建日志，找出具体错误
2. 检查代码语法错误
3. 确保所有依赖项都正确

### 问题 3: 下载失败
**解决方案**:
1. 检查网络连接
2. 尝试使用不同的浏览器
3. 联系 GitHub 支持

## 下一步行动

### 立即开始
1. 创建 GitHub 仓库
2. 上传代码
3. 启用 GitHub Actions
4. 等待构建完成

### 测试验证
1. 下载 APK 文件
2. 在 Android 设备上安装测试
3. 验证所有功能正常

### 持续开发
1. 代码更新时自动触发构建
2. 使用 Git 进行版本控制
3. 邀请他人参与项目开发

## 总结

使用 GitHub Actions 进行在线构建是构建 Android 项目的最佳选择，因为：
- ✅ 完全自动化，无需手动操作
- ✅ 免费额度充足，适合个人项目
- ✅ 支持多平台构建，灵活性高
- ✅ 集成测试和部署，流程完整

**立即开始使用 GitHub Actions 构建您的 ModEditor 项目！**