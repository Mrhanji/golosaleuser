import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")

    /// ✅ Firebase
    id("com.google.gms.google-services")

    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.innotechnova.golosaleuser"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11

        /// ✅ Required for flutter_local_notifications
        isCoreLibraryDesugaringEnabled = true
    }

    defaultConfig {
        applicationId = "com.innotechnova.golosaleuser"

        /// ✅ Firebase requirement
        minSdk = flutter.minSdkVersion

        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        /// ✅ Multidex
        multiDexEnabled = true
    }

    signingConfigs {
        create("release") {
            val keyAliasProp = keystoreProperties["keyAlias"] as String?
            val keyPasswordProp = keystoreProperties["keyPassword"] as String?
            val storeFileProp = keystoreProperties["storeFile"] as String?
            val storePasswordProp = keystoreProperties["storePassword"] as String?
            if (storeFileProp != null) {
                keyAlias = keyAliasProp
                keyPassword = keyPasswordProp
                val sf = file(storeFileProp)
                val rootSf = rootProject.file(storeFileProp)
                val resolvedFile = if (sf.exists()) sf else if (rootSf.exists()) rootSf else null
                if (resolvedFile != null) {
                    storeFile = resolvedFile
                    storePassword = storePasswordProp
                }
            }
        }
    }

    buildTypes {
        release {
            val releaseSigning = signingConfigs.findByName("release")
            if (releaseSigning != null && releaseSigning.storeFile != null && releaseSigning.storeFile!!.exists()) {
                signingConfig = releaseSigning
            } else {
                signingConfig = signingConfigs.getByName("debug")
            }
        }
    }
}

/// ✅ Kotlin JVM
kotlin {
    compilerOptions {
        jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_11)
    }
}

flutter {
    source = "../.."
}

/// ✅ Dependencies
dependencies {

    implementation("androidx.multidex:multidex:2.0.1")

    /// ✅ Desugaring
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
