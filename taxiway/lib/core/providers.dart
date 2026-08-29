import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'data/app_config_repository.dart';
import 'data/auth_repository.dart';
import 'data/chat_repository.dart';
import 'data/bulk_offer_repository.dart';
import 'data/place_repository.dart';
import 'data/review_repository.dart';
import 'data/vehicle_repository.dart';
import 'models/booking.dart';
import 'models/driver.dart';
import 'models/review.dart';
import 'models/trip_history_item.dart';
import 'models/vehicle.dart';
import 'models/vehicle_category.dart';
import 'state/auth_controller.dart';
import 'state/booking_controller.dart';
import 'state/booking_draft_controller.dart';
import 'state/bulk_booking_controller.dart';
import 'state/bulk_booking_draft_controller.dart';
import 'state/trip_history_controller.dart';

// Repositories — swap the implementation here to point at a real backend.
final authRepositoryProvider = Provider<AuthRepository>((ref) => ApiAuthRepository());
final placeRepositoryProvider = Provider<PlaceRepository>((ref) => MockPlaceRepository());
final vehicleRepositoryProvider = Provider<VehicleRepository>((ref) => ApiVehicleRepository());
final reviewRepositoryProvider = Provider<ReviewRepository>((ref) => ApiReviewRepository());
final appConfigRepositoryProvider = Provider<AppConfigRepository>((ref) => ApiAppConfigRepository());
final chatRepositoryProvider = Provider<ChatRepository>((ref) => FirebaseChatRepository());

// No backend admin tooling exists yet to build real bulk-booking offers
// (see the admin backend's scope notes), so this stays mocked — there is
// nothing real on the other end to receive a submitted request yet.
final bulkOfferRepositoryProvider = Provider<BulkOfferRepository>((ref) => MockBulkOfferRepository());

// Controllers (Riverpod 3 — NotifierProvider replaces StateNotifierProvider)
final authControllerProvider = NotifierProvider<AuthController, AuthState>(
  () => AuthController(ApiAuthRepository()),
);

final bookingDraftControllerProvider = NotifierProvider<BookingDraftController, BookingDraft>(
  () => BookingDraftController(MockPlaceRepository(), ApiVehicleRepository()),
);

final bookingControllerProvider = NotifierProvider<BookingController, Booking?>(BookingController.new);

final tripHistoryControllerProvider = AsyncNotifierProvider<TripHistoryController, List<TripHistoryItem>>(
  TripHistoryController.new,
);

final bulkBookingDraftControllerProvider = NotifierProvider<BulkBookingDraftController, BulkBookingDraft>(
  BulkBookingDraftController.new,
);

final bulkBookingControllerProvider = NotifierProvider<BulkBookingController, BulkBookingState>(
  () => BulkBookingController(MockBulkOfferRepository()),
);

// Simple derived/data providers
final vehicleCategoriesProvider = FutureProvider<List<VehicleCategory>>(
  (ref) => ref.watch(vehicleRepositoryProvider).getCategories(),
);

/// The driver/vehicle allocated to the active booking. Falls back to a
/// placeholder only for the (dev-only) edge case of a screen being reached
/// with no active booking — every real navigation path only shows
/// driver/vehicle-dependent screens once a booking has been assigned.
final currentDriverProvider = Provider<Driver>((ref) {
  return ref.watch(bookingControllerProvider)?.driver ?? _placeholderDriver;
});

final currentVehicleProvider = Provider<Vehicle>((ref) {
  return ref.watch(bookingControllerProvider)?.vehicle ?? _placeholderVehicle;
});

final reviewsProvider = Provider<List<Review>>((ref) => ref.watch(currentDriverProvider).reviews);

final ratingDistributionProvider = Provider<RatingDistribution>(
  (ref) => RatingDistribution.fromReviews(ref.watch(reviewsProvider)),
);

const _placeholderDriver = Driver(
  id: '',
  name: '—',
  photoUrl: '',
  rating: 0,
  totalTrips: 0,
  completionRate: 0,
  yearsExperience: 0,
  identityVerified: false,
  licenceVerified: false,
  backgroundChecked: false,
  phone: '',
  languages: [],
  operatingArea: '',
  memberSince: '',
);

const _placeholderVehicle = Vehicle(
  id: '',
  model: '—',
  registrationNumber: '',
  category: '',
  seats: 0,
  ac: false,
  fuelType: '',
  nonSmoking: false,
  gps: false,
  media: [],
);
