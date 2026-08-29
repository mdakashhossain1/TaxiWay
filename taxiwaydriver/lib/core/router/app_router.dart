import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/otp_verification_screen.dart';
import '../../features/auth/presentation/screens/phone_login_screen.dart';
import '../../features/auth/presentation/screens/verification_status_screen.dart';
import '../../features/chat/presentation/screens/chat_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/rides/presentation/screens/incoming_ride_offer_screen.dart';
import '../../features/rides/presentation/screens/my_rides_screen.dart';
import '../../features/rides/presentation/screens/ride_details_screen.dart';
import '../../features/subscription/presentation/screens/subscription_screen.dart';
import '../models/driver_ride.dart';

/// Lets code outside the widget tree (the push-notification handler) reach a
/// [BuildContext] — e.g. to show an [AppToast] when a message arrives while
/// the app is already running. Navigation itself doesn't need this, since
/// `appRouter` below is a top-level singleton — `GoRouter.push`/`go` work
/// without a context.
final rootNavigatorKey = GlobalKey<NavigatorState>();

abstract class AppRoutes {
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const otp = '/otp';
  static const verificationStatus = '/verification-status';
  static const dashboard = '/dashboard';
  static const myRides = '/my-rides';
  static const rideDetails = '/ride-details';
  static const rideOffer = '/ride-offer';
  static const subscription = '/subscription';
  static const chat = '/chat';
}

/// Native hardware-accelerated sliding page transition, matching taxiway.
Page<void> _page(GoRouterState state, Widget child) {
  return CupertinoPage<void>(key: state.pageKey, child: child);
}

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: AppRoutes.login,
  routes: [
    GoRoute(path: AppRoutes.onboarding, pageBuilder: (context, state) => _page(state, const DriverOnboardingScreen())),
    GoRoute(path: AppRoutes.login, pageBuilder: (context, state) => _page(state, const PhoneLoginScreen())),
    GoRoute(path: AppRoutes.otp, pageBuilder: (context, state) => _page(state, const OtpVerificationScreen())),
    GoRoute(
      path: AppRoutes.verificationStatus,
      pageBuilder: (context, state) => _page(state, const VerificationStatusScreen()),
    ),
    GoRoute(path: AppRoutes.dashboard, pageBuilder: (context, state) => _page(state, const DashboardScreen())),
    GoRoute(path: AppRoutes.myRides, pageBuilder: (context, state) => _page(state, const MyRidesScreen())),
    GoRoute(
      path: AppRoutes.rideDetails,
      pageBuilder: (context, state) => _page(state, RideDetailsScreen(ride: state.extra as DriverRide)),
    ),
    GoRoute(
      path: AppRoutes.rideOffer,
      pageBuilder: (context, state) => _page(state, IncomingRideOfferScreen(ride: state.extra as DriverRide)),
    ),
    GoRoute(path: AppRoutes.subscription, pageBuilder: (context, state) => _page(state, const SubscriptionScreen())),
    GoRoute(
      path: AppRoutes.chat,
      pageBuilder: (context, state) {
        final args = state.extra as ChatScreenArgs;
        return _page(state, ChatScreen(title: args.title, conversationId: args.conversationId));
      },
    ),
  ],
);
