import '../api/api_client.dart';

abstract class AppConfigRepository {
  /// The admin-configured support number "Contact Support" dials — null if
  /// the admin hasn't set one yet.
  Future<String?> getSupportContactNumber();
}

class ApiAppConfigRepository implements AppConfigRepository {
  @override
  Future<String?> getSupportContactNumber() async {
    final response = await ApiClient.instance.get('/app-config', auth: false);
    final data = response['data'] as Map<String, dynamic>?;
    return data?['support_contact_number'] as String?;
  }
}
