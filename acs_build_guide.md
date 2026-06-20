# ACS Lite 构建指南

## 问题诊断

您遇到的错误主要是由于：
1. **缺少 Android SDK 平台文件** (`android.jar`)
2. **缺少 Flutter SDK** (如果使用了 Flutter 依赖)
3. **缺少语言服务器 JAR 文件**
4. **Java 正则表达式错误**

## 解决方案

### 步骤1: 配置 Android SDK

在 ACS Lite 中：
1. 打开设置 (Settings)
2. 找到 "Android SDK" 配置
3. 确保已安装以下组件：
   - Android SDK Platform (API 33 或 34)
   - Android SDK Build-Tools
   - Android SDK Platform-Tools

### 步骤2: 使用简化构建配置

我已经为您创建了简化版本的构建文件：

```bash
# 在项目目录中执行
cp app/build_simple.gradle.kts app/build.gradle.kts
```

### 步骤3: 禁用不必要的语言服务器

在 ACS Lite 设置中：
1. 找到 "Language Servers" 配置
2. 禁用不需要的语言服务器：
   - Flutter Language Server
   - Dart Language Server
   - XML Language Server

### 步骤4: 使用 Gradle Wrapper

确保 Gradle Wrapper 存在：
```bash
# 检查 gradlew 文件
ls -la gradlew

# 如果没有，创建它
gradle wrapper --gradle-version 7.5
```

## 简化构建步骤

### 方法1: 使用命令行构建
```bash
# 1. 进入项目目录
cd ModEditor

# 2. 设置执行权限
chmod +x gradlew

# 3. 构建 Debug 版本
./gradlew assembleDebug

# 4. 查看生成的 APK
ls -la app/build/outputs/apk/debug/
```

### 方法2: 使用 ACS Lite 构建
1. 在 ACS Lite 中打开项目
2. 点击 "Build" 菜单
3. 选择 "Build Bundle(s) / APK(s)"
4. 选择 "Build APK(s)"

## 常见问题解决

### 问题1: android.jar not found
**解决方案**:
```bash
# 设置 ANDROID_HOME 环境变量
export ANDROID_HOME=/path/to/android/sdk

# 或者在 build.gradle.kts 中指定
android {
    compileSdk = 33
    // 使用本地 SDK 路径
}
```

### 问题2: 内存不足
**解决方案**:
```bash
# 在 gradle.properties 中添加
org.gradle.jvmargs=-Xmx2048m -XX:MaxPermSize=512m
```

### 问题3: 网络问题
**解决方案**:
```kotlin
// 在 build.gradle.kts 中添加镜像源
repositories {
    maven { url = uri("https://maven.aliyun.com/repository/public/") }
    google()
    mavenCentral()
}
```

## 替代方案

如果 ACS Lite 构建仍然有问题，可以考虑：

### 方案1: 使用在线构建服务
- **GitHub Actions**: 免费，自动化
- **Replit**: 简单易用
- **Gitpod**: 完整开发环境

### 方案2: 使用 Android Studio
- 下载 Android Studio: https://developer.android.com/studio
- 功能完整，支持所有特性

### 方案3: 使用命令行构建
```bash
# 安装 Gradle
sdk install gradle 7.5

# 构建项目
gradle assembleDebug
```

## 配置文件说明

### build_simple.gradle.kts 特点：
1. **降低 SDK 版本**: compileSdk = 33, minSdk = 21
2. **简化依赖**: 移除不必要的依赖
3. **使用稳定版本**: 避免 beta 版本问题
4. **减少网络请求**: 使用本地缓存

### 推荐配置：
```kotlin
android {
    compileSdk = 33
    defaultConfig {
        minSdk = 21
        targetSdk = 33
    }
}
```

## 测试构建

### 1. 检查环境
```bash
# 检查 Java 版本
java -version

# 检查 Gradle 版本
gradle --version

# 检查 Android SDK
echo $ANDROID_HOME
```

### 2. 清理并构建
```bash
# 清理项目
./gradlew clean

# 构建 Debug 版本
./gradlew assembleDebug

# 运行测试
./gradlew test
```

### 3. 查看结果
```bash
# 查看生成的 APK
ls -la app/build/outputs/apk/debug/

# 查看构建日志
cat app/build/reports/tests/test/index.html
```

## 下一步行动

### 如果构建成功：
1. **测试 APK**: 在 Android 设备上安装测试
2. **提交代码**: 推送到 GitHub
3. **继续开发**: 实现第二阶段功能

### 如果构建失败：
1. **检查错误日志**: 查看详细错误信息
2. **简化配置**: 使用 build_simple.gradle.kts
3. **寻求帮助**: 在 GitHub Issues 中提问

## 联系支持

### GitHub Issues
- 地址: https://github.com/YOUR_USERNAME/ModEditor/issues
- 用途: 报告问题，请求功能

### 社区支持
- 讨论区: GitHub Discussions
- 文档: README.md 和 ONLINE_BUILD_GUIDE.md

## 总结

ACS Lite 构建问题通常可以通过以下方式解决：
1. ✅ 配置正确的 Android SDK
2. ✅ 使用简化版本的构建文件
3. ✅ 禁用不必要的语言服务器
4. ✅ 使用 Gradle Wrapper

如果问题仍然存在，建议使用 GitHub Actions 在线构建，这是最可靠的方案。