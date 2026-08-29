pluginManagement {
    val flutterSdkPath =
        run {
            val properties = java.util.Properties()
            file("local.properties").inputStream().use { properties.load(it) }
            val flutterSdkPath = properties.getProperty("flutter.sdk")
            require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
            flutterSdkPath
        }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "9.3.2" apply false
    // AGP 9+ has built-in Kotlin support; org.jetbrains.kotlin.android is no
    // longer applied per-module (https://kotl.in/gradle/agp-built-in-kotlin).
    // Declaring it here (apply false) only pins the Kotlin version AGP's
    // built-in support uses — required because Flutter's Gradle plugin now
    // needs Kotlin >=2.2.20, newer than AGP 9.3.2's built-in default.
    id("org.jetbrains.kotlin.android") version "2.3.20" apply false
    // Processes android/app/google-services.json for Firebase (Google Sign-In).
    id("com.google.gms.google-services") version "4.4.2" apply false
    // Uploads native crash symbols / mapping files to Firebase Crashlytics.
    id("com.google.firebase.crashlytics") version "3.0.8" apply false
}

include(":app")
