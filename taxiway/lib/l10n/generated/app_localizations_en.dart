// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Taxiway';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageHindi => 'हिन्दी';

  @override
  String get languageBengali => 'বাংলা';

  @override
  String get languagePickerTitle => 'Choose your language';

  @override
  String get languagePickerSubtitle =>
      'You can change this anytime from the home screen.';

  @override
  String get continueLabel => 'Continue';

  @override
  String get onboardSlide1Title => 'Safe. Reliable. Anytime.';

  @override
  String get onboardSlide1Subtitle =>
      'Verified drivers, transparent fares, and a smooth ride every time.';

  @override
  String get onboardSlide2Title => 'Track your ride, live';

  @override
  String get onboardSlide2Subtitle =>
      'Watch your driver approach in real time, from pickup to drop-off.';

  @override
  String get onboardSlide3Title => 'One tap, multiple vehicles';

  @override
  String get onboardSlide3Subtitle =>
      'From a solo ride to a full group booking, Taxiway scales with you.';

  @override
  String get getStarted => 'Get Started';

  @override
  String get login => 'Login';

  @override
  String get appVersion => 'v1.0.0';

  @override
  String get welcome => 'Welcome!';

  @override
  String get enterPhoneSubtitle => 'Enter your phone number to continue.';

  @override
  String get enterMobileNumber => 'Enter mobile number';

  @override
  String get agreeToTerms => 'By continuing, you agree to our ';

  @override
  String get termsAndConditions => 'Terms & Conditions';

  @override
  String get andWord => ' and ';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get verifyYourNumber => 'Verify your number';

  @override
  String otpSentTo(String phone) {
    return 'We\'ve sent a 6-digit OTP to +91 $phone';
  }

  @override
  String get otpDemoHint => '(Use 123456 for this demo)';

  @override
  String resendIn(String time) {
    return 'Resend in $time';
  }

  @override
  String get resendOtp => 'Resend OTP';

  @override
  String get verifyAndContinue => 'Verify & Continue';

  @override
  String get invalidOtp => 'Invalid OTP. Please try again.';

  @override
  String get otpResent => 'OTP resent.';

  @override
  String get enterDestinationHint =>
      'Enter a destination to see vehicles and fare.';

  @override
  String get bulkBookingTitle => 'Bulk Booking';

  @override
  String get bulkBookingSubtitle =>
      'Book multiple vehicles for a group or scheduled trip.';

  @override
  String get selectVehicle => 'Select Vehicle';

  @override
  String get bookRide => 'Book Ride';

  @override
  String get selectAVehicle => 'Select a Vehicle';

  @override
  String get fromLabel => 'From';

  @override
  String get toLabel => 'To';

  @override
  String get searchPickup => 'Search Pickup';

  @override
  String get enterDestination => 'Enter Destination';

  @override
  String get distanceLabel => 'Distance';

  @override
  String get estTimeLabel => 'Est. Time';

  @override
  String get profileTitle => 'Profile';

  @override
  String get myTrips => 'My Trips';

  @override
  String get helpSupport => 'Help & Support';

  @override
  String get languageMenuItem => 'Language';

  @override
  String get logout => 'Logout';

  @override
  String get guest => 'Guest';

  @override
  String get logoutConfirmBody => 'Are you sure you want to logout?';

  @override
  String get cancel => 'Cancel';

  @override
  String get deleteMyAccount => 'Delete my account';

  @override
  String get deleteAccountDialogTitle => 'Delete Account';

  @override
  String get deleteAccountDialogBody =>
      'This opens a secure page in your browser where you can permanently delete your account and all associated data. This cannot be undone.';

  @override
  String get continueWord => 'Continue';

  @override
  String seatsCountShort(int count) {
    return '$count seats';
  }

  @override
  String get couldNotLoadVehicles => 'Couldn\'t load vehicles.';

  @override
  String seaterCount(int count) {
    return '$count Seater';
  }

  @override
  String minutesShort(int count) {
    return '$count min';
  }

  @override
  String kmShort(String value) {
    return '$value km';
  }

  @override
  String get pickupLabel => 'Pickup';

  @override
  String get destinationLabel => 'Destination';

  @override
  String get driverLocationLabel => 'Driver Location';

  @override
  String get expandMapLabel => 'Full Screen';

  @override
  String get collapseMapLabel => 'Collapse';

  @override
  String get fromPickupLabel => 'From (Pickup)';

  @override
  String get toDestinationLabel => 'To (Destination)';

  @override
  String get whereDoYouWantToGo => 'Where do you want to go?';

  @override
  String get baseFareLabel => 'Base Fare';

  @override
  String get timeLabel => 'Time';

  @override
  String get tollsParkingNote => 'Tolls & parking extra';

  @override
  String get pickupLocationTitle => 'Pickup Location';

  @override
  String get dragMapPickupHint =>
      'Drag the map to move the pin, or search pickup location below.';

  @override
  String get searchPickupMapHint => 'Search pickup location on real map...';

  @override
  String get useCurrentGpsLocation => 'Use current GPS location';

  @override
  String get detectLocationAutomatically => 'Detect location automatically';

  @override
  String closestResultsLabel(int count) {
    return 'Closest Results ($count)';
  }

  @override
  String get recentPickupsLabel => 'Recent Pickups';

  @override
  String get clearAllLabel => 'Clear all';

  @override
  String get confirmPickupLabel => 'Confirm Pickup';

  @override
  String get selectPickupLocationLabel => 'Select Pickup Location';

  @override
  String get noExactMatchTitle => 'No exact match found on map.';

  @override
  String get dragPinToSelectHint =>
      'Drag the map pin to select this location directly.';

  @override
  String get noRecentPickupsTitle => 'No recent pickups';

  @override
  String get searchPickupAboveHint =>
      'Search pickup above or drag the pin on map.';

  @override
  String get removeFromHistoryTooltip => 'Remove from history';

  @override
  String get liveRouteShowingHint =>
      'Showing live road route to selected destination. Tap map or search to change.';

  @override
  String get tapMapToSeeRouteHint =>
      'Tap on map or search below to see live road route.';

  @override
  String get searchDestinationMapHint => 'Search destination on real map...';

  @override
  String closestMatchesLabel(int count) {
    return 'Closest Matches ($count)';
  }

  @override
  String get recentSearchHistoryLabel => 'Recent Search History';

  @override
  String get confirmDestinationLabel => 'Confirm Destination';

  @override
  String get selectDestinationFromMapLabel =>
      'Select Destination from Map / List';

  @override
  String get tapMapDirectlyHint =>
      'Tap on the map directly to select this spot.';

  @override
  String get noRecentSearchesTitle => 'No recent searches';

  @override
  String get typeAboveToSearchHint =>
      'Type above to search real places or tap on the map.';

  @override
  String get missingBookingDetails => 'Missing booking details.';

  @override
  String get confirmYourRide => 'Confirm your ride';

  @override
  String seatsCount(int count) {
    return '$count Seats';
  }

  @override
  String get acLabel => 'AC';

  @override
  String tripDistanceValue(String value) {
    return 'Trip Distance: $value km';
  }

  @override
  String estTimeValue(String value) {
    return 'Est. Time: $value min';
  }

  @override
  String get paymentMethodLabel => 'Payment Method';

  @override
  String get upiTitle => 'UPI (GPay, PhonePe, Paytm)';

  @override
  String get upiSubtitle => 'Pay directly via any UPI app / QR code';

  @override
  String get cashPaymentTitle => 'Cash Payment';

  @override
  String get cashPaymentSubtitle =>
      'Pay driver directly after completing the trip';

  @override
  String get cardPaymentTitle => 'Credit / Debit Card';

  @override
  String get cardPaymentSubtitle => 'Visa, MasterCard, RuPay, Corporate cards';

  @override
  String confirmBookingLabel(String value) {
    return 'Confirm Booking — $value';
  }

  @override
  String get bookingFailedTitle => 'Booking Failed';

  @override
  String get bookingFailedMessage =>
      'Couldn\'t complete booking right now. Please try again.';

  @override
  String get changeVehicleLabel => 'Change Vehicle';

  @override
  String get cancelRideTitle => 'Cancel Ride?';

  @override
  String get cancelRideBody =>
      'Are you sure you want to cancel this ride? No cancellation fee applies within 5 minutes.';

  @override
  String get keepRideLabel => 'Keep Ride';

  @override
  String get cancelRideLabel => 'Cancel Ride';

  @override
  String get bookingConfirmedTitle => 'Booking Confirmed';

  @override
  String get noActiveBookingLabel => 'No active booking.';

  @override
  String get yourBookingConfirmedHeading => 'Your booking is confirmed!';

  @override
  String get driverAllocatedSubtitle => 'Driver has been allocated';

  @override
  String get driverMayCallTitle => 'Driver may call you';

  @override
  String get keepPhoneReachableSubtitle => 'Please keep your phone reachable';

  @override
  String get liveTrackDriverLabel => 'Live Track Driver';

  @override
  String reviewCountSuffix(int count) {
    return '($count trips)';
  }

  @override
  String get verifiedDriverLabel => 'Verified Driver';

  @override
  String get connectingCallTitle => 'Connecting Call';

  @override
  String callingDriverMessage(String name) {
    return 'Calling $name (+91 98765 00000)...';
  }

  @override
  String get driverOnWayHeading => 'Driver is on the way';

  @override
  String get driverArrivedLabel => 'Driver has arrived!';

  @override
  String kmAwaySuffix(String value) {
    return '$value km away';
  }

  @override
  String get arrivingInLabel => 'Arriving in';

  @override
  String get dropLabel => 'Drop';

  @override
  String get findingDriverHeading => 'Finding a suitable driver...';

  @override
  String get findingDriverSubtitle => 'This usually takes a few seconds.';

  @override
  String get cancelRequestLabel => 'Cancel Request';
}
