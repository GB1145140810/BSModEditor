plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
}

android {
    namespace = "com.modeditor"
    compileSdk = 33  // 使用稳定版本

    defaultConfig {
        applicationId = "com.modeditor"
        minSdk = 21  // 广泛兼容
        targetSdk = 33
        versionCode = 1
        versionName = "1.0.0"

        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
        vectorDrawables {
            useSupportLibrary = true
        }
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
        
        debug {
            // 调试版本配置
            isDebuggable = true
            isMinifyEnabled = false
        }
    }
    
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }
    
    kotlinOptions {
        jvmTarget = "1.8"
    }
    
    buildFeatures {
        compose = true
        // 禁用不需要的特性
        buildConfig = false
        aidl = false
        renderScript = false
        shaders = false
        resValues = false
        prefab = false
    }
    
    composeOptions {
        kotlinCompilerExtensionVersion = "1.4.0"  // 稳定版本
    }
    
    packaging {
        resources {
            excludes += "/META-INF/{AL2.0,LGPL2.1}"
            // 排除不必要的文件
            excludes += "**/attach_hotspot_windows.dll"
            excludes += "**/attach_hotspot_linux.dll"
            excludes += "**/attach_hotspot_mac.dll"
        }
    }
    
    // 禁用不必要的构建任务
    lint {
        abortOnError = false
        checkReleaseBuilds = false
    }
}

dependencies {
    // 核心依赖 - 最小化
    implementation("androidx.core:core-ktx:1.9.0")
    implementation("androidx.lifecycle:lifecycle-runtime-ktx:2.5.1")
    implementation("androidx.activity:activity-compose:1.6.1")
    
    // Jetpack Compose - 稳定版本
    implementation(platform("androidx.compose:compose-bom:2022.10.00"))
    implementation("androidx.compose.ui:ui")
    implementation("androidx.compose.ui:ui-graphics")
    implementation("androidx.compose.ui:ui-tooling-preview")
    implementation("androidx.compose.material3:material3:1.0.0")
    
    // 仅必要的 ViewModel
    implementation("androidx.lifecycle:lifecycle-viewmodel-compose:2.5.1")
    
    // JSON处理 - 仅核心
    implementation("com.google.code.gson:gson:2.10.1")
    
    // 文件操作 - 最小化
    implementation("androidx.documentfile:documentfile:1.0.1")
    
    // 测试依赖 - 最小化
    testImplementation("junit:junit:4.13.2")
    debugImplementation("androidx.compose.ui:ui-tooling")
}