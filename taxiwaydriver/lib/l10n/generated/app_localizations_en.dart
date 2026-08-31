// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Taxiway Driver';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageHindi => 'हिन्दी';

  @override
  String get languageBengali => 'বাংলা';

  @override
  String get languagePickerTitle => 'Choose your language';

  @override
  String get driverLoginTitle => 'Driver Login';

  @override
  String get enterMobileNumber => 'Enter mobile number';

  @override
  String get continueLabel => 'Continue';

  @override
  String get unregisteredNumberError =>
      'This number is not registered as a driver. Please contact the office.';

  @override
  String get verifyMobileNumber => 'Verify Mobile Number';

  @override
  String otpSentTo(String phone) {
    return 'We\'ve sent a 6-digit OTP to +91 $phone';
  }

  @override
  String get otpDemoHint => '(Use 123456 for this demo)';

  @override
  String get loginLabel => 'Login';

  @override
  String get resendOtp => 'Resend OTP';

  @override
  String resendIn(String time) {
    return 'Resend OTP in 00:$time';
  }

  @override
  String get canResendNow => 'You can now resend OTP';

  @override
  String get invalidOtp => 'Invalid OTP. Please try again.';

  @override
  String get verificationPendingTitle => 'Verification Pending';

  @override
  String get verificationPendingMessage =>
      'Please complete your KYC/verification at the Taxiway office or contact support.';

  @override
  String get callOfficeSupport => 'Call Office / Support';

  @override
  String get accountSuspendedTitle => 'Account Temporarily Unavailable';

  @override
  String get accountSuspendedMessage =>
      'Please contact Taxiway support for more information.';

  @override
  String get backToLogin => 'Back to Login';

  @override
  String get driverDashboardTitle => 'Driver Dashboard';

  @override
  String get verifiedDriver => 'Verified Driver';

  @override
  String get currentPlan => 'Current Plan';

  @override
  String ridesIncluded(int count) {
    return '$count Rides Included';
  }

  @override
  String get ridesUsed => 'Rides Used';

  @override
  String get ridesRemaining => 'Rides Remaining';

  @override
  String get renewalDateLabel => 'Renewal Date';

  @override
  String get nextRide => 'Next Ride';

  @override
  String get noUpcomingRides => 'No upcoming rides right now.';

  @override
  String get customerLabel => 'Customer';

  @override
  String get expectedFare => 'Expected Fare';

  @override
  String get viewRideDetails => 'View Ride Details';

  @override
  String get callCustomer => 'Call Customer';

  @override
  String get logout => 'Logout';

  @override
  String get logoutConfirmTitle => 'Log out?';

  @override
  String get logoutConfirmMessage =>
      'You\'ll need to verify your number again to log back in.';

  @override
  String get myRidesTitle => 'My Rides';

  @override
  String get upcomingTab => 'Upcoming';

  @override
  String get completedTab => 'Completed';

  @override
  String get noUpcomingRidesTitle => 'No upcoming rides';

  @override
  String get noCompletedRidesTitle => 'No completed rides yet';

  @override
  String get rideDetailsTitle => 'Ride Details';

  @override
  String get dateLabel => 'Date';

  @override
  String get timeLabel => 'Time';

  @override
  String get pickupLabel => 'Pickup';

  @override
  String get destinationLabel => 'Destination';

  @override
  String get vehicleLabel => 'Vehicle';

  @override
  String get fareLabel => 'Fare';

  @override
  String get paymentStatusLabel => 'Payment Status';

  @override
  String get rideStatusLabel => 'Ride Status';

  @override
  String get openMap => 'Open Map';

  @override
  String get markCompleted => 'Mark Completed';

  @override
  String get markedCompletedToast => 'Ride marked as completed.';

  @override
  String get paid => 'Paid';

  @override
  String get pending => 'Pending';

  @override
  String get subscriptionTitle => 'Subscription & Payments';

  @override
  String get validUntil => 'Valid Until';

  @override
  String get thisMonthCollected => 'This Month Collected';

  @override
  String get completedRidesLabel => 'Completed Rides';

  @override
  String get todayCollected => 'Today Collected';

  @override
  String get pendingPaymentLabel => 'Pending Payment';

  @override
  String get lastPayment => 'Last Payment';

  @override
  String get paidOn => 'Paid On';

  @override
  String get nextRenewal => 'Next Renewal';

  @override
  String get paymentMethodLabel => 'Payment Method';

  @override
  String get renewSubscription => 'Renew Subscription';

  @override
  String get renewedToast => 'Subscription renewed successfully!';

  @override
  String get scheduledTab => 'Scheduled';

  @override
  String get noScheduledRidesTitle => 'No scheduled rides';

  @override
  String get scheduledRideDetailTitle => 'Scheduled Ride';

  @override
  String get openToAllDriversLabel =>
      'Open to all eligible drivers — accept before someone else does.';

  @override
  String get acceptRideLabel => 'Accept Ride';

  @override
  String get declineLabel => 'Decline';

  @override
  String get scheduledRideAcceptedToast =>
      'Ride confirmed! It\'s on your upcoming rides.';

  @override
  String get scheduledRideUnavailableTitle => 'Too Late';

  @override
  String get scheduledRideAcceptFailedMessage =>
      'Couldn\'t accept this ride. Please try again.';

  @override
  String get scheduledRideDeclineFailedMessage =>
      'Couldn\'t decline this ride. Please try again.';

  @override
  String get scheduledRidesAvailableTitle => 'Scheduled rides available';

  @override
  String scheduledRidesAvailableCount(int count) {
    return '$count ride(s) waiting for a driver';
  }

  @override
  String get viewAllLabel => 'View All';
}
