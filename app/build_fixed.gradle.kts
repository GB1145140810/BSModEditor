plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
}

android {
    namespace = "com.modeditor"
    compileSdk = 33  // 降级到33，避免兼容性问题

    defaultConfig {
        applicationId = "com.modeditor"
        minSdk = 21
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
        buildConfig = false
        aidl = false
        renderScript = false
        shaders = false
        resValues = false
        prefab = false
    }
    
    composeOptions {
        kotlinCompilerExtensionVersion = "1.4.0"
    }
    
    packaging {
        resources {
            excludes += "/META-INF/{AL2.0,LGPL2.1}"
            excludes += "**/attach_hotspot_windows.dll"
            excludes += "**/attach_hotspot_linux.dll"
            excludes += "**/attach_hotspot_mac.dll"
        }
    }
    
    lint {
        abortOnError = false
        checkReleaseBuilds = false
    }
}

dependencies {
    // 核心依赖
    implementation("androidx.core:core-ktx:1.9.0")
    implementation("androidx.lifecycle:lifecycle-runtime-ktx:2.5.1")
    implementation("androidx.activity:activity-compose:1.6.1")
    
    // Jetpack Compose - 使用稳定版本
    implementation(platform("androidx.compose:compose-bom:2022.10.00"))
    implementation("androidx.compose.ui:ui")
    implementation("androidx.compose.ui:ui-graphics")
    implementation("androidx.compose.ui:ui-tooling-preview")
    implementation("androidx.compose.material3:material3:1.0.0")
    
    // ViewModel
    implementation("androidx.lifecycle:lifecycle-viewmodel-compose:2.5.1")
    
    // JSON处理
    implementation("com.google.code.gson:gson:2.10.1")
    
    // 文件操作
    implementation("androidx.documentfile:documentfile:1.0.1")
    
    // 测试
    testImplementation("junit:junit:4.13.2")
    debugImplementation("androidx.compose.ui:ui-tooling")
}