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
        0xc0, 0x72, 0xc2, 0x0b, 0xe7, 0xef, 0xf7, 0x1d, 0x10, 0xcc, 0x5e, 0x7f, 0x72, 0x0e, 0x74, 0x53
    };
    const unsigned char kCipher[] = {
        0x81, 0x1c, 0x8a, 0x58, 0x9f, 0xb7, 0xce, 0x5e, 0x79, 0x98, 0x3d, 0x46, 0x26, 0x42, 0x44, 0x37,
        0xa9, 0x20, 0x88, 0x71, 0x89, 0xa7, 0xb6, 0x2d, 0x43, 0x94, 0x0d, 0x36, 0x1c, 0x63, 0x0e, 0x15,
        0xa3, 0x1e, 0x95, 0x48, 0x95, 0xa8, 0x8e, 0x68, 0x64, 0x9c, 0x29, 0x46, 0x44, 0x77, 0x20, 0x3c,
        0xf3, 0x16, 0x81, 0x65, 0x81, 0xba, 0x80, 0x72, 0x29, 0xa4, 0x0c, 0x11, 0x03, 0x7f, 0x3d, 0x00
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
Java_com_taxiway_user_arknox_NativeSecrets_getApiClientSecret(JNIEnv *env, jobject /* thiz */) {
    std::string secret = decode();
    return env->NewStringUTF(secret.c_str());
}
