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
}
