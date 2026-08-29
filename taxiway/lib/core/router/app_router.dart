import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/language_select_screen.dart';
import '../../features/auth/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/otp_verification_screen.dart';
import '../../features/auth/presentation/screens/phone_login_screen.dart';
import '../../features/auth/presentation/screens/profile_setup_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/booking/presentation/screens/booking_confirmed_screen.dart';
import '../../features/booking/presentation/screens/booking_processing_screen.dart';
import '../../features/booking/presentation/screens/booking_review_screen.dart';
import '../../features/booking/presentation/screens/destination_search_screen.dart';
import '../../features/booking/presentation/screens/home_screen.dart';
import '../../features/booking/presentation/screens/pickup_search_screen.dart';
import '../../features/bulk_booking/presentation/screens/bulk_additional_requirements_screen.dart';
import '../../features/bulk_booking/presentation/screens/bulk_booking_confirmed_screen.dart';
import '../../features/bulk_booking/presentation/screens/bulk_offer_details_screen.dart';
import '../../features/bulk_booking/presentation/screens/bulk_offers_received_screen.dart';
import '../../features/bulk_booking/presentation/screens/bulk_request_details_screen.dart';
import '../../features/bulk_booking/presentation/screens/bulk_request_submitted_screen.dart';
import '../../features/bulk_booking/presentation/screens/bulk_review_request_screen.dart';
import '../../features/bulk_booking/presentation/screens/bulk_trip_capacity_screen.dart';
import '../../features/chat/presentation/screens/chat_screen.dart';
import '../../features/driver_profile/presentation/screens/driver_vehicle_profile_screen.dart';
import '../../features/driver_profile/presentation/screens/full_driver_profile_screen.dart';
import '../../features/driver_profile/presentation/screens/vehicle_gallery_screen.dart';
import '../../features/profile/presentation/screens/help_support_screen.dart';
import '../../features/profile/presentation/screens/profile_menu_screen.dart';
import '../../features/tracking/presentation/screens/driver_arrived_screen.dart';
import '../../features/tracking/presentation/screens/live_tracking_screen.dart';
import '../../features/tracking/presentation/screens/rating_review_screen.dart';
import '../../features/tracking/presentation/screens/ride_completed_screen.dart';
import '../../features/tracking/presentation/screens/ride_in_progress_screen.dart';
import '../../features/trips/presentation/screens/trip_details_screen.dart';
import '../../features/trips/presentation/screens/trip_history_screen.dart';
import '../models/trip_history_item.dart';

/// Lets code outside the widget tree (the push-notification handler) reach a
/// [BuildContext] — e.g. to show an [AppToast] when a message arrives while
/// the app is already running. Navigation itself doesn't need this, since
/// `appRouter` below is a top-level singleton `GoRouter.push`/`go` work
/// without a context.
final rootNavigatorKey = GlobalKey<NavigatorState>();

abstract class AppRoutes {
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const language = '/language';
  static const login = '/login';
  static const otp = '/otp';
  static const profileSetup = '/profile-setup';
  static const home = '/home';
  static const pickupSearch = '/pickup-search';
  static const destinationSearch = '/destination-search';
  static const bookingReview = '/booking-review';
  static const bookingProcessing = '/booking-processing';
  static const bookingConfirmed = '/booking-confirmed';
  static const driverProfile = '/driver-profile';
  static const vehicleGallery = '/vehicle-gallery';
  static const fullDriverProfile = '/full-driver-profile';
  static const liveTracking = '/live-tracking';
  static const driverArrived = '/driver-arrived';
  static const rideInProgress = '/ride-in-progress';
  static const rideCompleted = '/ride-completed';
  static const ratingReview = '/rating-review';
  static const tripHistory = '/trip-history';
  static const tripDetails = '/trip-details';
  static const profileMenu = '/profile-menu';
  static const helpSupport = '/help-support';
  static const chat = '/chat';

  static const bulkTripCapacity = '/bulk/trip-capacity';
  static const bulkAdditionalRequirements = '/bulk/additional-requirements';
  static const bulkReviewRequest = '/bulk/review-request';
  static const bulkRequestSubmitted = '/bulk/request-submitted';
  static const bulkRequestDetails = '/bulk/request-details';
  static const bulkOffersReceived = '/bulk/offers-received';
  static const bulkOfferDetails = '/bulk/offer-details';
  static const bulkBookingConfirmed = '/bulk/booking-confirmed';
}

/// Ultra-smooth native hardware-accelerated sliding page transitions.
/// Features natural spring physics, parallax depth shadow, and edge swipe-back gesture.
Page<void> _page(GoRouterState state, Widget child) {
  return CupertinoPage<void>(
    key: state.pageKey,
    child: child,
  );
}

/// Ultra-smooth bottom-up slide transition for modals & search screens.
Page<void> _modalPage(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 280),
    reverseTransitionDuration: const Duration(milliseconds: 240),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.fastEaseInToSlowEaseOut,
        reverseCurve: Curves.fastOutSlowIn,
      );

      final slide = Tween<Offset>(
        begin: const Offset(0.0, 0.15),
        end: Offset.zero,
      ).animate(curvedAnimation);

      final fade = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(curvedAnimation);

      return FadeTransition(
        opacity: fade,
        child: SlideTransition(
          position: slide,
          child: child,
        ),
      );
    },
  );
}

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: AppRoutes.language,
  routes: [
    GoRoute(path: AppRoutes.language, pageBuilder: (context, state) => _page(state, const LanguageSelectScreen())),
    GoRoute(path: AppRoutes.splash, pageBuilder: (context, state) => _page(state, const SplashScreen())),
    GoRoute(path: AppRoutes.onboarding, pageBuilder: (context, state) => _page(state, const OnboardingScreen())),
    GoRoute(path: AppRoutes.login, pageBuilder: (context, state) => _page(state, const PhoneLoginScreen())),
    GoRoute(path: AppRoutes.otp, pageBuilder: (context, state) => _page(state, const OtpVerificationScreen())),
    GoRoute(path: AppRoutes.profileSetup, pageBuilder: (context, state) => _page(state, const ProfileSetupScreen())),
    GoRoute(path: AppRoutes.home, pageBuilder: (context, state) => _page(state, const HomeScreen())),
    GoRoute(path: AppRoutes.pickupSearch, pageBuilder: (context, state) => _modalPage(state, const PickupSearchScreen())),
    GoRoute(
      path: AppRoutes.destinationSearch,
      pageBuilder: (context, state) => _modalPage(state, const DestinationSearchScreen()),
    ),
    GoRoute(path: AppRoutes.bookingReview, pageBuilder: (context, state) => _modalPage(state, const BookingReviewScreen())),
    GoRoute(
      path: AppRoutes.bookingProcessing,
      pageBuilder: (context, state) => _page(state, const BookingProcessingScreen()),
    ),
    GoRoute(
      path: AppRoutes.bookingConfirmed,
      pageBuilder: (context, state) => _page(state, const BookingConfirmedScreen()),
    ),
    GoRoute(
      path: AppRoutes.driverProfile,
      pageBuilder: (context, state) => _page(state, const DriverVehicleProfileScreen()),
    ),
    GoRoute(path: AppRoutes.vehicleGallery, pageBuilder: (context, state) => _page(state, const VehicleGalleryScreen())),
    GoRoute(
      path: AppRoutes.fullDriverProfile,
      pageBuilder: (context, state) => _page(state, const FullDriverProfileScreen()),
    ),
    GoRoute(path: AppRoutes.liveTracking, pageBuilder: (context, state) => _page(state, const LiveTrackingScreen())),
    GoRoute(path: AppRoutes.driverArrived, pageBuilder: (context, state) => _page(state, const DriverArrivedScreen())),
    GoRoute(path: AppRoutes.rideInProgress, pageBuilder: (context, state) => _page(state, const RideInProgressScreen())),
    GoRoute(path: AppRoutes.rideCompleted, pageBuilder: (context, state) => _page(state, const RideCompletedScreen())),
    GoRoute(path: AppRoutes.ratingReview, pageBuilder: (context, state) => _page(state, const RatingReviewScreen())),
    GoRoute(path: AppRoutes.tripHistory, pageBuilder: (context, state) => _page(state, const TripHistoryScreen())),
    GoRoute(
      path: AppRoutes.tripDetails,
      pageBuilder: (context, state) => _page(state, TripDetailsScreen(item: state.extra as TripHistoryItem)),
    ),
    GoRoute(path: AppRoutes.profileMenu, pageBuilder: (context, state) => _page(state, const ProfileMenuScreen())),
    GoRoute(path: AppRoutes.helpSupport, pageBuilder: (context, state) => _page(state, const HelpSupportScreen())),
    GoRoute(
      path: AppRoutes.chat,
      pageBuilder: (context, state) {
        final args = state.extra as ChatScreenArgs;
        return _page(state, ChatScreen(title: args.title, conversationId: args.conversationId));
      },
    ),
    GoRoute(
      path: AppRoutes.bulkTripCapacity,
      pageBuilder: (context, state) => _page(state, const BulkTripCapacityScreen()),
    ),
    GoRoute(
      path: AppRoutes.bulkAdditionalRequirements,
      pageBuilder: (context, state) => _page(state, const BulkAdditionalRequirementsScreen()),
    ),
    GoRoute(
      path: AppRoutes.bulkReviewRequest,
      pageBuilder: (context, state) => _page(state, const BulkReviewRequestScreen()),
    ),
    GoRoute(
      path: AppRoutes.bulkRequestSubmitted,
      pageBuilder: (context, state) => _page(state, const BulkRequestSubmittedScreen()),
    ),
    GoRoute(
      path: AppRoutes.bulkRequestDetails,
      pageBuilder: (context, state) => _page(state, const BulkRequestDetailsScreen()),
    ),
    GoRoute(
      path: AppRoutes.bulkOffersReceived,
      pageBuilder: (context, state) => _page(state, const BulkOffersReceivedScreen()),
    ),
    GoRoute(
      path: AppRoutes.bulkOfferDetails,
      pageBuilder: (context, state) => _page(state, const BulkOfferDetailsScreen()),
    ),
    GoRoute(
      path: AppRoutes.bulkBookingConfirmed,
      pageBuilder: (context, state) => _page(state, const BulkBookingConfirmedScreen()),
    ),
  ],
);
