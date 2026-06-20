package com.modeditor.core.parser

import org.junit.Assert.*
import org.junit.Before
import org.junit.Test

/**
 * 模组解析器测试
 */
class ModParserTest {
    
    private lateinit var parser: ModParser
    
    @Before
    fun setup() {
        parser = ModParser()
    }
    
    @Test
    fun testParseBasicMod() {
        val json = """
        {
            "@title": {"ZH": "测试模组", "EN": "Test Mod"},
            "@description": {"ZH": "这是一个测试模组"},
            "@author": "测试作者",
            "@version": "1.0.0",
            "@gv": 67
        }
        """.trimIndent()
        
        val mod = parser.parseJson(json)
        
        assertEquals("测试模组", mod.title["ZH"])
        assertEquals("Test Mod", mod.title["EN"])
        assertEquals("这是一个测试模组", mod.description["ZH"])
        assertEquals("测试作者", mod.author)
        assertEquals("1.0.0", mod.version)
        assertEquals(67, mod.gv)
    }
    
    @Test
    fun testParseFeatures() {
        val json = """
        {
            "@features": {
                "myFeature": {
                    "@name": {"ZH": "我的特性"},
                    "@enabled": true,
                    "@priority": 1,
                    "@conflicts": ["otherFeature"]
                },
                "otherFeature": {
                    "@name": {"ZH": "其他特性"},
                    "@enabled": false
                }
            }
        }
        """.trimIndent()
        
        val mod = parser.parseJson(json)
        
        assertTrue(mod.features.containsKey("myFeature"))
        assertTrue(mod.features.containsKey("otherFeature"))
        
        val myFeature = mod.features["myFeature"]!!
        assertEquals("我的特性", myFeature.name["ZH"])
        assertTrue(myFeature.enabled)
        assertEquals(1, myFeature.priority)
        assertTrue(myFeature.conflicts.contains("otherFeature"))
        
        val otherFeature = mod.features["otherFeature"]!!
        assertFalse(otherFeature.enabled)
    }
    
    @Test
    fun testParseFeatureGroups() {
        val json = """
        {
            "@feature_groups": {
                "myGroup": {
                    "@name": {"ZH": "我的分组"},
                    "@type": "RADIO_GROUP",
                    "@features": ["feature1", "feature2"]
                }
            }
        }
        """.trimIndent()
        
        val mod = parser.parseJson(json)
        
        assertTrue(mod.featureGroups.containsKey("myGroup"))
        
        val group = mod.featureGroups["myGroup"]!!
        assertEquals("我的分组", group.name["ZH"])
        assertEquals("RADIO_GROUP", group.type)
        assertTrue(group.features.contains("feature1"))
        assertTrue(group.features.contains("feature2"))
    }
    
    @Test
    fun testParseTables() {
        val json = """
        {
            "characters": {
                "Shelly": {
                    "Hitpoints": 10000,
                    "Speed": 800
                },
                "Colt": {
                    "Hitpoints": 8000,
                    "Speed": 900
                }
            }
        }
        """.trimIndent()
        
        val mod = parser.parseJson(json)
        
        assertTrue(mod.tables.containsKey("characters"))
        
        val characters = mod.tables["characters"]!!
        assertTrue(characters.containsKey("Shelly"))
        assertTrue(characters.containsKey("Colt"))
        
        val shelly = characters["Shelly"]!!
        assertEquals(10000, shelly["Hitpoints"])
        assertEquals(800, shelly["Speed"])
    }
    
    @Test
    fun testParseComplexMod() {
        val json = """
        {
            "@title": {"ZH": "复杂模组"},
            "@version": "2.1.0",
            "@gv": 68,
            "@features": {
                "skinFeature": {
                    "@name": {"ZH": "皮肤特性"},
                    "@enabled": true
                }
            },
            "@feature_groups": {
                "skinGroup": {
                    "@name": {"ZH": "皮肤组"},
                    "@type": "RADIO_GROUP",
                    "@features": ["skinFeature"]
                }
            },
            "characters": {
                "Shelly": {
                    "Hitpoints": 15000
                }
            }
        }
        """.trimIndent()
        
        val mod = parser.parseJson(json)
        
        assertEquals("复杂模组", mod.title["ZH"])
        assertEquals("2.1.0", mod.version)
        assertEquals(68, mod.gv)
        
        assertTrue(mod.features.containsKey("skinFeature"))
        assertTrue(mod.featureGroups.containsKey("skinGroup"))
        assertTrue(mod.tables.containsKey("characters"))
    }
    
    @Test
    fun testToJson() {
        val json = """
        {
            "@title": {"ZH": "测试"},
            "@version": "1.0.0"
        }
        """.trimIndent()
        
        val mod = parser.parseJson(json)
        val jsonOutput = parser.toJson(mod)
        
        assertTrue(jsonOutput.contains("\"@title\""))
        assertTrue(jsonOutput.contains("\"ZH\""))
        assertTrue(jsonOutput.contains("\"测试\""))
        assertTrue(jsonOutput.contains("\"@version\""))
        assertTrue(jsonOutput.contains("\"1.0.0\""))
    }
    
    @Test
    fun testValidateJson() {
        val validJson = """
        {
            "@title": "测试"
        }
        """.trimIndent()
        
        val invalidJson = """
        {
            "@title": "测试"
            "@version": "1.0.0"
        }
        """.trimIndent()
        
        assertTrue(parser.validateJson(validJson))
        assertFalse(parser.validateJson(invalidJson))
    }
    
    @Test
    fun testFormatJson() {
        val unformattedJson = """{"@title":"测试","@version":"1.0.0"}"""
        
        val formattedJson = parser.formatJson(unformattedJson)
        
        assertTrue(formattedJson.contains("\n"))
        assertTrue(formattedJson.contains("  "))
    }
}