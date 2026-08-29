import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'api_config.dart';
import 'native_secrets.dart';

class SignedHeaders {
  final String clientId;
  final String timestamp;
  final String nonce;
  final String signature;

  const SignedHeaders({required this.clientId, required this.timestamp, required this.nonce, required this.signature});

  Map<String, String> toHeaders() => {
        'X-Client-Id': clientId,
        'X-Timestamp': timestamp,
        'X-Nonce': nonce,
        'X-Signature': signature,
      };
}

/// Computes the same HMAC-SHA256 signature the backend's
/// VerifyHmacSignature middleware checks: "METHOD|PATH|TIMESTAMP|NONCE|BODY".
class HmacSigner {
  static final _random = Random.secure();

  static SignedHeaders sign({required String method, required String path, required String body}) {
    final timestamp = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
    final nonce = _generateNonce();

    final payload = '$method|$path|$timestamp|$nonce|$body';
    final signature = Hmac(sha256, utf8.encode(NativeSecrets.secret)).convert(utf8.encode(payload)).toString();

    return SignedHeaders(clientId: kApiClientKey, timestamp: timestamp, nonce: nonce, signature: signature);
  }

  static String _generateNonce() {
    final bytes = List<int>.generate(16, (_) => _random.nextInt(256));
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }
}
