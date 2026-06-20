# GitHub Actions 操作指南

## 当前状态

✅ **代码已成功上传到 GitHub**
- 仓库地址: https://github.com/GB1145140810/BSModEditor
- 分支: main
- 最新提交: "移除敏感信息: 删除包含 GitHub Token 的文件"

## 启用 GitHub Actions

### 步骤 1: 访问仓库页面
1. 打开浏览器，访问: https://github.com/GB1145140810/BSModEditor
2. 登录您的 GitHub 账户（如果尚未登录）

### 步骤 2: 找到 "Actions" 选项卡
在仓库页面，您会看到以下选项卡:
- **Code** - 代码视图
- **Issues** - 问题跟踪
- **Pull requests** - 拉取请求
- **Actions** - **← 点击这里**

### 步骤 3: 启用 GitHub Actions
1. 点击 "Actions" 选项卡
2. 如果看到 "Get started with GitHub Actions" 页面:
   - 点击 "I understand my workflows, go ahead and enable them"
3. 如果看到 "Workflows" 页面:
   - 说明 GitHub Actions 已启用

### 步骤 4: 查看工作流
在 "Actions" 页面，您应该能看到:
- **Android CI** 工作流（这是我们配置的自动构建工作流）
- 工作流状态: **待运行** 或 **运行中**

## 触发构建

### 自动触发
构建会在以下情况自动触发:
- ✅ 每次推送代码到 `main` 或 `develop` 分支
- ✅ 每次创建 Pull Request

### 手动触发
如果需要手动触发构建:
1. 在 "Actions" 页面
2. 点击左侧的 "Android CI" 工作流
3. 点击右侧的 "Run workflow" 按钮
4. 选择分支（通常是 `main`）
5. 点击 "Run workflow"

## 查看构建状态

### 1. 查看构建进度
在 "Actions" 页面，您可以看到:
- **绿色 ✓** - 构建成功
- **红色 ✗** - 构建失败
- **黄色 ●** - 构建进行中

### 2. 查看构建详情
点击具体的构建任务，可以查看:
- 构建日志
- 测试结果
- 构建时间

### 3. 下载 APK 文件
构建成功后，在构建详情页面:
1. 向下滚动到 **"Artifacts"** 部分
2. 点击 **"debug-apk"** 或 **"release-apk"** 下载
3. 保存到您的设备

## 安装和测试

### 1. 下载 APK 文件
从 "Artifacts" 部分下载 APK 文件

### 2. 传输到 Android 设备
将 APK 文件传输到您的 Android 设备

### 3. 安装 APK
在 Android 设备上安装 APK 文件

### 4. 测试应用
启动应用，测试所有功能

## 常见问题解决

### 问题 1: 构建失败
**解决方案**:
1. 查看构建日志，找出具体错误
2. 检查代码语法错误
3. 确保所有依赖项都正确

### 问题 2: 没有看到 "Actions" 选项卡
**解决方案**:
1. 确保您是仓库的所有者
2. 检查仓库是否为公开仓库
3. 尝试刷新页面

### 问题 3: 构建时间过长
**解决方案**:
1. GitHub Actions 有免费额度限制
2. 构建可能需要几分钟到十几分钟
3. 耐心等待构建完成

## 预期结果

构建完成后，您将获得:
- ✅ **可安装的 APK 文件**
- ✅ **自动构建的测试报告**
- ✅ **完整的项目文档**

## 立即开始

**请立即访问仓库页面**: https://github.com/GB1145140810/BSModEditor

**然后按照上述步骤启用 GitHub Actions，等待自动构建完成！**

## 下一步行动

1. **访问仓库页面**: https://github.com/GB1145140810/BSModEditor
2. **点击 "Actions" 选项卡**
3. **启用 GitHub Actions**
4. **等待自动构建完成**
5. **下载 APK 文件**
6. **在 Android 设备上安装测试**

**如果您在操作过程中遇到任何问题，请随时告诉我，我会帮您解决！**