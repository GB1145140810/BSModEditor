# GitHub Actions 在线构建指南

## 为什么选择 GitHub Actions？

由于工作区环境有限制，我强烈建议使用 GitHub Actions 进行在线构建：

### 优势：
1. ✅ **完全自动化**：每次推送代码自动构建
2. ✅ **免费额度**：每月 2000 分钟免费构建时间
3. ✅ **多平台支持**：支持 Android、iOS、Web 等
4. ✅ **集成测试**：自动运行单元测试
5. ✅ **版本管理**：自动发布到 GitHub Releases

## 快速开始步骤

### 步骤 1: 创建 GitHub 仓库

1. 访问 https://github.com
2. 点击 "New repository"
3. 仓库名：`ModEditor`
4. 选择 "Public"（公开）或 "Private"（私有）
5. **重要**：不要勾选 "Add a README file"
6. 点击 "Create repository"

### 步骤 2: 上传代码到 GitHub

#### 方法 1: 使用 GitHub Desktop（推荐初学者）
1. 下载 GitHub Desktop：https://desktop.github.com
2. 安装并登录 GitHub 账户
3. 点击 "File" → "Add local repository"
4. 选择您的 ModEditor 文件夹
5. 点击 "Publish repository"
6. 选择仓库名和可见性
7. 点击 "Publish Repository"

#### 方法 2: 使用命令行（Git）
```bash
# 1. 进入项目目录
cd /data/user/0/com.ai.assistance.operit/files/workspace/ModEditor

# 2. 初始化 Git 仓库
git init

# 3. 添加所有文件
git add .

# 4. 提交代码
git commit -m "初始提交: ModEditor 基础框架"

# 5. 添加远程仓库（替换 YOUR_USERNAME）
git remote add origin https://github.com/YOUR_USERNAME/ModEditor.git

# 6. 推送代码
git branch -M main
git push -u origin main
```

### 步骤 3: 启用 GitHub Actions

1. **访问仓库页面**：https://github.com/YOUR_USERNAME/ModEditor
2. **点击 "Actions" 选项卡**
3. **点击 "I understand my workflows, go ahead and enable them"**
4. **GitHub Actions 会自动检测到 `.github/workflows/android.yml` 文件**

### 步骤 4: 触发构建

构建会在以下情况自动触发：
- ✅ 每次推送代码到 `main` 或 `develop` 分支
- ✅ 每次创建 Pull Request
- ✅ 手动触发（在 Actions 页面点击 "Run workflow"）

### 步骤 5: 查看构建结果

1. **在 "Actions" 选项卡查看构建状态**
   - 绿色 ✓：构建成功
   - 红色 ✗：构建失败

2. **点击具体的构建任务查看详情**
   - 查看构建日志
   - 查看测试结果

3. **下载 APK 文件**
   - 在构建详情页面，向下滚动到 "Artifacts" 部分
   - 点击 "debug-apk" 或 "release-apk" 下载

## GitHub Actions 配置文件

我已经为您准备好了 GitHub Actions 配置文件：

```yaml
# .github/workflows/android.yml
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

## 构建产物说明

### Debug APK
- **路径**: `app/build/outputs/apk/debug/app-debug.apk`
- **特点**: 包含调试信息，可直接安装
- **用途**: 开发测试，功能验证

### Release APK
- **路径**: `app/build/outputs/apk/release/app-release-unsigned.apk`
- **特点**: 未签名，需要签名后安装
- **用途**: 发布版本，生产环境

### 测试报告
- **路径**: `app/build/reports/tests/`
- **内容**: 单元测试结果，覆盖率报告
- **用途**: 质量保证，代码审查

## 常见问题解决

### 问题 1: 构建失败
**解决方案**:
1. 查看构建日志，找出具体错误
2. 检查代码语法错误
3. 确保所有依赖项都正确

### 问题 2: 依赖下载慢
**解决方案**:
1. 使用国内镜像源
2. 在 `build.gradle.kts` 中添加镜像源配置

### 问题 3: 内存不足
**解决方案**:
1. 增加 Gradle 内存设置
2. 在 `gradle.properties` 中添加：
```properties
org.gradle.jvmargs=-Xmx4096m
```

## 下一步行动

### 1. 立即开始
1. 创建 GitHub 仓库
2. 上传代码
3. 启用 GitHub Actions
4. 等待构建完成

### 2. 测试验证
1. 下载 APK 文件
2. 在 Android 设备上安装测试
3. 验证所有功能正常

### 3. 持续开发
1. 代码更新时自动触发构建
2. 使用 Git 进行版本控制
3. 邀请他人参与项目开发

## 总结

GitHub Actions 是构建 Android 项目的最佳选择，因为：
- ✅ 完全自动化，无需手动操作
- ✅ 免费额度充足，适合个人项目
- ✅ 支持多平台构建，灵活性高
- ✅ 集成测试和部署，流程完整

**立即开始使用 GitHub Actions 构建您的 ModEditor 项目！**