import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bn'),
    Locale('en'),
    Locale('hi'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Taxiway'**
  String get appTitle;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageHindi.
  ///
  /// In en, this message translates to:
  /// **'हिन्दी'**
  String get languageHindi;

  /// No description provided for @languageBengali.
  ///
  /// In en, this message translates to:
  /// **'বাংলা'**
  String get languageBengali;

  /// No description provided for @languagePickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get languagePickerTitle;

  /// No description provided for @languagePickerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You can change this anytime from the home screen.'**
  String get languagePickerSubtitle;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @onboardSlide1Title.
  ///
  /// In en, this message translates to:
  /// **'Safe. Reliable. Anytime.'**
  String get onboardSlide1Title;

  /// No description provided for @onboardSlide1Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Verified drivers, transparent fares, and a smooth ride every time.'**
  String get onboardSlide1Subtitle;

  /// No description provided for @onboardSlide2Title.
  ///
  /// In en, this message translates to:
  /// **'Track your ride, live'**
  String get onboardSlide2Title;

  /// No description provided for @onboardSlide2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Watch your driver approach in real time, from pickup to drop-off.'**
  String get onboardSlide2Subtitle;

  /// No description provided for @onboardSlide3Title.
  ///
  /// In en, this message translates to:
  /// **'One tap, multiple vehicles'**
  String get onboardSlide3Title;

  /// No description provided for @onboardSlide3Subtitle.
  ///
  /// In en, this message translates to:
  /// **'From a solo ride to a full group booking, Taxiway scales with you.'**
  String get onboardSlide3Subtitle;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'v1.0.0'**
  String get appVersion;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get welcome;

  /// No description provided for @enterPhoneSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number to continue.'**
  String get enterPhoneSubtitle;

  /// No description provided for @enterMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter mobile number'**
  String get enterMobileNumber;

  /// No description provided for @agreeToTerms.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to our '**
  String get agreeToTerms;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsAndConditions;

  /// No description provided for @andWord.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get andWord;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @verifyYourNumber.
  ///
  /// In en, this message translates to:
  /// **'Verify your number'**
  String get verifyYourNumber;

  /// No description provided for @otpSentTo.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a 6-digit OTP to +91 {phone}'**
  String otpSentTo(String phone);

  /// No description provided for @otpDemoHint.
  ///
  /// In en, this message translates to:
  /// **'(Use 123456 for this demo)'**
  String get otpDemoHint;

  /// No description provided for @resendIn.
  ///
  /// In en, this message translates to:
  /// **'Resend in {time}'**
  String resendIn(String time);

  /// No description provided for @resendOtp.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get resendOtp;

  /// No description provided for @verifyAndContinue.
  ///
  /// In en, this message translates to:
  /// **'Verify & Continue'**
  String get verifyAndContinue;

  /// No description provided for @invalidOtp.
  ///
  /// In en, this message translates to:
  /// **'Invalid OTP. Please try again.'**
  String get invalidOtp;

  /// No description provided for @otpResent.
  ///
  /// In en, this message translates to:
  /// **'OTP resent.'**
  String get otpResent;

  /// No description provided for @enterDestinationHint.
  ///
  /// In en, this message translates to:
  /// **'Enter a destination to see vehicles and fare.'**
  String get enterDestinationHint;

  /// No description provided for @bulkBookingTitle.
  ///
  /// In en, this message translates to:
  /// **'Bulk Booking'**
  String get bulkBookingTitle;

  /// No description provided for @bulkBookingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Book multiple vehicles for a group or scheduled trip.'**
  String get bulkBookingSubtitle;

  /// No description provided for @selectVehicle.
  ///
  /// In en, this message translates to:
  /// **'Select Vehicle'**
  String get selectVehicle;

  /// No description provided for @bookRide.
  ///
  /// In en, this message translates to:
  /// **'Book Ride'**
  String get bookRide;

  /// No description provided for @selectAVehicle.
  ///
  /// In en, this message translates to:
  /// **'Select a Vehicle'**
  String get selectAVehicle;

  /// No description provided for @fromLabel.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get fromLabel;

  /// No description provided for @toLabel.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get toLabel;

  /// No description provided for @searchPickup.
  ///
  /// In en, this message translates to:
  /// **'Search Pickup'**
  String get searchPickup;

  /// No description provided for @enterDestination.
  ///
  /// In en, this message translates to:
  /// **'Enter Destination'**
  String get enterDestination;

  /// No description provided for @distanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distanceLabel;

  /// No description provided for @estTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Est. Time'**
  String get estTimeLabel;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @myTrips.
  ///
  /// In en, this message translates to:
  /// **'My Trips'**
  String get myTrips;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @languageMenuItem.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageMenuItem;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @guest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guest;

  /// No description provided for @logoutConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirmBody;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @deleteMyAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete my account'**
  String get deleteMyAccount;

  /// No description provided for @deleteAccountDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccountDialogTitle;

  /// No description provided for @deleteAccountDialogBody.
  ///
  /// In en, this message translates to:
  /// **'This opens a secure page in your browser where you can permanently delete your account and all associated data. This cannot be undone.'**
  String get deleteAccountDialogBody;

  /// No description provided for @continueWord.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueWord;

  /// No description provided for @seatsCountShort.
  ///
  /// In en, this message translates to:
  /// **'{count} seats'**
  String seatsCountShort(int count);

  /// No description provided for @couldNotLoadVehicles.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load vehicles.'**
  String get couldNotLoadVehicles;

  /// No description provided for @seaterCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Seater'**
  String seaterCount(int count);

  /// No description provided for @minutesShort.
  ///
  /// In en, this message translates to:
  /// **'{count} min'**
  String minutesShort(int count);

  /// No description provided for @kmShort.
  ///
  /// In en, this message translates to:
  /// **'{value} km'**
  String kmShort(String value);

  /// No description provided for @pickupLabel.
  ///
  /// In en, this message translates to:
  /// **'Pickup'**
  String get pickupLabel;

  /// No description provided for @destinationLabel.
  ///
  /// In en, this message translates to:
  /// **'Destination'**
  String get destinationLabel;

  /// No description provided for @driverLocationLabel.
  ///
  /// In en, this message translates to:
  /// **'Driver Location'**
  String get driverLocationLabel;

  /// No description provided for @expandMapLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Screen'**
  String get expandMapLabel;

  /// No description provided for @collapseMapLabel.
  ///
  /// In en, this message translates to:
  /// **'Collapse'**
  String get collapseMapLabel;

  /// No description provided for @fromPickupLabel.
  ///
  /// In en, this message translates to:
  /// **'From (Pickup)'**
  String get fromPickupLabel;

  /// No description provided for @toDestinationLabel.
  ///
  /// In en, this message translates to:
  /// **'To (Destination)'**
  String get toDestinationLabel;

  /// No description provided for @whereDoYouWantToGo.
  ///
  /// In en, this message translates to:
  /// **'Where do you want to go?'**
  String get whereDoYouWantToGo;

  /// No description provided for @baseFareLabel.
  ///
  /// In en, this message translates to:
  /// **'Base Fare'**
  String get baseFareLabel;

  /// No description provided for @timeLabel.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get timeLabel;

  /// No description provided for @tollsParkingNote.
  ///
  /// In en, this message translates to:
  /// **'Tolls & parking extra'**
  String get tollsParkingNote;

  /// No description provided for @pickupLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Pickup Location'**
  String get pickupLocationTitle;

  /// No description provided for @dragMapPickupHint.
  ///
  /// In en, this message translates to:
  /// **'Drag the map to move the pin, or search pickup location below.'**
  String get dragMapPickupHint;

  /// No description provided for @searchPickupMapHint.
  ///
  /// In en, this message translates to:
  /// **'Search pickup location on real map...'**
  String get searchPickupMapHint;

  /// No description provided for @useCurrentGpsLocation.
  ///
  /// In en, this message translates to:
  /// **'Use current GPS location'**
  String get useCurrentGpsLocation;

  /// No description provided for @detectLocationAutomatically.
  ///
  /// In en, this message translates to:
  /// **'Detect location automatically'**
  String get detectLocationAutomatically;

  /// No description provided for @closestResultsLabel.
  ///
  /// In en, this message translates to:
  /// **'Closest Results ({count})'**
  String closestResultsLabel(int count);

  /// No description provided for @recentPickupsLabel.
  ///
  /// In en, this message translates to:
  /// **'Recent Pickups'**
  String get recentPickupsLabel;

  /// No description provided for @clearAllLabel.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get clearAllLabel;

  /// No description provided for @confirmPickupLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Pickup'**
  String get confirmPickupLabel;

  /// No description provided for @selectPickupLocationLabel.
  ///
  /// In en, this message translates to:
  /// **'Select Pickup Location'**
  String get selectPickupLocationLabel;

  /// No description provided for @noExactMatchTitle.
  ///
  /// In en, this message translates to:
  /// **'No exact match found on map.'**
  String get noExactMatchTitle;

  /// No description provided for @dragPinToSelectHint.
  ///
  /// In en, this message translates to:
  /// **'Drag the map pin to select this location directly.'**
  String get dragPinToSelectHint;

  /// No description provided for @noRecentPickupsTitle.
  ///
  /// In en, this message translates to:
  /// **'No recent pickups'**
  String get noRecentPickupsTitle;

  /// No description provided for @searchPickupAboveHint.
  ///
  /// In en, this message translates to:
  /// **'Search pickup above or drag the pin on map.'**
  String get searchPickupAboveHint;

  /// No description provided for @removeFromHistoryTooltip.
  ///
  /// In en, this message translates to:
  /// **'Remove from history'**
  String get removeFromHistoryTooltip;

  /// No description provided for @liveRouteShowingHint.
  ///
  /// In en, this message translates to:
  /// **'Showing live road route to selected destination. Tap map or search to change.'**
  String get liveRouteShowingHint;

  /// No description provided for @tapMapToSeeRouteHint.
  ///
  /// In en, this message translates to:
  /// **'Tap on map or search below to see live road route.'**
  String get tapMapToSeeRouteHint;

  /// No description provided for @searchDestinationMapHint.
  ///
  /// In en, this message translates to:
  /// **'Search destination on real map...'**
  String get searchDestinationMapHint;

  /// No description provided for @closestMatchesLabel.
  ///
  /// In en, this message translates to:
  /// **'Closest Matches ({count})'**
  String closestMatchesLabel(int count);

  /// No description provided for @recentSearchHistoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Recent Search History'**
  String get recentSearchHistoryLabel;

  /// No description provided for @confirmDestinationLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Destination'**
  String get confirmDestinationLabel;

  /// No description provided for @selectDestinationFromMapLabel.
  ///
  /// In en, this message translates to:
  /// **'Select Destination from Map / List'**
  String get selectDestinationFromMapLabel;

  /// No description provided for @tapMapDirectlyHint.
  ///
  /// In en, this message translates to:
  /// **'Tap on the map directly to select this spot.'**
  String get tapMapDirectlyHint;

  /// No description provided for @noRecentSearchesTitle.
  ///
  /// In en, this message translates to:
  /// **'No recent searches'**
  String get noRecentSearchesTitle;

  /// No description provided for @typeAboveToSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Type above to search real places or tap on the map.'**
  String get typeAboveToSearchHint;

  /// No description provided for @missingBookingDetails.
  ///
  /// In en, this message translates to:
  /// **'Missing booking details.'**
  String get missingBookingDetails;

  /// No description provided for @confirmYourRide.
  ///
  /// In en, this message translates to:
  /// **'Confirm your ride'**
  String get confirmYourRide;

  /// No description provided for @seatsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Seats'**
  String seatsCount(int count);

  /// No description provided for @acLabel.
  ///
  /// In en, this message translates to:
  /// **'AC'**
  String get acLabel;

  /// No description provided for @tripDistanceValue.
  ///
  /// In en, this message translates to:
  /// **'Trip Distance: {value} km'**
  String tripDistanceValue(String value);

  /// No description provided for @estTimeValue.
  ///
  /// In en, this message translates to:
  /// **'Est. Time: {value} min'**
  String estTimeValue(String value);

  /// No description provided for @paymentMethodLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethodLabel;

  /// No description provided for @upiTitle.
  ///
  /// In en, this message translates to:
  /// **'UPI (GPay, PhonePe, Paytm)'**
  String get upiTitle;

  /// No description provided for @upiSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pay directly via any UPI app / QR code'**
  String get upiSubtitle;

  /// No description provided for @cashPaymentTitle.
  ///
  /// In en, this message translates to:
  /// **'Cash Payment'**
  String get cashPaymentTitle;

  /// No description provided for @cashPaymentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pay driver directly after completing the trip'**
  String get cashPaymentSubtitle;

  /// No description provided for @cardPaymentTitle.
  ///
  /// In en, this message translates to:
  /// **'Credit / Debit Card'**
  String get cardPaymentTitle;

  /// No description provided for @cardPaymentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Visa, MasterCard, RuPay, Corporate cards'**
  String get cardPaymentSubtitle;

  /// No description provided for @confirmBookingLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Booking — {value}'**
  String confirmBookingLabel(String value);

  /// No description provided for @bookingFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Booking Failed'**
  String get bookingFailedTitle;

  /// No description provided for @bookingFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t complete booking right now. Please try again.'**
  String get bookingFailedMessage;

  /// No description provided for @changeVehicleLabel.
  ///
  /// In en, this message translates to:
  /// **'Change Vehicle'**
  String get changeVehicleLabel;

  /// No description provided for @cancelRideTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel Ride?'**
  String get cancelRideTitle;

  /// No description provided for @cancelRideBody.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this ride? No cancellation fee applies within 5 minutes.'**
  String get cancelRideBody;

  /// No description provided for @keepRideLabel.
  ///
  /// In en, this message translates to:
  /// **'Keep Ride'**
  String get keepRideLabel;

  /// No description provided for @cancelRideLabel.
  ///
  /// In en, this message translates to:
  /// **'Cancel Ride'**
  String get cancelRideLabel;

  /// No description provided for @bookingConfirmedTitle.
  ///
  /// In en, this message translates to:
  /// **'Booking Confirmed'**
  String get bookingConfirmedTitle;

  /// No description provided for @noActiveBookingLabel.
  ///
  /// In en, this message translates to:
  /// **'No active booking.'**
  String get noActiveBookingLabel;

  /// No description provided for @yourBookingConfirmedHeading.
  ///
  /// In en, this message translates to:
  /// **'Your booking is confirmed!'**
  String get yourBookingConfirmedHeading;

  /// No description provided for @driverAllocatedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Driver has been allocated'**
  String get driverAllocatedSubtitle;

  /// No description provided for @driverMayCallTitle.
  ///
  /// In en, this message translates to:
  /// **'Driver may call you'**
  String get driverMayCallTitle;

  /// No description provided for @keepPhoneReachableSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please keep your phone reachable'**
  String get keepPhoneReachableSubtitle;

  /// No description provided for @liveTrackDriverLabel.
  ///
  /// In en, this message translates to:
  /// **'Live Track Driver'**
  String get liveTrackDriverLabel;

  /// No description provided for @reviewCountSuffix.
  ///
  /// In en, this message translates to:
  /// **'({count} trips)'**
  String reviewCountSuffix(int count);

  /// No description provided for @verifiedDriverLabel.
  ///
  /// In en, this message translates to:
  /// **'Verified Driver'**
  String get verifiedDriverLabel;

  /// No description provided for @connectingCallTitle.
  ///
  /// In en, this message translates to:
  /// **'Connecting Call'**
  String get connectingCallTitle;

  /// No description provided for @callingDriverMessage.
  ///
  /// In en, this message translates to:
  /// **'Calling {name} (+91 98765 00000)...'**
  String callingDriverMessage(String name);

  /// No description provided for @driverOnWayHeading.
  ///
  /// In en, this message translates to:
  /// **'Driver is on the way'**
  String get driverOnWayHeading;

  /// No description provided for @driverArrivedLabel.
  ///
  /// In en, this message translates to:
  /// **'Driver has arrived!'**
  String get driverArrivedLabel;

  /// No description provided for @kmAwaySuffix.
  ///
  /// In en, this message translates to:
  /// **'{value} km away'**
  String kmAwaySuffix(String value);

  /// No description provided for @arrivingInLabel.
  ///
  /// In en, this message translates to:
  /// **'Arriving in'**
  String get arrivingInLabel;

  /// No description provided for @dropLabel.
  ///
  /// In en, this message translates to:
  /// **'Drop'**
  String get dropLabel;

  /// No description provided for @findingDriverHeading.
  ///
  /// In en, this message translates to:
  /// **'Finding a suitable driver...'**
  String get findingDriverHeading;

  /// No description provided for @findingDriverSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This usually takes a few seconds.'**
  String get findingDriverSubtitle;

  /// No description provided for @cancelRequestLabel.
  ///
  /// In en, this message translates to:
  /// **'Cancel Request'**
  String get cancelRequestLabel;

  /// No description provided for @bookNow.
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get bookNow;

  /// No description provided for @scheduleForLater.
  ///
  /// In en, this message translates to:
  /// **'Schedule for Later'**
  String get scheduleForLater;

  /// No description provided for @scheduleRide.
  ///
  /// In en, this message translates to:
  /// **'Schedule Ride'**
  String get scheduleRide;

  /// No description provided for @scheduleTooSoonError.
  ///
  /// In en, this message translates to:
  /// **'Please choose a time at least 30 minutes from now.'**
  String get scheduleTooSoonError;

  /// No description provided for @scheduleTooFarError.
  ///
  /// In en, this message translates to:
  /// **'Scheduling is only available up to 7 days ahead.'**
  String get scheduleTooFarError;

  /// No description provided for @noVehiclesMatchFilter.
  ///
  /// In en, this message translates to:
  /// **'No vehicles match this filter.'**
  String get noVehiclesMatchFilter;

  /// No description provided for @seatsFilterAny.
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get seatsFilterAny;

  /// No description provided for @seatsFilterPlus.
  ///
  /// In en, this message translates to:
  /// **'{count}+ Seats'**
  String seatsFilterPlus(int count);

  /// No description provided for @upcomingScheduledRideTitle.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Scheduled Ride'**
  String get upcomingScheduledRideTitle;

  /// No description provided for @waitingForDriverLabel.
  ///
  /// In en, this message translates to:
  /// **'Waiting for a driver...'**
  String get waitingForDriverLabel;

  /// No description provided for @driverAssignedNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Driver: {name}'**
  String driverAssignedNameLabel(String name);

  /// No description provided for @scheduledForLabel.
  ///
  /// In en, this message translates to:
  /// **'Scheduled for {value}'**
  String scheduledForLabel(String value);

  /// No description provided for @addEmailForReceiptLabel.
  ///
  /// In en, this message translates to:
  /// **'Add your email for a booking receipt'**
  String get addEmailForReceiptLabel;

  /// No description provided for @emailOptionalHint.
  ///
  /// In en, this message translates to:
  /// **'you@example.com (optional)'**
  String get emailOptionalHint;

  /// No description provided for @validationEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address.'**
  String get validationEmailInvalid;

  /// No description provided for @scheduledRideConfirmationToast.
  ///
  /// In en, this message translates to:
  /// **'Your ride has been scheduled! We\'ll notify you once a driver accepts.'**
  String get scheduledRideConfirmationToast;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['bn', 'en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
