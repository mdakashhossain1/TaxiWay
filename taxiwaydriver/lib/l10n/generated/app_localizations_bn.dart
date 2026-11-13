// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appTitle => 'রাইডগো ড্রাইভার';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageHindi => 'হিন্দি';

  @override
  String get languageBengali => 'বাংলা';

  @override
  String get languagePickerTitle => 'আপনার ভাষা বেছে নিন';

  @override
  String get driverLoginTitle => 'ড্রাইভার লগইন';

  @override
  String get enterMobileNumber => 'মোবাইল নম্বর লিখুন';

  @override
  String get continueLabel => 'চালিয়ে যান';

  @override
  String get unregisteredNumberError =>
      'এই নম্বরটি ড্রাইভার হিসেবে নিবন্ধিত নয়। অনুগ্রহ করে অফিসে যোগাযোগ করুন।';

  @override
  String get verifyMobileNumber => 'মোবাইল নম্বর যাচাই করুন';

  @override
  String otpSentTo(String phone) {
    return 'আমরা +91 $phone নম্বরে ৬ সংখ্যার OTP পাঠিয়েছি';
  }

  @override
  String get otpDemoHint => '(ডেমোর জন্য 123456 ব্যবহার করুন)';

  @override
  String get loginLabel => 'লগইন';

  @override
  String get resendOtp => 'OTP আবার পাঠান';

  @override
  String resendIn(String time) {
    return '00:$time-এ OTP আবার পাঠান';
  }

  @override
  String get canResendNow => 'আপনি এখন OTP আবার পাঠাতে পারেন';

  @override
  String get invalidOtp => 'ভুল OTP। আবার চেষ্টা করুন।';

  @override
  String get verificationPendingTitle => 'যাচাইকরণ মুলতুবি';

  @override
  String get verificationPendingMessage =>
      'অনুগ্রহ করে Taxiway অফিসে আপনার KYC/যাচাইকরণ সম্পূর্ণ করুন অথবা সহায়তার সাথে যোগাযোগ করুন।';

  @override
  String get callOfficeSupport => 'অফিস / সহায়তায় কল করুন';

  @override
  String get accountSuspendedTitle => 'অ্যাকাউন্ট সাময়িকভাবে অনুপলব্ধ';

  @override
  String get accountSuspendedMessage =>
      'আরও তথ্যের জন্য অনুগ্রহ করে Taxiway সহায়তার সাথে যোগাযোগ করুন।';

  @override
  String get backToLogin => 'লগইনে ফিরে যান';

  @override
  String get driverDashboardTitle => 'ড্রাইভার ড্যাশবোর্ড';

  @override
  String get verifiedDriver => 'যাচাইকৃত ড্রাইভার';

  @override
  String get currentPlan => 'বর্তমান প্ল্যান';

  @override
  String ridesIncluded(int count) {
    return '$countটি রাইড অন্তর্ভুক্ত';
  }

  @override
  String get ridesUsed => 'ব্যবহৃত রাইড';

  @override
  String get ridesRemaining => 'অবশিষ্ট রাইড';

  @override
  String get renewalDateLabel => 'নবায়ন তারিখ';

  @override
  String get nextRide => 'পরবর্তী রাইড';

  @override
  String get noUpcomingRides => 'এই মুহূর্তে কোনো আসন্ন রাইড নেই।';

  @override
  String get customerLabel => 'গ্রাহক';

  @override
  String get expectedFare => 'প্রত্যাশিত ভাড়া';

  @override
  String get viewRideDetails => 'রাইডের বিবরণ দেখুন';

  @override
  String get callCustomer => 'গ্রাহককে কল করুন';

  @override
  String get logout => 'লগআউট';

  @override
  String get logoutConfirmTitle => 'লগআউট করবেন?';

  @override
  String get logoutConfirmMessage =>
      'আবার লগইন করতে আপনাকে আপনার নম্বর পুনরায় যাচাই করতে হবে।';

  @override
  String get myRidesTitle => 'আমার রাইড';

  @override
  String get upcomingTab => 'আসন্ন';

  @override
  String get completedTab => 'সম্পন্ন';

  @override
  String get noUpcomingRidesTitle => 'কোনো আসন্ন রাইড নেই';

  @override
  String get noCompletedRidesTitle => 'এখনো কোনো সম্পন্ন রাইড নেই';

  @override
  String get rideDetailsTitle => 'রাইডের বিবরণ';

  @override
  String get dateLabel => 'তারিখ';

  @override
  String get timeLabel => 'সময়';

  @override
  String get pickupLabel => 'পিকআপ';

  @override
  String get destinationLabel => 'গন্তব্য';

  @override
  String get vehicleLabel => 'যানবাহন';

  @override
  String get fareLabel => 'ভাড়া';

  @override
  String get paymentStatusLabel => 'পেমেন্ট স্ট্যাটাস';

  @override
  String get rideStatusLabel => 'রাইড স্ট্যাটাস';

  @override
  String get openMap => 'ম্যাপ খুলুন';

  @override
  String get markCompleted => 'সম্পন্ন হিসেবে চিহ্নিত করুন';

  @override
  String get markedCompletedToast => 'রাইড সম্পন্ন হিসেবে চিহ্নিত হয়েছে।';

  @override
  String get paid => 'পরিশোধিত';

  @override
  String get pending => 'মুলতুবি';

  @override
  String get subscriptionTitle => 'সাবস্ক্রিপশন ও পেমেন্ট';

  @override
  String get validUntil => 'মেয়াদ পর্যন্ত';

  @override
  String get thisMonthCollected => 'এই মাসে সংগৃহীত';

  @override
  String get completedRidesLabel => 'সম্পন্ন রাইড';

  @override
  String get todayCollected => 'আজ সংগৃহীত';

  @override
  String get pendingPaymentLabel => 'মুলতুবি পেমেন্ট';

  @override
  String get lastPayment => 'সর্বশেষ পেমেন্ট';

  @override
  String get paidOn => 'পরিশোধের তারিখ';

  @override
  String get nextRenewal => 'পরবর্তী নবায়ন';

  @override
  String get paymentMethodLabel => 'পেমেন্ট পদ্ধতি';

  @override
  String get renewSubscription => 'সাবস্ক্রিপশন নবায়ন করুন';

  @override
  String get renewedToast => 'সাবস্ক্রিপশন সফলভাবে নবায়ন হয়েছে!';

  @override
  String get scheduledTab => 'শিডিউল করা';

  @override
  String get noScheduledRidesTitle => 'কোনো শিডিউল করা রাইড নেই';

  @override
  String get scheduledRideDetailTitle => 'শিডিউল করা রাইড';

  @override
  String get openToAllDriversLabel =>
      'সকল যোগ্য ড্রাইভারের জন্য উন্মুক্ত — অন্য কারো আগে গ্রহণ করুন।';

  @override
  String get acceptRideLabel => 'রাইড গ্রহণ করুন';

  @override
  String get declineLabel => 'প্রত্যাখ্যান করুন';

  @override
  String get scheduledRideAcceptedToast =>
      'রাইড নিশ্চিত হয়েছে! এটি আপনার আসন্ন রাইডে যুক্ত হয়েছে।';

  @override
  String get scheduledRideUnavailableTitle => 'খুব দেরি হয়ে গেছে';

  @override
  String get scheduledRideAcceptFailedMessage =>
      'এই রাইড গ্রহণ করা যায়নি। অনুগ্রহ করে আবার চেষ্টা করুন।';

  @override
  String get scheduledRideDeclineFailedMessage =>
      'এই রাইড প্রত্যাখ্যান করা যায়নি। অনুগ্রহ করে আবার চেষ্টা করুন।';

  @override
  String get scheduledRidesAvailableTitle => 'শিডিউল করা রাইড উপলব্ধ';

  @override
  String scheduledRidesAvailableCount(int count) {
    return '$countটি রাইড ড্রাইভারের অপেক্ষায়';
  }

  @override
  String get viewAllLabel => 'সব দেখুন';

  @override
  String get paymentSuccessfulTitle => 'পেমেন্ট সফল হয়েছে';

  @override
  String get subscriptionRenewedMessage => 'আপনার প্ল্যান নবায়ন করা হয়েছে।';

  @override
  String get amountPaidLabel => 'পরিশোধিত পরিমাণ';

  @override
  String get doneLabel => 'সম্পন্ন';

  @override
  String get renewFailedToast => 'এখন নবায়ন করা যায়নি। আবার চেষ্টা করুন।';

  @override
  String get connectionOfflineTitle => 'ইন্টারনেট সংযোগ নেই';

  @override
  String get connectionSlowTitle => 'সংযোগ ধীর';

  @override
  String get connectionRestoredTitle => 'আবার অনলাইনে';

  @override
  String get connectionServerTroubleTitle =>
      'আমাদের সার্ভারে পৌঁছাতে সমস্যা হচ্ছে';

  @override
  String get connectionRetryAction => 'আবার চেষ্টা করুন';

  @override
  String get connectionCheckingAction => 'যাচাই করা হচ্ছে…';

  @override
  String get errorOfflineTitle => 'আপনি অফলাইনে আছেন';

  @override
  String get errorOfflineMessage =>
      'আপনার ওয়াই-ফাই বা মোবাইল ডেটা পরীক্ষা করে আবার চেষ্টা করুন।';

  @override
  String get errorTimeoutTitle => 'এতে বেশি সময় লাগছে';

  @override
  String get errorTimeoutMessage =>
      'আপনার সংযোগ ধীর মনে হচ্ছে। একটু পরে আবার চেষ্টা করুন।';

  @override
  String get errorServerTitle => 'আমাদের দিক থেকে সমস্যা হচ্ছে';

  @override
  String get errorServerMessage =>
      'এটি আপনার সংযোগের কারণে নয়। অনুগ্রহ করে কিছুক্ষণ পরে আবার চেষ্টা করুন।';

  @override
  String get errorMaintenanceTitle => 'শীঘ্রই ফিরে আসছি';

  @override
  String get errorMaintenanceMessage =>
      'আরও ভালো সেবা দিতে Taxiway আপডেট করা হচ্ছে।';

  @override
  String get errorGenericTitle => 'কিছু ভুল হয়েছে';

  @override
  String get errorGenericMessage =>
      'আমরা এটি লোড করতে পারিনি। অনুগ্রহ করে আবার চেষ্টা করুন।';

  @override
  String get tryAgainLabel => 'আবার চেষ্টা করুন';

  @override
  String get tryingAgainLabel => 'আবার চেষ্টা করা হচ্ছে…';

  @override
  String get goBackLabel => 'ফিরে যান';

  @override
  String get emptyDefaultTitle => 'এখানে এখনও কিছু নেই';

  @override
  String get emptyDefaultMessage => 'আইটেমগুলো এখানে দেখা যাবে।';

  @override
  String get chatEmptyTitle => 'এখনও কোনো বার্তা নেই';

  @override
  String get chatEmptyMessage => 'হ্যালো বলুন!';

  @override
  String get chatLoadFailed => 'বার্তা লোড করা যায়নি';

  @override
  String get messageSendFailed =>
      'বার্তা পাঠানো যায়নি। অনুগ্রহ করে আবার চেষ্টা করুন।';

  @override
  String get otpSendFailed =>
      'OTP পাঠানো যায়নি। অনুগ্রহ করে আবার চেষ্টা করুন।';

  @override
  String get otpResendFailed =>
      'OTP আবার পাঠানো যায়নি। অনুগ্রহ করে আবার চেষ্টা করুন।';

  @override
  String get otpVerifyFailed =>
      'কোড যাচাই করা যায়নি। অনুগ্রহ করে আবার চেষ্টা করুন।';

  @override
  String get otpExpired =>
      'এই কোডের মেয়াদ শেষ হয়েছে। অনুগ্রহ করে নতুন কোড চান।';

  @override
  String get googleSignInFailed =>
      'Google দিয়ে সাইন ইন করা যায়নি। অনুগ্রহ করে আবার চেষ্টা করুন।';

  @override
  String get supportNumberMissing => 'সাপোর্ট নম্বর এখনও সেট করা হয়নি।';

  @override
  String get supportUnreachable =>
      'এখন সাপোর্টে যোগাযোগ করা যাচ্ছে না। অনুগ্রহ করে আবার চেষ্টা করুন।';

  @override
  String get offerUnavailable => 'এই অফারটি আর উপলব্ধ নেই।';

  @override
  String get offerDeclineFailed =>
      'এই অফারটি প্রত্যাখ্যান করা যায়নি। অনুগ্রহ করে আবার চেষ্টা করুন।';

  @override
  String get offerAcceptFailed =>
      'এই অফারটি গ্রহণ করা যায়নি। অনুগ্রহ করে আবার চেষ্টা করুন।';

  @override
  String get rideCompleteFailed =>
      'এই রাইডটি সম্পন্ন হিসেবে চিহ্নিত করা যায়নি। অনুগ্রহ করে আবার চেষ্টা করুন।';

  @override
  String get offerCheckFailed => 'নতুন রাইড অফার যাচাই করা যায়নি';

  @override
  String get acceptedTitle => 'গ্রহণ করা হয়েছে';

  @override
  String get addPhoneToFinishSetup =>
      'আপনার অ্যাকাউন্ট সম্পূর্ণ করতে ফোন নম্বর যোগ করুন।';

  @override
  String get almostThere => 'প্রায় শেষ';

  @override
  String get autoFillSimNumber => 'SIM নম্বর স্বয়ংক্রিয়ভাবে পূরণ করুন';

  @override
  String get changeLabel => 'পরিবর্তন';

  @override
  String get changePhoneNumber => 'ফোন নম্বর পরিবর্তন করুন';

  @override
  String get codeResent => 'কোড আবার পাঠানো হয়েছে';

  @override
  String get continueWithGoogle => 'Google দিয়ে চালিয়ে যান';

  @override
  String get devModeNoSms => 'ডেভ মোড — SMS গেটওয়ে নেই';

  @override
  String get didntReceiveCode => 'কোড পাননি? ';

  @override
  String get driverAuthSuccess => 'ড্রাইভার যাচাইকরণ সফল!';

  @override
  String get enterCorrectMobileForOtp =>
      'নতুন OTP পেতে আপনার সঠিক মোবাইল নম্বর দিন';

  @override
  String get messageCustomer => 'গ্রাহককে বার্তা পাঠান';

  @override
  String get newRideOffer => 'নতুন রাইড অফার';

  @override
  String get newRideOfferWaiting => 'নতুন রাইড অফার অপেক্ষায়';

  @override
  String get numberUpdated => 'নম্বর আপডেট হয়েছে';

  @override
  String get onboardingDriverBody1 =>
      'সরাসরি পেমেন্ট, নিশ্চিত রাইড অনুরোধ এবং ০% কমিশনে প্রতিদিনের নির্ভরযোগ্য আয় করুন।';

  @override
  String get onboardingDriverBody2 =>
      'প্রতিটি যাত্রীর ফোন যাচাই করা, সঠিক পিকআপ রুট এবং ২৪/৭ SOS নিরাপত্তা সহায়তা পাওয়া যায়।';

  @override
  String get onboardingDriverBody3 =>
      'সাশ্রয়ী দৈনিক বা সাপ্তাহিক প্ল্যান বেছে নিন। কোনো লুকানো কাটছাঁট ছাড়াই আপনার পুরো আয় রাখুন।';

  @override
  String get onboardingDriverTitle1 => 'পাটনায় চালান এবং আয় করুন';

  @override
  String get onboardingDriverTitle2 => 'নিরাপদ ও যাচাইকৃত ট্রিপ';

  @override
  String get onboardingDriverTitle3 => 'নমনীয় সাবস্ক্রিপশন';

  @override
  String get otpVerificationTitle => 'OTP যাচাইকরণ';

  @override
  String get rideConfirmedHeadToPickup => 'রাইড নিশ্চিত! পিকআপের দিকে যান।';

  @override
  String get ridesLabel => 'রাইড';

  @override
  String get simDetected => 'SIM পাওয়া গেছে';

  @override
  String get skipLabel => 'এড়িয়ে যান';

  @override
  String get subscriptionLabel => 'সাবস্ক্রিপশন';

  @override
  String get successLabel => 'সফল';

  @override
  String get supportLabel => 'সহায়তা';

  @override
  String get typeAMessage => 'বার্তা লিখুন…';

  @override
  String get verifiedLabel => 'যাচাইকৃত';

  @override
  String get viewLabel => 'দেখুন';
}
