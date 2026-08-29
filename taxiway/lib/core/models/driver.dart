import 'review.dart';

class Driver {
  final String id;
  final String name;
  final String photoUrl;
  final double rating;
  final int totalTrips;
  final int completionRate;
  final double yearsExperience;
  final bool identityVerified;
  final bool licenceVerified;
  final bool backgroundChecked;
  final String phone;
  final List<String> languages;
  final String operatingArea;
  final String memberSince;

  /// Populated once, when this driver was fetched for a specific booking
  /// (see Api\Customer\DriverController@show) — empty otherwise.
  final List<Review> reviews;

  const Driver({
    required this.id,
    required this.name,
    required this.photoUrl,
    required this.rating,
    required this.totalTrips,
    required this.completionRate,
    required this.yearsExperience,
    required this.identityVerified,
    required this.licenceVerified,
    required this.backgroundChecked,
    required this.phone,
    required this.languages,
    required this.operatingArea,
    required this.memberSince,
    this.reviews = const [],
  });

  bool get isFullyVerified => identityVerified && licenceVerified && backgroundChecked;

  factory Driver.fromJson(Map<String, dynamic> json) {
    final phone = json['phone'] as String;
    final memberSinceRaw = json['member_since'] as String?;

    return Driver(
      id: json['id'].toString(),
      name: json['name'] as String,
      photoUrl: json['photo_url'] as String? ?? '',
      rating: double.parse(json['rating'].toString()),
      totalTrips: json['total_trips'] as int,
      completionRate: double.parse(json['completion_rate'].toString()).round(),
      yearsExperience: double.parse(json['years_experience'].toString()),
      identityVerified: json['identity_verified'] as bool,
      licenceVerified: json['licence_verified'] as bool,
      backgroundChecked: json['background_checked'] as bool,
      phone: phone.length == 10 ? '+91 ${phone.substring(0, 5)} ${phone.substring(5)}' : phone,
      languages: (json['languages'] as List?)?.map((e) => e.toString()).toList() ?? const [],
      operatingArea: json['operating_area'] as String? ?? '',
      memberSince: memberSinceRaw != null ? DateTime.parse(memberSinceRaw).year.toString() : '',
      reviews: (json['reviews'] as List?)?.map((e) => Review.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
    );
  }
}
