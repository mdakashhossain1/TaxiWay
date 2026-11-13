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

  @override
  String get paymentSuccessfulTitle => 'Payment successful';

  @override
  String get subscriptionRenewedMessage => 'Your plan has been renewed.';

  @override
  String get amountPaidLabel => 'Amount paid';

  @override
  String get doneLabel => 'Done';

  @override
  String get renewFailedToast => 'Couldn\'t renew right now. Please try again.';

  @override
  String get connectionOfflineTitle => 'No internet connection';

  @override
  String get connectionSlowTitle => 'Slow connection';

  @override
  String get connectionRestoredTitle => 'Back online';

  @override
  String get connectionServerTroubleTitle =>
      'We\'re having trouble reaching our servers';

  @override
  String get connectionRetryAction => 'Retry';

  @override
  String get connectionCheckingAction => 'Checking…';

  @override
  String get errorOfflineTitle => 'You\'re offline';

  @override
  String get errorOfflineMessage =>
      'Check your Wi-Fi or mobile data and try again.';

  @override
  String get errorTimeoutTitle => 'This is taking too long';

  @override
  String get errorTimeoutMessage =>
      'Your connection seems slow. Try again in a moment.';

  @override
  String get errorServerTitle => 'We\'re having trouble on our end';

  @override
  String get errorServerMessage =>
      'This isn\'t your connection. Please try again shortly.';

  @override
  String get errorMaintenanceTitle => 'Back shortly';

  @override
  String get errorMaintenanceMessage =>
      'Taxiway is being updated to serve you better.';

  @override
  String get errorGenericTitle => 'Something went wrong';

  @override
  String get errorGenericMessage => 'We couldn\'t load this. Please try again.';

  @override
  String get tryAgainLabel => 'Try again';

  @override
  String get tryingAgainLabel => 'Trying again…';

  @override
  String get goBackLabel => 'Go back';

  @override
  String get emptyDefaultTitle => 'Nothing here yet';

  @override
  String get emptyDefaultMessage => 'Items will show up here.';

  @override
  String get chatEmptyTitle => 'No messages yet';

  @override
  String get chatEmptyMessage => 'Say hello!';

  @override
  String get chatLoadFailed => 'Couldn\'t load messages';

  @override
  String get messageSendFailed => 'Message didn\'t send. Please try again.';

  @override
  String get otpSendFailed => 'Couldn\'t send the OTP. Please try again.';

  @override
  String get otpResendFailed => 'Couldn\'t resend the OTP. Please try again.';

  @override
  String get otpVerifyFailed => 'Couldn\'t verify the code. Please try again.';

  @override
  String get otpExpired => 'This code has expired. Please request a new one.';

  @override
  String get googleSignInFailed =>
      'Couldn\'t sign in with Google. Please try again.';

  @override
  String get supportNumberMissing => 'Support number isn\'t set up yet.';

  @override
  String get supportUnreachable =>
      'Couldn\'t reach support right now. Please try again.';

  @override
  String get offerUnavailable => 'This offer is no longer available.';

  @override
  String get offerDeclineFailed =>
      'Couldn\'t decline this offer. Please try again.';

  @override
  String get offerAcceptFailed =>
      'Couldn\'t accept this offer. Please try again.';

  @override
  String get rideCompleteFailed =>
      'Couldn\'t mark this ride as completed. Please try again.';

  @override
  String get offerCheckFailed => 'Couldn\'t check for new ride offers';

  @override
  String get acceptedTitle => 'Accepted';

  @override
  String get addPhoneToFinishSetup =>
      'Add your phone number to finish setting up your account.';

  @override
  String get almostThere => 'Almost there';

  @override
  String get autoFillSimNumber => 'Auto-fill SIM number';

  @override
  String get changeLabel => 'Change';

  @override
  String get changePhoneNumber => 'Change Phone Number';

  @override
  String get codeResent => 'Code Resent';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get devModeNoSms => 'Dev Mode — No SMS Gateway';

  @override
  String get didntReceiveCode => 'Didn\'t receive code? ';

  @override
  String get driverAuthSuccess => 'Driver authentication successful!';

  @override
  String get enterCorrectMobileForOtp =>
      'Enter your correct mobile number to receive a new OTP';

  @override
  String get messageCustomer => 'Message Customer';

  @override
  String get newRideOffer => 'New Ride Offer';

  @override
  String get newRideOfferWaiting => 'New ride offer waiting';

  @override
  String get numberUpdated => 'Number Updated';

  @override
  String get onboardingDriverBody1 =>
      'Earn reliable daily income with direct payouts, guaranteed ride requests, and 0% commission.';

  @override
  String get onboardingDriverBody2 =>
      'Every passenger is phone-verified with accurate pickup routes and 24/7 SOS safety support.';

  @override
  String get onboardingDriverBody3 =>
      'Choose affordable daily or weekly plans. Keep 100% of your earnings with no hidden deductions.';

  @override
  String get onboardingDriverTitle1 => 'Drive & Earn in Patna';

  @override
  String get onboardingDriverTitle2 => 'Safe & Verified Trips';

  @override
  String get onboardingDriverTitle3 => 'Flexible Subscriptions';

  @override
  String get otpVerificationTitle => 'OTP Verification';

  @override
  String get rideConfirmedHeadToPickup => 'Ride confirmed! Head to pickup.';

  @override
  String get ridesLabel => 'Rides';

  @override
  String get simDetected => 'SIM Detected';

  @override
  String get skipLabel => 'Skip';

  @override
  String get subscriptionLabel => 'Subscription';

  @override
  String get successLabel => 'Success';

  @override
  String get supportLabel => 'Support';

  @override
  String get typeAMessage => 'Type a message…';

  @override
  String get verifiedLabel => 'Verified';

  @override
  String get viewLabel => 'View';
}
