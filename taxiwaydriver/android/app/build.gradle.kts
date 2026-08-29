plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    // Requires android/app/google-services.json (from the Firebase console)
    // to be present, or the build fails at configuration time.
    id("com.google.gms.google-services")
    // Uploads mapping/symbol files so Crashlytics can deobfuscate stack traces.
    id("com.google.firebase.crashlytics")
}

android {
    namespace = "com.taxiway.driver.arknox"
    // flutter_secure_storage hard-requires compileSdk 37 (AAR metadata check).
    compileSdk = 37
    // Pinned instead of flutter.ndkVersion (resolves to 25.0.2, not
    // installed locally) — 28.2.13676358 is the installed NDK. Matches
    // taxiway's pin; only mattered once externalNativeBuild below made this
    // app actually need to resolve an NDK.
    ndkVersion = "28.2.13676358"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.taxiway.driver.arknox"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        // Uses the version code from pubspec.yaml. When using split APKs, 1000 * ABI_VERSION
        // is added automatically by Flutter. (https://developer.android.com/studio/build/configure-apk-splits#configure-APK-versions)
        // You can force using the value of versionCode by specifying the `-P force-version-code-ignoring-abi=true`
        // flag during build.
        versionCode = flutter.versionCode
        versionName = flutter.versionName
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

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
