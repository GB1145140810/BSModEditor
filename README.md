# ModEditor - 模组可视化编辑工具

[![Android CI](https://github.com/yourusername/ModEditor/actions/workflows/android.yml/badge.svg)](https://github.com/yourusername/ModEditor/actions/workflows/android.yml)

## 项目概述

ModEditor 是一个 Android 原生应用，用于可视化编辑 Null's Brawl 模组的 content.json 文件。它提供了直观的图形界面，让用户能够轻松创建、编辑和验证模组内容。

## 功能特性

### 核心功能
- ✅ **可视化编辑器**: 图形界面编辑 content.json
- ✅ **多格式支持**: 支持 ZIP、JSON、文件夹等多种导入方式
- ✅ **实时预览**: 实时显示 JSON 结构和效果
- ✅ **智能验证**: 自动检查 JSON 语法和模组规范
- ✅ **模板系统**: 预设常用模组结构
- ✅ **导出功能**: 生成可部署的模组文件

### 编辑功能
- 🎯 **元数据编辑**: 标题、描述、作者、版本等
- 🎯 **特性管理**: 创建和配置模组特性
- 🎯 **特性分组**: 组织相关特性
- 🎯 **表格编辑**: 编辑游戏数据表格
- 🎯 **多语言支持**: 支持多语言内容

### 工具功能
- 🛠️ **JSON 格式化**: 自动格式化 JSON 内容
- 🛠️ **语法检查**: 实时检查 JSON 语法错误
- 🛠️ **冲突检测**: 检测特性间的冲突
- 🛠️ **版本管理**: 管理模组版本历史

## 快速开始

### 环境要求
- Android Studio Hedgehog+ (2023.1.1+)
- JDK 11+
- Android SDK 34
- Kotlin 1.8+

### 安装步骤

1. **克隆项目**
```bash
git clone https://github.com/yourusername/ModEditor.git
cd ModEditor
```

2. **在 Android Studio 中打开**
   - 点击 "Open an existing Android Studio project"
   - 选择项目文件夹
   - 等待 Gradle 同步完成

3. **运行应用**
   - 连接 Android 设备或启动模拟器
   - 点击运行按钮 (绿色三角形)

### 构建 APK
```bash
# 构建 Debug 版本
./gradlew assembleDebug

# 构建 Release 版本
./gradlew assembleRelease
```

## 项目结构

```
ModEditor/
├── app/
│   ├── src/main/
│   │   ├── java/com/modeditor/
│   │   │   ├── core/                    # 核心业务逻辑
│   │   │   │   ├── parser/              # JSON 解析器
│   │   │   │   ├── validators/          # 验证器
│   │   │   │   └── importers/           # 文件导入器
│   │   │   ├── data/                    # 数据层
│   │   │   │   └── models/              # 数据模型
│   │   │   ├── ui/                      # 用户界面
│   │   │   │   ├── screens/             # 屏幕
│   │   │   │   ├── components/          # UI 组件
│   │   │   │   └── theme/               # 主题
│   │   │   └── viewmodel/               # ViewModel
│   │   ├── res/                         # 资源文件
│   │   └── AndroidManifest.xml          # 应用清单
│   └── build.gradle.kts                 # 应用构建配置
├── build.gradle.kts                     # 项目构建配置
└── settings.gradle.kts                  # 项目设置
```

## 核心模块

### 1. JSON 解析器 (`ModParser`)
```kotlin
// 解析 JSON 字符串为 ModContent 对象
val modContent = ModParser().parseJson(jsonString)

// 将 ModContent 对象转换为 JSON 字符串
val jsonString = ModParser().toJson(modContent)
```

### 2. 模组验证器 (`ModValidator`)
```kotlin
// 验证模组内容
val validationResult = ModValidator().validate(modContent)

if (validationResult.isValid) {
    // 验证通过
} else {
    // 显示错误信息
    validationResult.errors.forEach { error ->
        println("错误: $error")
    }
}
```

### 3. 数据模型 (`ModContent`)
```kotlin
data class ModContent(
    val title: Map<String, String>,           // 多语言标题
    val description: Map<String, String>,     // 多语言描述
    val author: String,                       // 作者
    val version: String,                      // 版本号
    val gv: Int,                             // 游戏版本
    val features: Map<String, ModFeature>,    // 特性
    val featureGroups: Map<String, ModFeatureGroup>, // 特性分组
    val tables: Map<String, Map<String, Map<String, Any>>> // 表格数据
)
```

## 使用示例

### 1. 创建新模组
```kotlin
val newMod = ModContent(
    title = mapOf("ZH" to "我的模组", "EN" to "My Mod"),
    description = mapOf("ZH" to "这是一个测试模组"),
    author = "开发者",
    version = "1.0.0",
    gv = 67,
    features = emptyMap(),
    featureGroups = emptyMap(),
    tables = emptyMap()
)
```

### 2. 编辑现有模组
```kotlin
// 加载模组
val mod = ModParser().parseJson(existingJson)

// 修改内容
val updatedMod = mod.copy(
    title = mod.title.toMutableMap().apply {
        put("ZH", "更新后的标题")
    }
)

// 保存修改
val updatedJson = ModParser().toJson(updatedMod)
```

### 3. 验证模组
```kotlin
val validator = ModValidator()
val result = validator.validate(modContent)

println(validator.getValidationSummary(result))
```

## 开发指南

### 添加新功能
1. 在 `core` 包中创建新的业务逻辑类
2. 在 `data/models` 中添加数据模型
3. 在 `ui/screens` 中创建新的界面
4. 在 `viewmodel` 中添加状态管理

### 测试
```bash
# 运行单元测试
./gradlew test

# 运行 Android 测试
./gradlew connectedAndroidTest
```

### 代码规范
- 使用 Kotlin 代码风格
- 遵循 MVVM 架构模式
- 编写清晰的注释和文档
- 保持模块间的低耦合

## 贡献指南

1. Fork 项目
2. 创建功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 创建 Pull Request

## 许可证

MIT License - 详见 [LICENSE](LICENSE) 文件

## 联系方式

- **项目主页**: https://github.com/yourusername/ModEditor
- **问题反馈**: https://github.com/yourusername/ModEditor/issues
- **讨论区**: https://github.com/yourusername/ModEditor/discussions

## 更新日志

### v1.0.0 (2024-01-15)
- 初始版本发布
- 支持 ZIP/JSON 文件导入导出
- 可视化编辑器
- 实时 JSON 预览
- 模组验证系统

## 致谢

- [Null's Brawl](https://nulls.gg/) - 游戏模组系统
- [Artwork](https://github.com/nulls-mods-community/artwork) - 模组加载器核心
- [BSML](https://github.com/lilmuff2/bsml) - 模组工具参考
- [Jetpack Compose](https://developer.android.com/jetpack/compose) - 现代 UI 框架