package com.taxiway.driver.arknox

/** JNI bridge to native_secrets.cpp — see that file for why the secret lives here instead of in Dart. */
object NativeSecrets {
    init {
        System.loadLibrary("native_secrets")
    }

    external fun getApiClientSecret(): String
}
