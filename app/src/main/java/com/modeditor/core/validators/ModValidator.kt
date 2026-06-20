package com.modeditor.core.validators

import com.modeditor.data.models.ModContent
import com.modeditor.data.models.ValidationResult

/**
 * 模组验证器
 * 负责验证模组内容的完整性和正确性
 */
class ModValidator {
    
    /**
     * 验证模组内容
     */
    fun validate(modContent: ModContent): ValidationResult {
        val errors = mutableListOf<String>()
        val warnings = mutableListOf<String>()
        
        // 1. 元数据验证
        validateMetadata(modContent, errors, warnings)
        
        // 2. 特性验证
        validateFeatures(modContent, errors, warnings)
        
        // 3. 特性分组验证
        validateFeatureGroups(modContent, errors, warnings)
        
        // 4. 表格数据验证
        validateTables(modContent, errors, warnings)
        
        return ValidationResult(
            isValid = errors.isEmpty(),
            errors = errors,
            warnings = warnings
        )
    }
    
    /**
     * 验证元数据
     */
    private fun validateMetadata(
        modContent: ModContent,
        errors: MutableList<String>,
        warnings: MutableList<String>
    ) {
        // 标题验证
        if (modContent.title.isEmpty()) {
            errors.add("标题不能为空")
        } else if (!modContent.title.containsKey("EN") && !modContent.title.containsKey("default")) {
            warnings.add("建议添加英文标题以提高可访问性")
        }
        
        // 版本格式验证
        if (!modContent.version.matches(Regex("\\d+\\.\\d+\\.\\d+"))) {
            errors.add("版本号格式错误，应为 X.Y.Z")
        }
        
        // 作者验证
        if (modContent.author.isBlank()) {
            warnings.add("建议添加作者信息")
        }
        
        // 游戏版本验证
        if (modContent.gv < 60) {
            warnings.add("游戏版本较低，可能不兼容最新功能")
        }
    }
    
    /**
     * 验证特性
     */
    private fun validateFeatures(
        modContent: ModContent,
        errors: MutableList<String>,
        warnings: MutableList<String>
    ) {
        modContent.features.forEach { (name, feature) ->
            // 特性名称验证
            if (feature.name.isEmpty()) {
                errors.add("特性 '$name' 缺少名称")
            }
            
            // 启用特性验证
            if (feature.enabled && feature.name.isEmpty()) {
                warnings.add("特性 '$name' 已启用但缺少名称")
            }
            
            // 冲突检测
            feature.conflicts.forEach { conflict ->
                if (!modContent.features.containsKey(conflict)) {
                    warnings.add("特性 '$name' 引用了不存在的冲突特性 '$conflict'")
                }
            }
        }
        
        // 特性冲突检测
        val enabledFeatures = modContent.features.filter { it.value.enabled }
        enabledFeatures.forEach { (name, feature) ->
            feature.conflicts.forEach { conflict ->
                if (enabledFeatures.containsKey(conflict)) {
                    errors.add("特性 '$name' 与 '$conflict' 冲突，两者不能同时启用")
                }
            }
        }
    }
    
    /**
     * 验证特性分组
     */
    private fun validateFeatureGroups(
        modContent: ModContent,
        errors: MutableList<String>,
        warnings: MutableList<String>
    ) {
        modContent.featureGroups.forEach { (groupName, group) ->
            // 分组名称验证
            if (group.name.isEmpty()) {
                errors.add("特性分组 '$groupName' 缺少名称")
            }
            
            // 分组类型验证
            if (group.type !in listOf("DEFAULT", "RADIO_GROUP")) {
                errors.add("特性分组 '$groupName' 类型无效，应为 'DEFAULT' 或 'RADIO_GROUP'")
            }
            
            // 分组特性验证
            if (group.features.isEmpty()) {
                warnings.add("特性分组 '$groupName' 没有包含任何特性")
            } else {
                group.features.forEach { featureName ->
                    if (!modContent.features.containsKey(featureName)) {
                        errors.add("特性分组 '$groupName' 引用了不存在的特性 '$featureName'")
                    }
                }
            }
            
            // RADIO_GROUP 验证
            if (group.type == "RADIO_GROUP") {
                val enabledInGroup = group.features.filter { 
                    modContent.features[it]?.enabled == true 
                }
                if (enabledInGroup.size > 1) {
                    errors.add("RADIO_GROUP '$groupName' 中只能有一个启用的特性")
                }
            }
        }
    }
    
    /**
     * 验证表格数据
     */
    private fun validateTables(
        modContent: ModContent,
        errors: MutableList<String>,
        warnings: MutableList<String>
    ) {
        modContent.tables.forEach { (tableName, tableData) ->
            tableData.forEach { (rowName, columns) ->
                columns.forEach { (columnName, value) ->
                    // 空值检查
                    if (value.toString().isBlank()) {
                        warnings.add("表格 '$tableName' 中 '$rowName.$columnName' 值为空")
                    }
                    
                    // 数据类型检查
                    if (value is String && value.length > 1000) {
                        warnings.add("表格 '$tableName' 中 '$rowName.$columnName' 值过长")
                    }
                }
            }
        }
    }
    
    /**
     * 验证JSON字符串
     */
    fun validateJsonString(jsonString: String): ValidationResult {
        val errors = mutableListOf<String>()
        val warnings = mutableListOf<String>()
        
        try {
            // 尝试解析JSON
            val parser = com.modeditor.core.parser.ModParser()
            val modContent = parser.parseJson(jsonString)
            
            // 如果解析成功，进行内容验证
            val contentValidation = validate(modContent)
            errors.addAll(contentValidation.errors)
            warnings.addAll(contentValidation.warnings)
            
        } catch (e: Exception) {
            errors.add("JSON格式错误: ${e.message}")
        }
        
        return ValidationResult(
            isValid = errors.isEmpty(),
            errors = errors,
            warnings = warnings
        )
    }
    
    /**
     * 获取验证摘要
     */
    fun getValidationSummary(validationResult: ValidationResult): String {
        val sb = StringBuilder()
        
        if (validationResult.isValid) {
            sb.appendLine("✓ 验证通过")
        } else {
            sb.appendLine("✗ 验证失败")
        }
        
        if (validationResult.errors.isNotEmpty()) {
            sb.appendLine("\n错误 (${validationResult.errors.size}):")
            validationResult.errors.forEach { error ->
                sb.appendLine("  • $error")
            }
        }
        
        if (validationResult.warnings.isNotEmpty()) {
            sb.appendLine("\n警告 (${validationResult.warnings.size}):")
            validationResult.warnings.forEach { warning ->
                sb.appendLine("  • $warning")
            }
        }
        
        return sb.toString()
    }
}