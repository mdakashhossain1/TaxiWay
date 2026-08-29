#include <jni.h>
#include <string>

// The HMAC client secret, XOR-obfuscated against a key of equal
// unpredictability — neither array is the secret itself, and `strings` on
// the compiled .so won't turn up anything resembling it. Reconstructed only
// at call time, in native code, so it never exists as a Dart string constant
// inside the (much more easily decompiled) AOT snapshot either.
//
// This is a deterrent against casual static extraction (grep/strings/JADX
// on the APK), not a defense against a targeted attacker instrumenting the
// running app (Frida can still hook this function and read its return
// value). The real fix for that is server-side app-authenticity attestation
// (Play Integrity API) instead of any embedded secret — see the comment in
// lib/core/api/api_config.dart.
namespace {
    const unsigned char kKey[] = {
        0xb5, 0xd0, 0x4b, 0x7d, 0x49, 0xc4, 0x41, 0x36, 0x12, 0x47, 0x0e, 0x97, 0xe8, 0x54, 0x26, 0x07
    };
    const unsigned char kCipher[] = {
        0xe2, 0xe2, 0x3d, 0x48, 0x2a, 0xb6, 0x2c, 0x41, 0x22, 0x7e, 0x77, 0xf0, 0x8f, 0x36, 0x4a, 0x6a,
        0xe5, 0x88, 0x23, 0x07, 0x2a, 0x86, 0x08, 0x6f, 0x57, 0x30, 0x7f, 0xe0, 0xa0, 0x1a, 0x6b, 0x43,
        0x83, 0x81, 0x1b, 0x0e, 0x00, 0x82, 0x75, 0x50, 0x20, 0x01, 0x7e, 0xe6, 0x82, 0x19, 0x67, 0x5d,
        0xfa, 0xe3, 0x2f, 0x08, 0x7b, 0xb0, 0x78, 0x53, 0x5b, 0x0b, 0x6d, 0xff, 0x8d, 0x64, 0x4c, 0x4e
    };

    std::string decode() {
        std::string out;
        out.reserve(sizeof(kCipher));
        for (size_t i = 0; i < sizeof(kCipher); ++i) {
            out.push_back(static_cast<char>(kCipher[i] ^ kKey[i % sizeof(kKey)]));
        }
        return out;
    }
}

extern "C"
JNIEXPORT jstring JNICALL
Java_com_taxiway_driver_arknox_NativeSecrets_getApiClientSecret(JNIEnv *env, jobject /* thiz */) {
    std::string secret = decode();
    return env->NewStringUTF(secret.c_str());
}
