import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/api_client.dart';

abstract class AppConfigRepository {
  /// The admin-configured support number "Call Office / Support" dials —
  /// null if the admin hasn't set one yet.
  Future<String?> getSupportContactNumber();
}

class ApiAppConfigRepositoryImpl implements AppConfigRepository {
  @override
  Future<String?> getSupportContactNumber() async {
    final response = await ApiClient.instance.get('/app-config', auth: false);
    final data = response['data'] as Map<String, dynamic>?;
    return data?['support_contact_number'] as String?;
  }
}

final appConfigRepositoryProvider = Provider<AppConfigRepository>((ref) => ApiAppConfigRepositoryImpl());
