package com.taxiway.user.arknox

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val nativeSecretsChannel = "com.taxiway.user.arknox/native_secrets"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, nativeSecretsChannel).setMethodCallHandler { call, result ->
            when (call.method) {
                "getApiClientSecret" -> result.success(NativeSecrets.getApiClientSecret())
                else -> result.notImplemented()
            }
        }
    }
}
