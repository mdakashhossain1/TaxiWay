enum VehicleMediaCategory { exterior, interior, dashboard, boot }

enum VehicleMediaType { photo, video }

class VehicleMedia {
  final String id;
  final VehicleMediaType type;
  final VehicleMediaCategory category;
  final String label;
  final Duration? videoDuration;

  const VehicleMedia({
    required this.id,
    required this.type,
    required this.category,
    required this.label,
    this.videoDuration,
  });

  factory VehicleMedia.fromJson(Map<String, dynamic> json) {
    final categoryStr = json['category'] as String;
    return VehicleMedia(
      id: json['id'].toString(),
      type: json['type'] == 'video' ? VehicleMediaType.video : VehicleMediaType.photo,
      category: _mapCategory(categoryStr),
      label: _labelFor(categoryStr),
    );
  }

  static VehicleMediaCategory _mapCategory(String raw) {
    switch (raw) {
      case 'interior':
        return VehicleMediaCategory.interior;
      case 'dashboard':
        return VehicleMediaCategory.dashboard;
      case 'boot':
        return VehicleMediaCategory.boot;
      default:
        // exterior/front/rear/left/right are all exterior shots.
        return VehicleMediaCategory.exterior;
    }
  }

  static String _labelFor(String raw) {
    switch (raw) {
      case 'front':
        return 'Front';
      case 'rear':
        return 'Rear';
      case 'left':
        return 'Left Side';
      case 'right':
        return 'Right Side';
      default:
        return raw[0].toUpperCase() + raw.substring(1);
    }
  }
}

class Vehicle {
  final String id;
  final String model;
  final String registrationNumber;
  final String category;
  final int seats;
  final bool ac;
  final String fuelType;
  final bool nonSmoking;
  final bool gps;
  final List<VehicleMedia> media;

  const Vehicle({
    required this.id,
    required this.model,
    required this.registrationNumber,
    required this.category,
    required this.seats,
    required this.ac,
    required this.fuelType,
    required this.nonSmoking,
    required this.gps,
    required this.media,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json, {required String categoryName, int seats = 4, bool ac = true}) {
    return Vehicle(
      id: json['id'].toString(),
      model: json['make_model'] as String,
      registrationNumber: json['plate_number'] as String,
      category: categoryName,
      seats: seats,
      ac: ac,
      fuelType: (json['fuel_type'] as String? ?? 'Petrol'),
      nonSmoking: json['non_smoking'] as bool? ?? true,
      gps: json['gps_enabled'] as bool? ?? true,
      media: (json['media'] as List?)?.map((e) => VehicleMedia.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
    );
  }
}
