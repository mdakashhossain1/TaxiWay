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

  /// No description provided for @scheduledTab.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get scheduledTab;

  /// No description provided for @noScheduledRidesTitle.
  ///
  /// In en, this message translates to:
  /// **'No scheduled rides'**
  String get noScheduledRidesTitle;

  /// No description provided for @scheduledRideDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Scheduled Ride'**
  String get scheduledRideDetailTitle;

  /// No description provided for @openToAllDriversLabel.
  ///
  /// In en, this message translates to:
  /// **'Open to all eligible drivers — accept before someone else does.'**
  String get openToAllDriversLabel;

  /// No description provided for @acceptRideLabel.
  ///
  /// In en, this message translates to:
  /// **'Accept Ride'**
  String get acceptRideLabel;

  /// No description provided for @declineLabel.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get declineLabel;

  /// No description provided for @scheduledRideAcceptedToast.
  ///
  /// In en, this message translates to:
  /// **'Ride confirmed! It\'s on your upcoming rides.'**
  String get scheduledRideAcceptedToast;

  /// No description provided for @scheduledRideUnavailableTitle.
  ///
  /// In en, this message translates to:
  /// **'Too Late'**
  String get scheduledRideUnavailableTitle;

  /// No description provided for @scheduledRideAcceptFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t accept this ride. Please try again.'**
  String get scheduledRideAcceptFailedMessage;

  /// No description provided for @scheduledRideDeclineFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t decline this ride. Please try again.'**
  String get scheduledRideDeclineFailedMessage;

  /// No description provided for @scheduledRidesAvailableTitle.
  ///
  /// In en, this message translates to:
  /// **'Scheduled rides available'**
  String get scheduledRidesAvailableTitle;

  /// No description provided for @scheduledRidesAvailableCount.
  ///
  /// In en, this message translates to:
  /// **'{count} ride(s) waiting for a driver'**
  String scheduledRidesAvailableCount(int count);

  /// No description provided for @viewAllLabel.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAllLabel;

  /// No description provided for @paymentSuccessfulTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment successful'**
  String get paymentSuccessfulTitle;

  /// No description provided for @subscriptionRenewedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your plan has been renewed.'**
  String get subscriptionRenewedMessage;

  /// No description provided for @amountPaidLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount paid'**
  String get amountPaidLabel;

  /// No description provided for @doneLabel.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get doneLabel;

  /// No description provided for @renewFailedToast.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t renew right now. Please try again.'**
  String get renewFailedToast;

  /// No description provided for @connectionOfflineTitle.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get connectionOfflineTitle;

  /// No description provided for @connectionSlowTitle.
  ///
  /// In en, this message translates to:
  /// **'Slow connection'**
  String get connectionSlowTitle;

  /// No description provided for @connectionRestoredTitle.
  ///
  /// In en, this message translates to:
  /// **'Back online'**
  String get connectionRestoredTitle;

  /// No description provided for @connectionServerTroubleTitle.
  ///
  /// In en, this message translates to:
  /// **'We\'re having trouble reaching our servers'**
  String get connectionServerTroubleTitle;

  /// No description provided for @connectionRetryAction.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get connectionRetryAction;

  /// No description provided for @connectionCheckingAction.
  ///
  /// In en, this message translates to:
  /// **'Checking…'**
  String get connectionCheckingAction;

  /// No description provided for @errorOfflineTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re offline'**
  String get errorOfflineTitle;

  /// No description provided for @errorOfflineMessage.
  ///
  /// In en, this message translates to:
  /// **'Check your Wi-Fi or mobile data and try again.'**
  String get errorOfflineMessage;

  /// No description provided for @errorTimeoutTitle.
  ///
  /// In en, this message translates to:
  /// **'This is taking too long'**
  String get errorTimeoutTitle;

  /// No description provided for @errorTimeoutMessage.
  ///
  /// In en, this message translates to:
  /// **'Your connection seems slow. Try again in a moment.'**
  String get errorTimeoutMessage;

  /// No description provided for @errorServerTitle.
  ///
  /// In en, this message translates to:
  /// **'We\'re having trouble on our end'**
  String get errorServerTitle;

  /// No description provided for @errorServerMessage.
  ///
  /// In en, this message translates to:
  /// **'This isn\'t your connection. Please try again shortly.'**
  String get errorServerMessage;

  /// No description provided for @errorMaintenanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Back shortly'**
  String get errorMaintenanceTitle;

  /// No description provided for @errorMaintenanceMessage.
  ///
  /// In en, this message translates to:
  /// **'Taxiway is being updated to serve you better.'**
  String get errorMaintenanceMessage;

  /// No description provided for @errorGenericTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorGenericTitle;

  /// No description provided for @errorGenericMessage.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t load this. Please try again.'**
  String get errorGenericMessage;

  /// No description provided for @tryAgainLabel.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgainLabel;

  /// No description provided for @tryingAgainLabel.
  ///
  /// In en, this message translates to:
  /// **'Trying again…'**
  String get tryingAgainLabel;

  /// No description provided for @goBackLabel.
  ///
  /// In en, this message translates to:
  /// **'Go back'**
  String get goBackLabel;

  /// No description provided for @emptyDefaultTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get emptyDefaultTitle;

  /// No description provided for @emptyDefaultMessage.
  ///
  /// In en, this message translates to:
  /// **'Items will show up here.'**
  String get emptyDefaultMessage;

  /// No description provided for @chatEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No messages yet'**
  String get chatEmptyTitle;

  /// No description provided for @chatEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Say hello!'**
  String get chatEmptyMessage;

  /// No description provided for @chatLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load messages'**
  String get chatLoadFailed;

  /// No description provided for @messageSendFailed.
  ///
  /// In en, this message translates to:
  /// **'Message didn\'t send. Please try again.'**
  String get messageSendFailed;

  /// No description provided for @otpSendFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t send the OTP. Please try again.'**
  String get otpSendFailed;

  /// No description provided for @otpResendFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t resend the OTP. Please try again.'**
  String get otpResendFailed;

  /// No description provided for @otpVerifyFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t verify the code. Please try again.'**
  String get otpVerifyFailed;

  /// No description provided for @otpExpired.
  ///
  /// In en, this message translates to:
  /// **'This code has expired. Please request a new one.'**
  String get otpExpired;

  /// No description provided for @googleSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t sign in with Google. Please try again.'**
  String get googleSignInFailed;

  /// No description provided for @supportNumberMissing.
  ///
  /// In en, this message translates to:
  /// **'Support number isn\'t set up yet.'**
  String get supportNumberMissing;

  /// No description provided for @supportUnreachable.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t reach support right now. Please try again.'**
  String get supportUnreachable;

  /// No description provided for @offerUnavailable.
  ///
  /// In en, this message translates to:
  /// **'This offer is no longer available.'**
  String get offerUnavailable;

  /// No description provided for @offerDeclineFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t decline this offer. Please try again.'**
  String get offerDeclineFailed;

  /// No description provided for @offerAcceptFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t accept this offer. Please try again.'**
  String get offerAcceptFailed;

  /// No description provided for @rideCompleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t mark this ride as completed. Please try again.'**
  String get rideCompleteFailed;

  /// No description provided for @offerCheckFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t check for new ride offers'**
  String get offerCheckFailed;

  /// No description provided for @acceptedTitle.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get acceptedTitle;

  /// No description provided for @addPhoneToFinishSetup.
  ///
  /// In en, this message translates to:
  /// **'Add your phone number to finish setting up your account.'**
  String get addPhoneToFinishSetup;

  /// No description provided for @almostThere.
  ///
  /// In en, this message translates to:
  /// **'Almost there'**
  String get almostThere;

  /// No description provided for @autoFillSimNumber.
  ///
  /// In en, this message translates to:
  /// **'Auto-fill SIM number'**
  String get autoFillSimNumber;

  /// No description provided for @changeLabel.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get changeLabel;

  /// No description provided for @changePhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Change Phone Number'**
  String get changePhoneNumber;

  /// No description provided for @codeResent.
  ///
  /// In en, this message translates to:
  /// **'Code Resent'**
  String get codeResent;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @devModeNoSms.
  ///
  /// In en, this message translates to:
  /// **'Dev Mode — No SMS Gateway'**
  String get devModeNoSms;

  /// No description provided for @didntReceiveCode.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive code? '**
  String get didntReceiveCode;

  /// No description provided for @driverAuthSuccess.
  ///
  /// In en, this message translates to:
  /// **'Driver authentication successful!'**
  String get driverAuthSuccess;

  /// No description provided for @enterCorrectMobileForOtp.
  ///
  /// In en, this message translates to:
  /// **'Enter your correct mobile number to receive a new OTP'**
  String get enterCorrectMobileForOtp;

  /// No description provided for @messageCustomer.
  ///
  /// In en, this message translates to:
  /// **'Message Customer'**
  String get messageCustomer;

  /// No description provided for @newRideOffer.
  ///
  /// In en, this message translates to:
  /// **'New Ride Offer'**
  String get newRideOffer;

  /// No description provided for @newRideOfferWaiting.
  ///
  /// In en, this message translates to:
  /// **'New ride offer waiting'**
  String get newRideOfferWaiting;

  /// No description provided for @numberUpdated.
  ///
  /// In en, this message translates to:
  /// **'Number Updated'**
  String get numberUpdated;

  /// No description provided for @onboardingDriverBody1.
  ///
  /// In en, this message translates to:
  /// **'Earn reliable daily income with direct payouts, guaranteed ride requests, and 0% commission.'**
  String get onboardingDriverBody1;

  /// No description provided for @onboardingDriverBody2.
  ///
  /// In en, this message translates to:
  /// **'Every passenger is phone-verified with accurate pickup routes and 24/7 SOS safety support.'**
  String get onboardingDriverBody2;

  /// No description provided for @onboardingDriverBody3.
  ///
  /// In en, this message translates to:
  /// **'Choose affordable daily or weekly plans. Keep 100% of your earnings with no hidden deductions.'**
  String get onboardingDriverBody3;

  /// No description provided for @onboardingDriverTitle1.
  ///
  /// In en, this message translates to:
  /// **'Drive & Earn in Patna'**
  String get onboardingDriverTitle1;

  /// No description provided for @onboardingDriverTitle2.
  ///
  /// In en, this message translates to:
  /// **'Safe & Verified Trips'**
  String get onboardingDriverTitle2;

  /// No description provided for @onboardingDriverTitle3.
  ///
  /// In en, this message translates to:
  /// **'Flexible Subscriptions'**
  String get onboardingDriverTitle3;

  /// No description provided for @otpVerificationTitle.
  ///
  /// In en, this message translates to:
  /// **'OTP Verification'**
  String get otpVerificationTitle;

  /// No description provided for @rideConfirmedHeadToPickup.
  ///
  /// In en, this message translates to:
  /// **'Ride confirmed! Head to pickup.'**
  String get rideConfirmedHeadToPickup;

  /// No description provided for @ridesLabel.
  ///
  /// In en, this message translates to:
  /// **'Rides'**
  String get ridesLabel;

  /// No description provided for @simDetected.
  ///
  /// In en, this message translates to:
  /// **'SIM Detected'**
  String get simDetected;

  /// No description provided for @skipLabel.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skipLabel;

  /// No description provided for @subscriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get subscriptionLabel;

  /// No description provided for @successLabel.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get successLabel;

  /// No description provided for @supportLabel.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get supportLabel;

  /// No description provided for @typeAMessage.
  ///
  /// In en, this message translates to:
  /// **'Type a message…'**
  String get typeAMessage;

  /// No description provided for @verifiedLabel.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verifiedLabel;

  /// No description provided for @viewLabel.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get viewLabel;
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
