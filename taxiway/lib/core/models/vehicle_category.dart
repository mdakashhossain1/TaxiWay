/// A bookable vehicle category (PRD §9 Vehicle Section).
class VehicleCategory {
  final String id;
  final String name;
  final int seats;
  final String useCase;
  final bool ac;
  final double baseFare;
  final double perKmRate;
  final double minimumFare;
  final int etaMinutes;

  /// The backend's numeric primary key — only present for categories loaded
  /// from the real API, needed when creating a booking. Null for anything
  /// still built from a local constant (there are none once wired, but this
  /// keeps the constructor from becoming a breaking change everywhere).
  final int? categoryId;

  const VehicleCategory({
    required this.id,
    required this.name,
    required this.seats,
    required this.useCase,
    required this.ac,
    required this.baseFare,
    required this.perKmRate,
    required this.minimumFare,
    required this.etaMinutes,
    this.categoryId,
  });

  factory VehicleCategory.fromJson(Map<String, dynamic> json) {
    final name = json['name'] as String;
    return VehicleCategory(
      id: name.toLowerCase(),
      name: name,
      seats: json['seats'] as int,
      useCase: _useCaseFor(name),
      ac: json['ac'] as bool,
      baseFare: double.parse(json['base_fare'].toString()),
      perKmRate: double.parse(json['per_km_rate'].toString()),
      // The backend doesn't model a separate fare floor — the base fare
      // already acts as one in practice.
      minimumFare: double.parse(json['base_fare'].toString()),
      etaMinutes: _etaFor(name),
      categoryId: json['id'] as int,
    );
  }

  static String _useCaseFor(String name) {
    switch (name.toLowerCase()) {
      case 'hatchback':
        return 'Affordable, compact rides';
      case 'sedan':
        return 'Comfortable, AC sedans';
      case 'suv':
        return 'Spacious 6-7 seaters';
      case 'traveller':
        return 'Family & group trips';
      default:
        return 'Comfortable rides';
    }
  }

  static int _etaFor(String name) {
    switch (name.toLowerCase()) {
      case 'hatchback':
        return 3;
      case 'sedan':
        return 4;
      case 'suv':
        return 6;
      case 'traveller':
        return 8;
      default:
        return 5;
    }
  }
}
