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
  /// **'Taxiway Driver'**
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

  /// No description provided for @driverLoginTitle.
  ///
  /// In en, this message translates to:
  /// **'Driver Login'**
  String get driverLoginTitle;

  /// No description provided for @enterMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter mobile number'**
  String get enterMobileNumber;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @unregisteredNumberError.
  ///
  /// In en, this message translates to:
  /// **'This number is not registered as a driver. Please contact the office.'**
  String get unregisteredNumberError;

  /// No description provided for @verifyMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Verify Mobile Number'**
  String get verifyMobileNumber;

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

  /// No description provided for @loginLabel.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginLabel;

  /// No description provided for @resendOtp.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get resendOtp;

  /// No description provided for @resendIn.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP in 00:{time}'**
  String resendIn(String time);

  /// No description provided for @canResendNow.
  ///
  /// In en, this message translates to:
  /// **'You can now resend OTP'**
  String get canResendNow;

  /// No description provided for @invalidOtp.
  ///
  /// In en, this message translates to:
  /// **'Invalid OTP. Please try again.'**
  String get invalidOtp;

  /// No description provided for @verificationPendingTitle.
  ///
  /// In en, this message translates to:
  /// **'Verification Pending'**
  String get verificationPendingTitle;

  /// No description provided for @verificationPendingMessage.
  ///
  /// In en, this message translates to:
  /// **'Please complete your KYC/verification at the Taxiway office or contact support.'**
  String get verificationPendingMessage;

  /// No description provided for @callOfficeSupport.
  ///
  /// In en, this message translates to:
  /// **'Call Office / Support'**
  String get callOfficeSupport;

  /// No description provided for @accountSuspendedTitle.
  ///
  /// In en, this message translates to:
  /// **'Account Temporarily Unavailable'**
  String get accountSuspendedTitle;

  /// No description provided for @accountSuspendedMessage.
  ///
  /// In en, this message translates to:
  /// **'Please contact Taxiway support for more information.'**
  String get accountSuspendedMessage;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get backToLogin;

  /// No description provided for @driverDashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Driver Dashboard'**
  String get driverDashboardTitle;

  /// No description provided for @verifiedDriver.
  ///
  /// In en, this message translates to:
  /// **'Verified Driver'**
  String get verifiedDriver;

  /// No description provided for @currentPlan.
  ///
  /// In en, this message translates to:
  /// **'Current Plan'**
  String get currentPlan;

  /// No description provided for @ridesIncluded.
  ///
  /// In en, this message translates to:
  /// **'{count} Rides Included'**
  String ridesIncluded(int count);

  /// No description provided for @ridesUsed.
  ///
  /// In en, this message translates to:
  /// **'Rides Used'**
  String get ridesUsed;

  /// No description provided for @ridesRemaining.
  ///
  /// In en, this message translates to:
  /// **'Rides Remaining'**
  String get ridesRemaining;

  /// No description provided for @renewalDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Renewal Date'**
  String get renewalDateLabel;

  /// No description provided for @nextRide.
  ///
  /// In en, this message translates to:
  /// **'Next Ride'**
  String get nextRide;

  /// No description provided for @noUpcomingRides.
  ///
  /// In en, this message translates to:
  /// **'No upcoming rides right now.'**
  String get noUpcomingRides;

  /// No description provided for @customerLabel.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customerLabel;

  /// No description provided for @expectedFare.
  ///
  /// In en, this message translates to:
  /// **'Expected Fare'**
  String get expectedFare;

  /// No description provided for @viewRideDetails.
  ///
  /// In en, this message translates to:
  /// **'View Ride Details'**
  String get viewRideDetails;

  /// No description provided for @callCustomer.
  ///
  /// In en, this message translates to:
  /// **'Call Customer'**
  String get callCustomer;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logoutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Log out?'**
  String get logoutConfirmTitle;

  /// No description provided for @logoutConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'You\'ll need to verify your number again to log back in.'**
  String get logoutConfirmMessage;

  /// No description provided for @myRidesTitle.
  ///
  /// In en, this message translates to:
  /// **'My Rides'**
  String get myRidesTitle;

  /// No description provided for @upcomingTab.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcomingTab;

  /// No description provided for @completedTab.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completedTab;

  /// No description provided for @noUpcomingRidesTitle.
  ///
  /// In en, this message translates to:
  /// **'No upcoming rides'**
  String get noUpcomingRidesTitle;

  /// No description provided for @noCompletedRidesTitle.
  ///
  /// In en, this message translates to:
  /// **'No completed rides yet'**
  String get noCompletedRidesTitle;

  /// No description provided for @rideDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Ride Details'**
  String get rideDetailsTitle;

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateLabel;

  /// No description provided for @timeLabel.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get timeLabel;

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

  /// No description provided for @vehicleLabel.
  ///
  /// In en, this message translates to:
  /// **'Vehicle'**
  String get vehicleLabel;

  /// No description provided for @fareLabel.
  ///
  /// In en, this message translates to:
  /// **'Fare'**
  String get fareLabel;

  /// No description provided for @paymentStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment Status'**
  String get paymentStatusLabel;

  /// No description provided for @rideStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Ride Status'**
  String get rideStatusLabel;

  /// No description provided for @openMap.
  ///
  /// In en, this message translates to:
  /// **'Open Map'**
  String get openMap;

  /// No description provided for @markCompleted.
  ///
  /// In en, this message translates to:
  /// **'Mark Completed'**
  String get markCompleted;

  /// No description provided for @markedCompletedToast.
  ///
  /// In en, this message translates to:
  /// **'Ride marked as completed.'**
  String get markedCompletedToast;

  /// No description provided for @paid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paid;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @subscriptionTitle.
  ///
  /// In en, this message translates to:
  /// **'Subscription & Payments'**
  String get subscriptionTitle;

  /// No description provided for @validUntil.
  ///
  /// In en, this message translates to:
  /// **'Valid Until'**
  String get validUntil;

  /// No description provided for @thisMonthCollected.
  ///
  /// In en, this message translates to:
  /// **'This Month Collected'**
  String get thisMonthCollected;

  /// No description provided for @completedRidesLabel.
  ///
  /// In en, this message translates to:
  /// **'Completed Rides'**
  String get completedRidesLabel;

  /// No description provided for @todayCollected.
  ///
  /// In en, this message translates to:
  /// **'Today Collected'**
  String get todayCollected;

  /// No description provided for @pendingPaymentLabel.
  ///
  /// In en, this message translates to:
  /// **'Pending Payment'**
  String get pendingPaymentLabel;

  /// No description provided for @lastPayment.
  ///
  /// In en, this message translates to:
  /// **'Last Payment'**
  String get lastPayment;

  /// No description provided for @paidOn.
  ///
  /// In en, this message translates to:
  /// **'Paid On'**
  String get paidOn;

  /// No description provided for @nextRenewal.
  ///
  /// In en, this message translates to:
  /// **'Next Renewal'**
  String get nextRenewal;

  /// No description provided for @paymentMethodLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethodLabel;

  /// No description provided for @renewSubscription.
  ///
  /// In en, this message translates to:
  /// **'Renew Subscription'**
  String get renewSubscription;

  /// No description provided for @renewedToast.
  ///
  /// In en, this message translates to:
  /// **'Subscription renewed successfully!'**
  String get renewedToast;
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
