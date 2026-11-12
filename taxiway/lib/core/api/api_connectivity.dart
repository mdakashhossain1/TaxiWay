import 'package:flutter/foundation.dart';

enum NetworkStatus {
  online,
  offline,
  serverError,
  slowConnection,
}

class ApiConnectivity {
  ApiConnectivity._();

  static final ValueNotifier<NetworkStatus> status = ValueNotifier(NetworkStatus.online);
}
