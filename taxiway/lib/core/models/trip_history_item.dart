import 'booking.dart';

enum TripFilter { all, upcoming, completed, cancelled }

class TripHistoryItem {
  final Booking booking;
  final double? ratingGiven;

  const TripHistoryItem({required this.booking, this.ratingGiven});

  factory TripHistoryItem.fromJson(Map<String, dynamic> json) {
    final review = json['review'] as Map<String, dynamic>?;
    return TripHistoryItem(
      booking: Booking.fromJson(json),
      ratingGiven: review != null ? double.parse(review['rating'].toString()) : null,
    );
  }

  TripFilter get filterBucket {
    switch (booking.status) {
      case BookingStatus.completed:
        return TripFilter.completed;
      case BookingStatus.cancelled:
      case BookingStatus.failed:
        return TripFilter.cancelled;
      default:
        return TripFilter.upcoming;
    }
  }
}
