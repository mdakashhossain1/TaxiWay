enum VerificationStatus { verified, pending, suspended }

class DriverProfile {
  final String id;
  final String name;
  final String phone;
  final VerificationStatus verificationStatus;

  const DriverProfile({
    required this.id,
    required this.name,
    required this.phone,
    required this.verificationStatus,
  });

  factory DriverProfile.fromJson(Map<String, dynamic> json) {
    return DriverProfile(
      id: json['id'].toString(),
      name: json['name'] as String,
      // Null right after a Google sign-in whose account has no phone linked
      // yet — the driver hasn't gone through phone verification.
      phone: json['phone'] as String? ?? '',
      verificationStatus: VerificationStatus.values.byName(json['verification_status'] as String),
    );
  }
}
