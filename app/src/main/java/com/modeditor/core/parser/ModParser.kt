package com.modeditor.core.parser

import com.google.gson.Gson
import com.google.gson.GsonBuilder
import com.google.gson.JsonElement
import com.google.gson.JsonObject
import com.modeditor.data.models.ModContent
import com.modeditor.data.models.ModFeature
import com.modeditor.data.models.ModFeatureGroup

/**
 * 模组内容解析器
 * 负责解析JSON格式的模组内容
 */
class ModParser {
    
    private val gson: Gson = GsonBuilder()
        .setPrettyPrinting()
        .disableHtmlEscaping()
        .create()
    
    /**
     * 解析JSON字符串为ModContent对象
     */
    fun parseJson(jsonString: String): ModContent {
        val jsonElement = gson.fromJson(jsonString, JsonElement::class.java)
        return parseModContent(jsonElement)
    }
    
    /**
     * 将ModContent对象转换为JSON字符串
     */
    fun toJson(modContent: ModContent): String {
        return gson.toJson(modContent)
    }
    
    /**
     * 解析JsonElement为ModContent
     */
    private fun parseModContent(jsonElement: JsonElement): ModContent {
        val jsonObject = jsonElement.asJsonObject
        
        return ModContent(
            title = parseLocalizedField(jsonObject, "@title"),
            description = parseLocalizedField(jsonObject, "@description"),
            author = jsonObject.get("@author")?.asString ?: "",
            version = jsonObject.get("@version")?.asString ?: "1.0.0",
            gv = jsonObject.get("@gv")?.asInt ?: 67,
            patches = jsonObject.get("@patches")?.asString,
            features = parseFeatures(jsonObject),
            featureGroups = parseFeatureGroups(jsonObject),
            tables = parseTables(jsonObject)
        )
    }
    
    /**
     * 解析多语言字段
     */
    private fun parseLocalizedField(jsonObject: JsonObject, fieldName: String): Map<String, String> {
        val field = jsonObject.get(fieldName) ?: return emptyMap()
        
        return when {
            field.isJsonObject -> {
                val result = mutableMapOf<String, String>()
                field.asJsonObject.entrySet().forEach { (key, value) ->
                    result[key] = value.asString
                }
                result
            }
            field.isJsonPrimitive -> {
                mapOf("default" to field.asString)
            }
            else -> emptyMap()
        }
    }
    
    /**
     * 解析特性
     */
    private fun parseFeatures(jsonObject: JsonObject): Map<String, ModFeature> {
        val featuresObj = jsonObject.getAsJsonObject("@features") ?: return emptyMap()
        val result = mutableMapOf<String, ModFeature>()
        
        featuresObj.entrySet().forEach { (featureName, featureElement) ->
            val featureObj = featureElement.asJsonObject
            result[featureName] = ModFeature(
                name = parseLocalizedField(featureObj, "@name"),
                description = parseLocalizedField(featureObj, "@description"),
                patches = featureObj.get("@patches")?.asString,
                root = featureObj.get("@root")?.asString,
                enabled = featureObj.get("@enabled")?.asBoolean ?: true,
                priority = featureObj.get("@priority")?.asInt ?: 0,
                conflicts = parseStringList(featureObj, "@conflicts")
            )
        }
        
        return result
    }
    
    /**
     * 解析特性分组
     */
    private fun parseFeatureGroups(jsonObject: JsonObject): Map<String, ModFeatureGroup> {
        val groupsObj = jsonObject.getAsJsonObject("@feature_groups") ?: return emptyMap()
        val result = mutableMapOf<String, ModFeatureGroup>()
        
        groupsObj.entrySet().forEach { (groupName, groupElement) ->
            val groupObj = groupElement.asJsonObject
            result[groupName] = ModFeatureGroup(
                name = parseLocalizedField(groupObj, "@name"),
                description = parseLocalizedField(groupObj, "@description"),
                type = groupObj.get("@type")?.asString ?: "DEFAULT",
                features = parseStringList(groupObj, "@features")
            )
        }
        
        return result
    }
    
    /**
     * 解析表格数据
     */
    private fun parseTables(jsonObject: JsonObject): Map<String, Map<String, Map<String, Any>>> {
        val result = mutableMapOf<String, Map<String, Map<String, Any>>>()
        
        jsonObject.entrySet().forEach { (tableName, tableElement) ->
            if (!tableName.startsWith("@") && tableElement.isJsonObject) {
                val tableObj = tableElement.asJsonObject
                val tableData = mutableMapOf<String, Map<String, Any>>()
                
                tableObj.entrySet().forEach { (rowName, rowElement) ->
                    if (rowElement.isJsonObject) {
                        val rowObj = rowElement.asJsonObject
                        val rowData = mutableMapOf<String, Any>()
                        
                        rowObj.entrySet().forEach { (columnName, columnElement) ->
                            rowData[columnName] = parseJsonValue(columnElement)
                        }
                        
                        tableData[rowName] = rowData
                    }
                }
                
                result[tableName] = tableData
            }
        }
        
        return result
    }
    
    /**
     * 解析JSON值
     */
    private fun parseJsonValue(element: JsonElement): Any {
        return when {
            element.isJsonPrimitive -> {
                val primitive = element.asJsonPrimitive
                when {
                    primitive.isBoolean -> primitive.asBoolean
                    primitive.isNumber -> primitive.asNumber
                    else -> primitive.asString
                }
            }
            element.isJsonArray -> {
                val list = mutableListOf<Any>()
                element.asJsonArray.forEach { list.add(parseJsonValue(it)) }
                list
            }
            element.isJsonObject -> {
                val map = mutableMapOf<String, Any>()
                element.asJsonObject.entrySet().forEach { (key, value) ->
                    map[key] = parseJsonValue(value)
                }
                map
            }
            else -> element.toString()
        }
    }
    
    /**
     * 解析字符串列表
     */
    private fun parseStringList(jsonObject: JsonObject, fieldName: String): List<String> {
        val array = jsonObject.getAsJsonArray(fieldName) ?: return emptyList()
        return array.map { it.asString }
    }
    
    /**
     * 验证JSON格式
     */
    fun validateJson(jsonString: String): Boolean {
        return try {
            gson.fromJson(jsonString, JsonElement::class.java)
            true
        } catch (e: Exception) {
            false
        }
    }
    
    /**
     * 获取JSON的格式化版本
     */
    fun formatJson(jsonString: String): String {
        return try {
            val jsonElement = gson.fromJson(jsonString, JsonElement::class.java)
            gson.toJson(jsonElement)
        } catch (e: Exception) {
            jsonString
        }
    }
}