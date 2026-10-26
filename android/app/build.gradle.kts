plugins {
    id("com.android.application")
    id("com.google.gms.google-services")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "app.sheeplink.sheeplink"
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    defaultConfig {
        applicationId = "app.sheeplink.sheeplink"
        minSdk = 24
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            val path = System.getenv("SHEEPLINK_STORE_FILE")
            if (path != null) {
                storeFile = file(path)
                storePassword = System.getenv("SHEEPLINK_STORE_PASSWORD")
                keyAlias = System.getenv("SHEEPLINK_KEY_ALIAS")
                keyPassword = System.getenv("SHEEPLINK_KEY_PASSWORD")
            }
        }
    }
    buildTypes {
        release { signingConfig = signingConfigs.getByName("release") }
    }

}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

dependencies { coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5") }
