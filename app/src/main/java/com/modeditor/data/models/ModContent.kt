package com.modeditor.data.models

import com.google.gson.annotations.SerializedName

/**
 * 模组内容主模型
 */
data class ModContent(
    @SerializedName("@title")
    val title: Map<String, String> = emptyMap(),
    
    @SerializedName("@description")
    val description: Map<String, String> = emptyMap(),
    
    @SerializedName("@author")
    val author: String = "",
    
    @SerializedName("@version")
    val version: String = "1.0.0",
    
    @SerializedName("@gv")
    val gv: Int = 67,
    
    @SerializedName("@patches")
    val patches: String? = null,
    
    @SerializedName("@features")
    val features: Map<String, ModFeature> = emptyMap(),
    
    @SerializedName("@feature_groups")
    val featureGroups: Map<String, ModFeatureGroup> = emptyMap(),
    
    // 动态表格数据
    val tables: Map<String, Map<String, Map<String, Any>>> = emptyMap()
)

/**
 * 模组特性模型
 */
data class ModFeature(
    @SerializedName("@name")
    val name: Map<String, String> = emptyMap(),
    
    @SerializedName("@description")
    val description: Map<String, String>? = null,
    
    @SerializedName("@patches")
    val patches: String? = null,
    
    @SerializedName("@root")
    val root: String? = null,
    
    @SerializedName("@enabled")
    val enabled: Boolean = true,
    
    @SerializedName("@priority")
    val priority: Int = 0,
    
    @SerializedName("@conflicts")
    val conflicts: List<String> = emptyList()
)

/**
 * 特性分组模型
 */
data class ModFeatureGroup(
    @SerializedName("@name")
    val name: Map<String, String> = emptyMap(),
    
    @SerializedName("@description")
    val description: Map<String, String>? = null,
    
    @SerializedName("@type")
    val type: String = "DEFAULT", // "DEFAULT" 或 "RADIO_GROUP"
    
    @SerializedName("@features")
    val features: List<String> = emptyList()
)

/**
 * 验证结果模型
 */
data class ValidationResult(
    val isValid: Boolean,
    val errors: List<String>,
    val warnings: List<String>
)

/**
 * 编辑模式枚举
 */
enum class EditMode {
    FILE_IMPORT,    // 文件导入模式
    FOLDER_ACCESS,  // 文件夹访问模式
    GENERATOR       // 生成器模式
}

/**
 * 导出格式枚举
 */
enum class ExportFormat {
    ZIP,
    JSON,
    FOLDER
}

/**
 * 模组格式枚举
 */
enum class ModFormat {
    ZIP,
    JSON,
    FOLDER,
    GITHUB
}