plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

import java.util.Properties
import java.io.FileInputStream

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")

if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

// Determine whether a full keystore configuration is available.
val hasKeystore = keystorePropertiesFile.exists() &&
        keystoreProperties.getProperty("keyAlias") != null &&
        keystoreProperties.getProperty("keyPassword") != null &&
        keystoreProperties.getProperty("storeFile") != null &&
        keystoreProperties.getProperty("storePassword") != null

android {
    signingConfigs {
        create("release") {
            // Only load signing info if the key.properties file exists and contains values.
            if (keystorePropertiesFile.exists()) {
                val alias = keystoreProperties.getProperty("keyAlias")
                val password = keystoreProperties.getProperty("keyPassword")
                val store = keystoreProperties.getProperty("storeFile")
                val storePwd = keystoreProperties.getProperty("storePassword")

                if (alias != null && password != null && store != null && storePwd != null) {
                    keyAlias = alias
                    keyPassword = password
                    storeFile = file(store)
                    storePassword = storePwd
                } else {
                    // Fall back to debug signing if any property is missing.
                    println("WARNING: key.properties is missing required values; release signing will not be configured.")
                }
            } else {
                println("INFO: key.properties not found; release signing skipped.")
            }
        }
    }
    // Using the desired application package/namespace for this project.
    // Keep `namespace` and `applicationId` aligned with the Kotlin/Java
    // source package so manifest entries like android:name=".MainActivity"
    // resolve correctly.
    namespace = "com.blockcode.itq"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
    // Application ID (package name shown on device / Play Store).
    applicationId = "com.blockcode.itq"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            if (hasKeystore) {
                signingConfig = signingConfigs.getByName("release")
            } else {
                println("INFO: Release keystore not configured; using debug signing for release build.")
                signingConfig = signingConfigs.getByName("debug")
            }
        }
    }
}

flutter {
    source = "../.."
}
