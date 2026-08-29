import 'package:url_launcher/url_launcher.dart';

Future<void> launchPhoneCall(String phone) async {
  final uri = Uri(scheme: 'tel', path: phone);
  await launchUrl(uri);
}

Future<void> launchMapsDirections({required double destLat, required double destLng}) async {
  final uri = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$destLat,$destLng');
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}
