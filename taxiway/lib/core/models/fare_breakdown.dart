/// Fare estimate (PRD §79 Fare Calculation).
class FareBreakdown {
  final double baseFare;
  final double distanceFare;
  final double timeFare;

  const FareBreakdown({
    required this.baseFare,
    required this.distanceFare,
    required this.timeFare,
  });

  double get total => baseFare + distanceFare + timeFare;

  factory FareBreakdown.fromJson(Map<String, dynamic> json) => FareBreakdown(
        baseFare: double.parse(json['base_fare'].toString()),
        distanceFare: double.parse(json['distance_charge'].toString()),
        timeFare: double.parse(json['time_charge'].toString()),
      );
}
