enum NetworkFailureKind { offline, timeout }

class NetworkFailure implements Exception {
  final NetworkFailureKind kind;

  const NetworkFailure(this.kind);

  @override
  String toString() => 'NetworkFailure(${kind.name})';
}
