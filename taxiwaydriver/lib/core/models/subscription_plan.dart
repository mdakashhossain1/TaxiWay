class SubscriptionPlan {
  final int id;
  final double pricePerMonth;
  final int totalRides;
  final int usedRides;
  final DateTime renewalDate;

  const SubscriptionPlan({
    required this.id,
    required this.pricePerMonth,
    required this.totalRides,
    required this.usedRides,
    required this.renewalDate,
  });

  int get remainingRides => totalRides - usedRides;
  double get usageFraction => totalRides == 0 ? 0 : usedRides / totalRides;

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    final plan = json['plan'] as Map<String, dynamic>;
    return SubscriptionPlan(
      id: json['id'] as int,
      pricePerMonth: double.parse(plan['price_per_month'].toString()),
      totalRides: plan['rides_included'] as int,
      usedRides: json['rides_used'] as int,
      renewalDate: DateTime.parse(json['renewal_date'] as String),
    );
  }
}

class PaymentSummary {
  final double thisMonthCollected;
  final int completedRides;
  final double todayCollected;
  final double pendingPayment;

  const PaymentSummary({
    required this.thisMonthCollected,
    required this.completedRides,
    required this.todayCollected,
    required this.pendingPayment,
  });

  factory PaymentSummary.fromJson(Map<String, dynamic> json) {
    return PaymentSummary(
      thisMonthCollected: double.parse(json['this_month_collected'].toString()),
      completedRides: json['completed_rides'] as int,
      todayCollected: double.parse(json['today_collected'].toString()),
      pendingPayment: double.parse(json['pending_payment'].toString()),
    );
  }
}

class PaymentHistoryEntry {
  final double lastPayment;
  final DateTime? paidOn;
  final DateTime? nextRenewal;
  final String paymentMethod;

  const PaymentHistoryEntry({
    required this.lastPayment,
    required this.paidOn,
    required this.nextRenewal,
    required this.paymentMethod,
  });

  static const empty = PaymentHistoryEntry(lastPayment: 0, paidOn: null, nextRenewal: null, paymentMethod: '—');

  factory PaymentHistoryEntry.fromJson(Map<String, dynamic>? json) {
    if (json == null) return empty;
    return PaymentHistoryEntry(
      lastPayment: double.parse(json['amount'].toString()),
      paidOn: DateTime.parse(json['paid_on'] as String),
      nextRenewal: DateTime.parse(json['next_renewal'] as String),
      paymentMethod: json['payment_method'] as String,
    );
  }
}
