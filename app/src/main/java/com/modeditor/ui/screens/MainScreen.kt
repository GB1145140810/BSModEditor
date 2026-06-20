package com.modeditor.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import com.modeditor.data.models.EditMode
import com.modeditor.data.models.ModContent
import com.modeditor.data.models.ModFormat

/**
 * 主界面屏幕
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun MainScreen() {
    var currentMode by remember { mutableStateOf(EditMode.FILE_IMPORT) }
    var currentMod by remember { mutableStateOf<ModContent?>(null) }
    var isImporting by remember { mutableStateOf(false) }
    
    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("ModEditor") },
                colors = TopAppBarDefaults.topAppBarColors(
                    containerColor = MaterialTheme.colorScheme.primaryContainer,
                    titleContentColor = MaterialTheme.colorScheme.primary
                ),
                actions = {
                    // 导入文件按钮
                    IconButton(
                        onClick = { /* TODO: 实现文件导入 */ }
                    ) {
                        Icon(Icons.Default.FileOpen, "导入文件")
                    }
                    
                    // 打开文件夹按钮
                    IconButton(
                        onClick = { /* TODO: 实现文件夹访问 */ }
                    ) {
                        Icon(Icons.Default.FolderOpen, "打开文件夹")
                    }
                    
                    // 新建模组按钮
                    IconButton(
                        onClick = { /* TODO: 创建新模组 */ }
                    ) {
                        Icon(Icons.Default.Add, "新建模组")
                    }
                    
                    // 设置按钮
                    IconButton(
                        onClick = { /* TODO: 打开设置 */ }
                    ) {
                        Icon(Icons.Default.Settings, "设置")
                    }
                }
            )
        },
        bottomBar = {
            BottomAppBar(
                actions = {
                    // 验证按钮
                    IconButton(
                        onClick = { /* TODO: 验证模组 */ }
                    ) {
                        Icon(Icons.Default.CheckCircle, "验证")
                    }
                    
                    // 导出按钮
                    IconButton(
                        onClick = { /* TODO: 导出模组 */ }
                    ) {
                        Icon(Icons.Default.Save, "导出")
                    }
                    
                    // 预览按钮
                    IconButton(
                        onClick = { /* TODO: 预览模组 */ }
                    ) {
                        Icon(Icons.Default.Preview, "预览")
                    }
                }
            )
        }
    ) { paddingValues ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(paddingValues)
        ) {
            // 模式选择器
            ModeSelector(
                currentMode = currentMode,
                onModeChanged = { currentMode = it }
            )
            
            // 内容区域
            when (currentMode) {
                EditMode.FILE_IMPORT -> {
                    FileImportView(
                        currentMod = currentMod,
                        onModLoaded = { currentMod = it },
                        isImporting = isImporting,
                        onImportingChanged = { isImporting = it }
                    )
                }
                
                EditMode.FOLDER_ACCESS -> {
                    FolderAccessView(
                        currentMod = currentMod,
                        onModLoaded = { currentMod = it }
                    )
                }
                
                EditMode.GENERATOR -> {
                    GeneratorView(
                        onModGenerated = { currentMod = it }
                    )
                }
            }
        }
    }
}

/**
 * 模式选择器组件
 */
@Composable
fun ModeSelector(
    currentMode: EditMode,
    onModeChanged: (EditMode) -> Unit
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(16.dp),
        horizontalArrangement = Arrangement.SpaceEvenly
    ) {
        EditMode.values().forEach { mode ->
            val isSelected = mode == currentMode
            val text = when (mode) {
                EditMode.FILE_IMPORT -> "文件导入"
                EditMode.FOLDER_ACCESS -> "文件夹访问"
                EditMode.GENERATOR -> "模组生成"
            }
            
            FilterChip(
                selected = isSelected,
                onClick = { onModeChanged(mode) },
                label = { Text(text) },
                leadingIcon = if (isSelected) {
                    {
                        Icon(
                            imageVector = Icons.Default.Check,
                            contentDescription = null,
                            modifier = Modifier.size(FilterChipDefaults.IconSize)
                        )
                    }
                } else null
            )
        }
    }
}

/**
 * 文件导入视图
 */
@Composable
fun FileImportView(
    currentMod: ModContent?,
    onModLoaded: (ModContent) -> Unit,
    isImporting: Boolean,
    onImportingChanged: (Boolean) -> Unit
) {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(16.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        if (currentMod == null) {
            // 没有加载模组时显示导入界面
            ImportSection(
                isImporting = isImporting,
                onImportingChanged = onImportingChanged,
                onModLoaded = onModLoaded
            )
        } else {
            // 已加载模组时显示编辑界面
            ModEditorView(
                modContent = currentMod,
                onModChanged = { /* TODO: 更新模组内容 */ }
            )
        }
    }
}

/**
 * 导入部分组件
 */
@Composable
fun ImportSection(
    isImporting: Boolean,
    onImportingChanged: (Boolean) -> Unit,
    onModLoaded: (ModContent) -> Unit
) {
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .padding(16.dp)
    ) {
        Column(
            modifier = Modifier.padding(24.dp),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Icon(
                imageVector = Icons.Default.FileOpen,
                contentDescription = null,
                modifier = Modifier.size(64.dp),
                tint = MaterialTheme.colorScheme.primary
            )
            
            Spacer(modifier = Modifier.height(16.dp))
            
            Text(
                text = "导入模组文件",
                style = MaterialTheme.typography.headlineSmall
            )
            
            Spacer(modifier = Modifier.height(8.dp))
            
            Text(
                text = "支持ZIP、JSON格式的模组文件",
                style = MaterialTheme.typography.bodyMedium,
                color = MaterialTheme.colorScheme.onSurfaceVariant
            )
            
            Spacer(modifier = Modifier.height(24.dp))
            
            if (isImporting) {
                CircularProgressIndicator()
                Spacer(modifier = Modifier.height(8.dp))
                Text("正在导入...")
            } else {
                Row(
                    horizontalArrangement = Arrangement.spacedBy(16.dp)
                ) {
                    Button(
                        onClick = { /* TODO: 从文件导入 */ }
                    ) {
                        Icon(Icons.Default.FileOpen, contentDescription = null)
                        Spacer(modifier = Modifier.width(8.dp))
                        Text("选择文件")
                    }
                    
                    OutlinedButton(
                        onClick = { /* TODO: 从URL导入 */ }
                    ) {
                        Icon(Icons.Default.Link, contentDescription = null)
                        Spacer(modifier = Modifier.width(8.dp))
                        Text("从URL导入")
                    }
                }
            }
        }
    }
}

/**
 * 文件夹访问视图
 */
@Composable
fun FolderAccessView(
    currentMod: ModContent?,
    onModLoaded: (ModContent) -> Unit
) {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(16.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        Card(
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp)
        ) {
            Column(
                modifier = Modifier.padding(24.dp),
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                Icon(
                    imageVector = Icons.Default.FolderOpen,
                    contentDescription = null,
                    modifier = Modifier.size(64.dp),
                    tint = MaterialTheme.colorScheme.primary
                )
                
                Spacer(modifier = Modifier.height(16.dp))
                
                Text(
                    text = "访问模组文件夹",
                    style = MaterialTheme.typography.headlineSmall
                )
                
                Spacer(modifier = Modifier.height(8.dp))
                
                Text(
                    text = "直接访问包含模组文件的文件夹",
                    style = MaterialTheme.typography.bodyMedium,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
                
                Spacer(modifier = Modifier.height(24.dp))
                
                Button(
                    onClick = { /* TODO: 打开文件夹选择器 */ }
                ) {
                    Icon(Icons.Default.FolderOpen, contentDescription = null)
                    Spacer(modifier = Modifier.width(8.dp))
                    Text("选择文件夹")
                }
            }
        }
    }
}

/**
 * 模组生成视图
 */
@Composable
fun GeneratorView(
    onModGenerated: (ModContent) -> Unit
) {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(16.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        Card(
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp)
        ) {
            Column(
                modifier = Modifier.padding(24.dp),
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                Icon(
                    imageVector = Icons.Default.Create,
                    contentDescription = null,
                    modifier = Modifier.size(64.dp),
                    tint = MaterialTheme.colorScheme.primary
                )
                
                Spacer(modifier = Modifier.height(16.dp))
                
                Text(
                    text = "创建新模组",
                    style = MaterialTheme.typography.headlineSmall
                )
                
                Spacer(modifier = Modifier.height(8.dp))
                
                Text(
                    text = "从头开始创建新的模组内容",
                    style = MaterialTheme.typography.bodyMedium,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
                
                Spacer(modifier = Modifier.height(24.dp))
                
                Button(
                    onClick = { /* TODO: 打开模组生成器 */ }
                ) {
                    Icon(Icons.Default.Create, contentDescription = null)
                    Spacer(modifier = Modifier.width(8.dp))
                    Text("开始创建")
                }
            }
        }
    }
}

/**
 * 模组编辑器视图
 */
@Composable
fun ModEditorView(
    modContent: ModContent,
    onModChanged: (ModContent) -> Unit
) {
    // TODO: 实现模组编辑器
    Text("模组编辑器 - 开发中")
}