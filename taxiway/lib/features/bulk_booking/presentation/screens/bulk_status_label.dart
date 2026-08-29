import '../../../../core/models/bulk_booking.dart';

String bulkStatusLabel(BulkBookingStatus status) {
  switch (status) {
    case BulkBookingStatus.submitted:
      return 'Submitted';
    case BulkBookingStatus.underReview:
      return 'Under Review';
    case BulkBookingStatus.offerReady:
      return 'Offer Ready';
    case BulkBookingStatus.confirmed:
      return 'Confirmed';
    case BulkBookingStatus.cancelled:
      return 'Cancelled';
  }
}
