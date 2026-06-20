# 在线编译指南

## 方案1: GitHub Actions (推荐)

### 步骤1: 创建GitHub仓库
1. 访问 https://github.com
2. 点击 "New repository"
3. 仓库名: `ModEditor`
4. 选择 "Public" 或 "Private"
5. 不要初始化README（我们已有代码）
6. 点击 "Create repository"

### 步骤2: 上传代码到GitHub
```bash
# 在项目目录中执行
cd ModEditor

# 初始化Git仓库
git init

# 添加所有文件
git add .

# 提交
git commit -m "初始提交: ModEditor基础框架"

# 添加远程仓库（替换YOUR_USERNAME）
git remote add origin https://github.com/YOUR_USERNAME/ModEditor.git

# 推送代码
git branch -M main
git push -u origin main
```

### 步骤3: 启用GitHub Actions
1. 在GitHub仓库页面，点击 "Actions" 选项卡
2. 点击 "I understand my workflows, go ahead and enable them"
3. GitHub Actions会自动检测到 `.github/workflows/android.yml` 文件
4. 每次推送代码都会自动触发构建

### 步骤4: 查看构建结果
1. 在 "Actions" 选项卡查看构建状态
2. 点击具体的构建任务查看详情
3. 在 "Artifacts" 部分下载APK文件

## 方案2: Replit在线IDE

### 步骤1: 创建Replit账户
1. 访问 https://replit.com
2. 使用GitHub账户登录

### 步骤2: 创建Android项目
1. 点击 "Create Repl"
2. 选择 "Android" 模板
3. 项目名: `ModEditor`

### 步骤3: 上传项目文件
1. 将项目文件压缩为ZIP
2. 在Replit中上传ZIP文件
3. 解压到项目目录

### 步骤4: 编译和运行
1. 在Replit终端中运行：
```bash
# 构建Debug版本
./gradlew assembleDebug

# 运行测试
./gradlew test
```

## 方案3: Gitpod在线IDE

### 步骤1: 访问Gitpod
1. 访问 https://gitpod.io
2. 使用GitHub账户登录

### 步骤2: 打开项目
1. 在GitHub仓库页面，点击 "Gitpod" 按钮
   （需要安装Gitpod浏览器扩展）
2. 或者直接访问: `https://gitpod.io/#https://github.com/YOUR_USERNAME/ModEditor`

### 步骤3: 编译项目
在Gitpod终端中运行：
```bash
# 安装依赖
./gradlew build

# 构建APK
./gradlew assembleDebug

# 运行测试
./gradlew test
```

## 方案4: 本地编译（需要Java环境）

### 环境要求
- JDK 11+
- 至少8GB内存
- 稳定的网络连接

### 编译步骤
```bash
# 1. 克隆项目
git clone https://github.com/YOUR_USERNAME/ModEditor.git
cd ModEditor

# 2. Linux/macOS
chmod +x build.sh
./build.sh debug

# 3. Windows
build.bat debug
```

## 常见问题解决

### 问题1: Gradle下载失败
**解决方案**:
1. 检查网络连接
2. 使用国内镜像源
3. 在 `build.gradle.kts` 中添加：
```kotlin
repositories {
    maven { url = uri("https://maven.aliyun.com/repository/public/") }
    google()
    mavenCentral()
}
```

### 问题2: 内存不足
**解决方案**:
1. 增加Gradle内存设置
2. 在 `gradle.properties` 中添加：
```properties
org.gradle.jvmargs=-Xmx4096m -XX:MaxPermSize=512m
```

### 问题3: 依赖下载慢
**解决方案**:
1. 使用代理
2. 配置镜像仓库
3. 使用本地缓存

## 构建输出文件

### Debug版本
- 路径: `app/build/outputs/apk/debug/app-debug.apk`
- 特点: 包含调试信息，可直接安装测试

### Release版本
- 路径: `app/build/outputs/apk/release/app-release-unsigned.apk`
- 特点: 未签名，需要签名后才能安装

### 测试报告
- 路径: `app/build/reports/tests/`
- 内容: 单元测试结果和覆盖率报告

## 签名APK（可选）

### 生成签名文件
```bash
keytool -genkey -v -keystore my-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias my-alias
```

### 签名APK
```bash
jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore my-release-key.jks app-release-unsigned.apk my-alias
```

### 优化APK
```bash
zipalign -v 4 app-release-unsigned.apk app-release.apk
```

## 持续集成/持续部署 (CI/CD)

### 自动发布到GitHub Releases
在 `.github/workflows/android.yml` 中添加：
```yaml
- name: Create Release
  if: startsWith(github.ref, 'refs/tags/')
  uses: actions/create-release@v1
  with:
    tag_name: ${{ github.ref }}
    release_name: Release ${{ github.ref }}
    draft: false
    prerelease: false

- name: Upload Release APK
  if: startsWith(github.ref, 'refs/tags/')
  uses: actions/upload-release-asset@v1
  with:
    upload_url: ${{ steps.create_release.outputs.upload_url }}
    asset_path: app/build/outputs/apk/release/app-release-unsigned.apk
    asset_name: ModEditor-${{ github.ref }}.apk
    asset_content_type: application/vnd.android.package-archive
```

## 性能优化建议

### 1. 使用Gradle缓存
```kotlin
// 在build.gradle.kts中
buildCache {
    local {
        directory = File(rootDir, "build-cache")
        removeUnusedEntriesAfterDays = 30
    }
}
```

### 2. 并行构建
在 `gradle.properties` 中：
```properties
org.gradle.parallel=true
org.gradle.caching=true
```

### 3. 增量构建
```bash
# 只构建更改的部分
./gradlew assembleDebug --incremental
```

## 调试和故障排除

### 查看详细日志
```bash
# 显示详细构建信息
./gradlew assembleDebug --info

# 显示调试信息
./gradlew assembleDebug --debug

# 显示堆栈跟踪
./gradlew assembleDebug --stacktrace
```

### 清理构建缓存
```bash
# 清理所有构建产物
./gradlew clean

# 清理Gradle缓存
./gradlew cleanBuildCache
```

## 下一步操作

### 1. 测试APK
1. 将APK文件传输到Android设备
2. 安装APK文件
3. 测试应用功能

### 2. 提交反馈
1. 在GitHub Issues中报告问题
2. 提交功能请求
3. 参与代码贡献

### 3. 持续改进
1. 根据测试反馈优化代码
2. 添加新功能
3. 改进用户体验

## 总结

推荐使用 **GitHub Actions** 方案，因为：
1. ✅ 完全自动化
2. ✅ 免费额度充足
3. ✅ 支持多平台构建
4. ✅ 集成测试和部署
5. ✅ 版本管理方便

其他方案作为备选，可根据实际情况选择使用。