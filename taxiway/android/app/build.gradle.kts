import java.util.Properties

plugins {
    id("com.android.application")
    // AGP 9+ has built-in Kotlin support; the separate kotlin-android plugin
    // is no longer applied (https://kotl.in/gradle/agp-built-in-kotlin).
    // The Flutter Gradle Plugin must be applied after the Android plugin.
    id("dev.flutter.flutter-gradle-plugin")
    // Requires android/app/google-services.json (from the Firebase console)
    // to be present, or the build fails at configuration time.
    id("com.google.gms.google-services")
}

// Google Maps API key, kept out of source control in local.properties
// (gitignored) and injected into the manifest as a placeholder.
val localProperties = Properties().apply {
    val file = rootProject.file("local.properties")
    if (file.exists()) file.inputStream().use { load(it) }
}
val mapsApiKey: String = localProperties.getProperty("maps.apiKey") ?: ""

android {
    namespace = "com.taxiway.user.arknox"
    // flutter_secure_storage now hard-requires compileSdk 37 (AAR metadata
    // check). Installed as android-37.1; AGP 9.3.2 resolves the bare "37"
    // to the latest installed 37.x revision.
    compileSdk = 37
    // Pinned instead of flutter.ndkVersion (resolves to 25.0.2, not
    // installed locally) — 28.2.13676358 is the installed NDK.
    ndkVersion = "28.2.13676358"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.taxiway.user.arknox"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        manifestPlaceholders["mapsApiKey"] = mapsApiKey
    }

    // Builds the native library that hands the HMAC client secret to Dart
    // via NativeSecrets.kt + MethodChannel — see src/main/cpp/native_secrets.cpp.
    externalNativeBuild {
        cmake {
            path = file("src/main/cpp/CMakeLists.txt")
        }
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

// Configures the "kotlin" extension AGP 9's built-in Kotlin support already
// registers (not re-applying the plugin) — needed because its default JVM
// target (21) otherwise mismatches compileOptions' Java 17.
kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
