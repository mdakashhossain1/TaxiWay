class PlaceLocation {
  final double latitude;
  final double longitude;
  final String address;
  final String? landmark;

  const PlaceLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
    this.landmark,
  });

  /// Short label used in cards (first segment before the comma).
  String get shortName => address.split(',').first.trim();

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
        'address': address,
        'landmark': landmark,
      };

  factory PlaceLocation.fromJson(Map<String, dynamic> json) => PlaceLocation(
        latitude: (json['latitude'] as num).toDouble(),
        longitude: (json['longitude'] as num).toDouble(),
        address: json['address'] as String,
        landmark: json['landmark'] as String?,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlaceLocation &&
          runtimeType == other.runtimeType &&
          address == other.address &&
          (latitude - other.latitude).abs() < 0.0001 &&
          (longitude - other.longitude).abs() < 0.0001;

  @override
  int get hashCode => address.hashCode ^ latitude.hashCode ^ longitude.hashCode;
}
