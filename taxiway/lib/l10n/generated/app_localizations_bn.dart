// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appTitle => 'Taxiway';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageHindi => 'हिन्दी';

  @override
  String get languageBengali => 'বাংলা';

  @override
  String get languagePickerTitle => 'আপনার ভাষা নির্বাচন করুন';

  @override
  String get languagePickerSubtitle =>
      'আপনি হোম স্ক্রিন থেকে যেকোনো সময় এটি পরিবর্তন করতে পারেন।';

  @override
  String get continueLabel => 'চালিয়ে যান';

  @override
  String get onboardSlide1Title => 'নিরাপদ। নির্ভরযোগ্য। যেকোনো সময়।';

  @override
  String get onboardSlide1Subtitle =>
      'যাচাইকৃত ড্রাইভার, স্বচ্ছ ভাড়া, এবং প্রতিবার একটি আরামদায়ক যাত্রা।';

  @override
  String get onboardSlide2Title => 'আপনার যাত্রা লাইভ ট্র্যাক করুন';

  @override
  String get onboardSlide2Subtitle =>
      'পিকআপ থেকে ড্রপ-অফ পর্যন্ত, আপনার ড্রাইভারকে রিয়েল টাইমে আসতে দেখুন।';

  @override
  String get onboardSlide3Title => 'এক ট্যাপ, একাধিক গাড়ি';

  @override
  String get onboardSlide3Subtitle =>
      'একক যাত্রা থেকে সম্পূর্ণ গ্রুপ বুকিং পর্যন্ত, Taxiway আপনার সাথে বাড়ে।';

  @override
  String get getStarted => 'শুরু করুন';

  @override
  String get login => 'লগইন';

  @override
  String get appVersion => 'v1.0.0';

  @override
  String get welcome => 'স্বাগতম!';

  @override
  String get enterPhoneSubtitle => 'চালিয়ে যেতে আপনার ফোন নম্বর লিখুন।';

  @override
  String get enterMobileNumber => 'মোবাইল নম্বর লিখুন';

  @override
  String get agreeToTerms => 'চালিয়ে গেলে, আপনি আমাদের ';

  @override
  String get termsAndConditions => 'শর্তাবলী';

  @override
  String get andWord => ' এবং ';

  @override
  String get privacyPolicy => 'গোপনীয়তা নীতি';

  @override
  String get verifyYourNumber => 'আপনার নম্বর যাচাই করুন';

  @override
  String otpSentTo(String phone) {
    return 'আমরা +91 $phone নম্বরে ৬-সংখ্যার OTP পাঠিয়েছি';
  }

  @override
  String get otpDemoHint => '(এই ডেমোর জন্য 123456 ব্যবহার করুন)';

  @override
  String resendIn(String time) {
    return '$time-এ পুনরায় পাঠান';
  }

  @override
  String get resendOtp => 'OTP পুনরায় পাঠান';

  @override
  String get verifyAndContinue => 'যাচাই করুন এবং চালিয়ে যান';

  @override
  String get invalidOtp => 'ভুল OTP। আবার চেষ্টা করুন।';

  @override
  String get otpResent => 'OTP আবার পাঠানো হয়েছে।';

  @override
  String get enterDestinationHint =>
      'গাড়ি এবং ভাড়া দেখতে একটি গন্তব্য লিখুন।';

  @override
  String get bulkBookingTitle => 'বাল্ক বুকিং';

  @override
  String get bulkBookingSubtitle =>
      'গ্রুপ বা নির্ধারিত ভ্রমণের জন্য একাধিক গাড়ি বুক করুন।';

  @override
  String get selectVehicle => 'গাড়ি নির্বাচন করুন';

  @override
  String get bookRide => 'যাত্রা বুক করুন';

  @override
  String get selectAVehicle => 'একটি গাড়ি নির্বাচন করুন';

  @override
  String get fromLabel => 'থেকে';

  @override
  String get toLabel => 'পর্যন্ত';

  @override
  String get searchPickup => 'পিকআপ খুঁজুন';

  @override
  String get enterDestination => 'গন্তব্য লিখুন';

  @override
  String get distanceLabel => 'দূরত্ব';

  @override
  String get estTimeLabel => 'আনু. সময়';

  @override
  String get profileTitle => 'প্রোফাইল';

  @override
  String get myTrips => 'আমার ভ্রমণ';

  @override
  String get helpSupport => 'সাহায্য ও সহায়তা';

  @override
  String get languageMenuItem => 'ভাষা';

  @override
  String get logout => 'লগআউট';

  @override
  String get guest => 'অতিথি';

  @override
  String get logoutConfirmBody => 'আপনি কি নিশ্চিত যে আপনি লগআউট করতে চান?';

  @override
  String get cancel => 'বাতিল করুন';

  @override
  String get deleteMyAccount => 'আমার অ্যাকাউন্ট মুছুন';

  @override
  String get deleteAccountDialogTitle => 'অ্যাকাউন্ট মুছুন';

  @override
  String get deleteAccountDialogBody =>
      'এটি আপনার ব্রাউজারে একটি নিরাপদ পৃষ্ঠা খুলবে যেখানে আপনি আপনার অ্যাকাউন্ট এবং সমস্ত সম্পর্কিত ডেটা স্থায়ীভাবে মুছে ফেলতে পারবেন। এটি পূর্বাবস্থায় ফেরানো যাবে না।';

  @override
  String get continueWord => 'চালিয়ে যান';

  @override
  String seatsCountShort(int count) {
    return '$count সিট';
  }

  @override
  String get couldNotLoadVehicles => 'গাড়ি লোড করা যায়নি।';

  @override
  String seaterCount(int count) {
    return '$count সিটার';
  }

  @override
  String minutesShort(int count) {
    return '$count মিনিট';
  }

  @override
  String kmShort(String value) {
    return '$value কিমি';
  }

  @override
  String get pickupLabel => 'পিকআপ';

  @override
  String get destinationLabel => 'গন্তব্য';

  @override
  String get driverLocationLabel => 'ড্রাইভারের অবস্থান';

  @override
  String get expandMapLabel => 'ফুল স্ক্রিন';

  @override
  String get collapseMapLabel => 'ছোট করুন';

  @override
  String get fromPickupLabel => 'থেকে (পিকআপ)';

  @override
  String get toDestinationLabel => 'পর্যন্ত (গন্তব্য)';

  @override
  String get whereDoYouWantToGo => 'আপনি কোথায় যেতে চান?';

  @override
  String get baseFareLabel => 'বেস ভাড়া';

  @override
  String get timeLabel => 'সময়';

  @override
  String get tollsParkingNote => 'টোল ও পার্কিং অতিরিক্ত';

  @override
  String get pickupLocationTitle => 'পিকআপ অবস্থান';

  @override
  String get dragMapPickupHint =>
      'পিন সরাতে ম্যাপ টেনে আনুন, অথবা নিচে পিকআপ অবস্থান খুঁজুন।';

  @override
  String get searchPickupMapHint => 'প্রকৃত ম্যাপে পিকআপ অবস্থান খুঁজুন...';

  @override
  String get useCurrentGpsLocation => 'বর্তমান GPS অবস্থান ব্যবহার করুন';

  @override
  String get detectLocationAutomatically =>
      'স্বয়ংক্রিয়ভাবে অবস্থান শনাক্ত করুন';

  @override
  String closestResultsLabel(int count) {
    return 'নিকটতম ফলাফল ($count)';
  }

  @override
  String get recentPickupsLabel => 'সাম্প্রতিক পিকআপ';

  @override
  String get clearAllLabel => 'সব মুছুন';

  @override
  String get confirmPickupLabel => 'পিকআপ নিশ্চিত করুন';

  @override
  String get selectPickupLocationLabel => 'পিকআপ অবস্থান নির্বাচন করুন';

  @override
  String get noExactMatchTitle => 'ম্যাপে সঠিক মিল পাওয়া যায়নি।';

  @override
  String get dragPinToSelectHint =>
      'এই অবস্থানটি সরাসরি নির্বাচন করতে ম্যাপ পিন টেনে আনুন।';

  @override
  String get noRecentPickupsTitle => 'কোনো সাম্প্রতিক পিকআপ নেই';

  @override
  String get searchPickupAboveHint =>
      'উপরে পিকআপ খুঁজুন অথবা ম্যাপে পিন টেনে আনুন।';

  @override
  String get removeFromHistoryTooltip => 'ইতিহাস থেকে সরান';

  @override
  String get liveRouteShowingHint =>
      'নির্বাচিত গন্তব্যের লাইভ রাস্তার রুট দেখানো হচ্ছে। পরিবর্তন করতে ম্যাপে ট্যাপ করুন বা খুঁজুন।';

  @override
  String get tapMapToSeeRouteHint =>
      'লাইভ রাস্তার রুট দেখতে ম্যাপে ট্যাপ করুন বা নিচে খুঁজুন।';

  @override
  String get searchDestinationMapHint => 'প্রকৃত ম্যাপে গন্তব্য খুঁজুন...';

  @override
  String closestMatchesLabel(int count) {
    return 'নিকটতম মিল ($count)';
  }

  @override
  String get recentSearchHistoryLabel => 'সাম্প্রতিক অনুসন্ধান ইতিহাস';

  @override
  String get confirmDestinationLabel => 'গন্তব্য নিশ্চিত করুন';

  @override
  String get selectDestinationFromMapLabel =>
      'ম্যাপ / তালিকা থেকে গন্তব্য নির্বাচন করুন';

  @override
  String get tapMapDirectlyHint =>
      'এই স্থানটি নির্বাচন করতে সরাসরি ম্যাপে ট্যাপ করুন।';

  @override
  String get noRecentSearchesTitle => 'কোনো সাম্প্রতিক অনুসন্ধান নেই';

  @override
  String get typeAboveToSearchHint =>
      'প্রকৃত স্থান খুঁজতে উপরে টাইপ করুন অথবা ম্যাপে ট্যাপ করুন।';

  @override
  String get missingBookingDetails => 'বুকিং বিবরণ অনুপস্থিত।';

  @override
  String get confirmYourRide => 'আপনার যাত্রা নিশ্চিত করুন';

  @override
  String seatsCount(int count) {
    return '$count সিট';
  }

  @override
  String get acLabel => 'এসি';

  @override
  String tripDistanceValue(String value) {
    return 'ভ্রমণ দূরত্ব: $value কিমি';
  }

  @override
  String estTimeValue(String value) {
    return 'আনু. সময়: $value মিনিট';
  }

  @override
  String get paymentMethodLabel => 'পেমেন্ট পদ্ধতি';

  @override
  String get upiTitle => 'UPI (GPay, PhonePe, Paytm)';

  @override
  String get upiSubtitle =>
      'যেকোনো UPI অ্যাপ / QR কোডের মাধ্যমে সরাসরি পেমেন্ট করুন';

  @override
  String get cashPaymentTitle => 'নগদ পেমেন্ট';

  @override
  String get cashPaymentSubtitle =>
      'যাত্রা সম্পন্ন হওয়ার পর সরাসরি ড্রাইভারকে পেমেন্ট করুন';

  @override
  String get cardPaymentTitle => 'ক্রেডিট / ডেবিট কার্ড';

  @override
  String get cardPaymentSubtitle => 'Visa, MasterCard, RuPay, কর্পোরেট কার্ড';

  @override
  String confirmBookingLabel(String value) {
    return 'বুকিং নিশ্চিত করুন — $value';
  }

  @override
  String get bookingFailedTitle => 'বুকিং ব্যর্থ হয়েছে';

  @override
  String get bookingFailedMessage =>
      'এখন বুকিং সম্পন্ন করা যায়নি। আবার চেষ্টা করুন।';

  @override
  String get changeVehicleLabel => 'গাড়ি পরিবর্তন করুন';

  @override
  String get cancelRideTitle => 'যাত্রা বাতিল করবেন?';

  @override
  String get cancelRideBody =>
      'আপনি কি নিশ্চিত যে আপনি এই যাত্রা বাতিল করতে চান? ৫ মিনিটের মধ্যে কোনো বাতিলকরণ ফি প্রযোজ্য নয়।';

  @override
  String get keepRideLabel => 'যাত্রা রাখুন';

  @override
  String get cancelRideLabel => 'যাত্রা বাতিল করুন';

  @override
  String get bookingConfirmedTitle => 'বুকিং নিশ্চিত হয়েছে';

  @override
  String get noActiveBookingLabel => 'কোনো সক্রিয় বুকিং নেই।';

  @override
  String get yourBookingConfirmedHeading => 'আপনার বুকিং নিশ্চিত হয়েছে!';

  @override
  String get driverAllocatedSubtitle => 'ড্রাইভার বরাদ্দ করা হয়েছে';

  @override
  String get driverMayCallTitle => 'ড্রাইভার আপনাকে কল করতে পারেন';

  @override
  String get keepPhoneReachableSubtitle => 'অনুগ্রহ করে আপনার ফোন সচল রাখুন';

  @override
  String get liveTrackDriverLabel => 'ড্রাইভারকে লাইভ ট্র্যাক করুন';

  @override
  String reviewCountSuffix(int count) {
    return '($countটি ভ্রমণ)';
  }

  @override
  String get verifiedDriverLabel => 'যাচাইকৃত ড্রাইভার';

  @override
  String get connectingCallTitle => 'কল সংযুক্ত হচ্ছে';

  @override
  String callingDriverMessage(String name) {
    return '$name-কে কল করা হচ্ছে (+91 98765 00000)...';
  }

  @override
  String get driverOnWayHeading => 'ড্রাইভার আসছেন';

  @override
  String get driverArrivedLabel => 'ড্রাইভার পৌঁছে গেছেন!';

  @override
  String kmAwaySuffix(String value) {
    return '$value কিমি দূরে';
  }

  @override
  String get arrivingInLabel => 'আগমন';

  @override
  String get dropLabel => 'ড্রপ';

  @override
  String get findingDriverHeading => 'উপযুক্ত ড্রাইভার খোঁজা হচ্ছে...';

  @override
  String get findingDriverSubtitle => 'এটি সাধারণত কয়েক সেকেন্ড সময় নেয়।';

  @override
  String get cancelRequestLabel => 'অনুরোধ বাতিল করুন';

  @override
  String get bookNow => 'এখনই বুক করুন';

  @override
  String get scheduleForLater => 'পরে সময় নির্ধারণ করুন';

  @override
  String get scheduleRide => 'রাইড শিডিউল করুন';

  @override
  String get scheduleTooSoonError =>
      'অনুগ্রহ করে এখন থেকে অন্তত ৩০ মিনিট পরের সময় বেছে নিন।';

  @override
  String get scheduleTooFarError =>
      'শিডিউলিং শুধুমাত্র ৭ দিন আগে পর্যন্ত করা যায়।';

  @override
  String get noVehiclesMatchFilter => 'এই ফিল্টারের সাথে কোনো গাড়ি মিলছে না।';

  @override
  String get seatsFilterAny => 'যেকোনো';

  @override
  String seatsFilterPlus(int count) {
    return '$count+ সিট';
  }

  @override
  String get upcomingScheduledRideTitle => 'আসন্ন শিডিউল করা রাইড';

  @override
  String get waitingForDriverLabel => 'ড্রাইভারের জন্য অপেক্ষা করা হচ্ছে...';

  @override
  String driverAssignedNameLabel(String name) {
    return 'ড্রাইভার: $name';
  }

  @override
  String scheduledForLabel(String value) {
    return '$value এর জন্য শিডিউল করা হয়েছে';
  }

  @override
  String get addEmailForReceiptLabel =>
      'বুকিং রসিদের জন্য আপনার ইমেইল যোগ করুন';

  @override
  String get emailOptionalHint => 'you@example.com (ঐচ্ছিক)';

  @override
  String get validationEmailInvalid => 'অনুগ্রহ করে একটি বৈধ ইমেইল ঠিকানা দিন।';

  @override
  String get scheduledRideConfirmationToast =>
      'আপনার রাইড শিডিউল করা হয়েছে! একজন ড্রাইভার গ্রহণ করলেই আমরা আপনাকে জানাব।';

  @override
  String get profileSetupTitle => 'আপনার সম্পর্কে বলুন';

  @override
  String get profileSetupSubtitle =>
      'শুধু প্রয়োজনীয় তথ্য। আপনি যেকোনো সময় বদলাতে পারবেন।';

  @override
  String get fullNameLabel => 'পূর্ণ নাম';

  @override
  String get fullNameHint => 'আপনার পূর্ণ নাম লিখুন';

  @override
  String get emailOptionalLabel => 'ইমেইল (ঐচ্ছিক)';

  @override
  String get emailHint => 'আপনার ইমেইল লিখুন';

  @override
  String profileSavedTitle(String name) {
    return 'সব প্রস্তুত, $name';
  }

  @override
  String get profileSavedMessage => 'আপনার অ্যাকাউন্ট প্রস্তুত।';

  @override
  String get startRidingButton => 'যাত্রা শুরু করুন';

  @override
  String get profileSaveError =>
      'আপনার প্রোফাইল সংরক্ষণ করা যায়নি। আবার চেষ্টা করুন।';

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
  String get bookARideAction => 'রাইড বুক করুন';

  @override
  String get emptyDefaultTitle => 'এখানে এখনও কিছু নেই';

  @override
  String get emptyDefaultMessage => 'আইটেমগুলো এখানে দেখা যাবে।';

  @override
  String get tripsEmptyTitle => 'এখনও কোনো ট্রিপ নেই';

  @override
  String get tripsEmptyMessage => 'আপনার বুকিংগুলো এখানে দেখা যাবে।';

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
  String get chooseOnMapLabel => 'ম্যাপে বেছে নিন';

  @override
  String get yourRouteTitle => 'আপনার রুট';

  @override
  String get rideCompleteTitle => 'রাইড সম্পন্ন';

  @override
  String get thanksForRidingLabel => 'Taxiway-এর সাথে ভ্রমণ করার জন্য ধন্যবাদ';

  @override
  String rateYourRideWith(String name) {
    return '$name-এর সাথে আপনার রাইড কেমন ছিল?';
  }

  @override
  String get doneLabel => 'সম্পন্ন';

  @override
  String get viewReceiptLabel => 'রসিদ দেখুন';

  @override
  String paidWithLabel(String method) {
    return '$method দিয়ে পরিশোধ';
  }

  @override
  String get aboutDriver => 'ড্রাইভার সম্পর্কে';

  @override
  String get addPhoneToFinishSetup =>
      'আপনার অ্যাকাউন্ট সম্পূর্ণ করতে ফোন নম্বর যোগ করুন।';

  @override
  String get addSpecialNotesOptional =>
      'বিশেষ নোট / নির্দেশনা যোগ করুন (ঐচ্ছিক)';

  @override
  String get addTipOptional => 'টিপ যোগ করুন (ঐচ্ছিক)';

  @override
  String get additionalRequirements => 'অতিরিক্ত প্রয়োজনীয়তা';

  @override
  String get almostThere => 'প্রায় শেষ';

  @override
  String get approxPassengers => 'আনুমানিক যাত্রী';

  @override
  String get arrangingVehiclesNote =>
      'আমরা আপনার ট্রিপের জন্য গাড়ি ঠিক করছি। অফার তৈরি হলে আপনাকে জানানো হবে।';

  @override
  String get assignedVehicle => 'বরাদ্দকৃত গাড়ি';

  @override
  String get autoFillSimNumber => 'SIM নম্বর স্বয়ংক্রিয়ভাবে পূরণ করুন';

  @override
  String get backToHome => 'হোমে ফিরে যান';

  @override
  String get backgroundChecked => 'ব্যাকগ্রাউন্ড যাচাই সম্পন্ন';

  @override
  String get bulkBookingConfirmedTitle => 'বাল্ক বুকিং নিশ্চিত';

  @override
  String get bulkRequestSubmittedHeading =>
      'আপনার বাল্ক বুকিং অনুরোধ জমা হয়েছে!';

  @override
  String get bulkRequestSubmittedToast =>
      'বাল্ক বুকিং অনুরোধ পর্যালোচনার জন্য জমা হয়েছে!';

  @override
  String get bulkRequestTitle => 'বাল্ক অনুরোধ';

  @override
  String get callDriver => 'ড্রাইভারকে কল করুন';

  @override
  String get callLabel => 'কল করুন';

  @override
  String get callingDriverToast => 'ড্রাইভারকে কল করা হচ্ছে...';

  @override
  String get cancelRideAction => 'রাইড বাতিল করুন';

  @override
  String get changeLabel => 'পরিবর্তন';

  @override
  String get changePhoneNumber => 'ফোন নম্বর পরিবর্তন করুন';

  @override
  String get chatLabel => 'চ্যাট';

  @override
  String get checkVehicleNumberBeforeBoarding =>
      'ওঠার আগে গাড়ির নম্বর যাচাই করে নিন।';

  @override
  String get checkingSimForNumber => 'আপনার SIM-এ ফোন নম্বর খোঁজা হচ্ছে…';

  @override
  String get chooseTravelSchedule => 'আপনার ভ্রমণের সময়সূচি বেছে নিন';

  @override
  String get codeResent => 'কোড আবার পাঠানো হয়েছে';

  @override
  String get completionLabel => 'সম্পূর্ণতার হার';

  @override
  String get confirmBooking => 'বুকিং নিশ্চিত করুন';

  @override
  String get confirmDateAndSchedule => 'তারিখ ও সময় নিশ্চিত করুন';

  @override
  String get contactPerson => 'যোগাযোগের ব্যক্তি';

  @override
  String get contactSupport => 'সহায়তায় যোগাযোগ করুন';

  @override
  String get contactSupportRequestChange =>
      'সহায়তায় যোগাযোগ করুন / পরিবর্তনের অনুরোধ';

  @override
  String get continueWithGoogle => 'Google দিয়ে চালিয়ে যান';

  @override
  String get devModeNoSms => 'ডেভ মোড — SMS গেটওয়ে নেই';

  @override
  String get didntReceiveCode => 'কোড পাননি? ';

  @override
  String get driverAndVehicle => 'ড্রাইভার ও গাড়ি';

  @override
  String get driverAndVehicleList => 'ড্রাইভার ও গাড়ির তালিকা';

  @override
  String get driverArrivedTitle => 'ড্রাইভার পৌঁছে গেছে';

  @override
  String get driverProfileAndReviews => 'ড্রাইভার প্রোফাইল ও রিভিউ';

  @override
  String get enterCorrectMobileForOtp =>
      'নতুন OTP পেতে আপনার সঠিক মোবাইল নম্বর দিন';

  @override
  String get enterPhoneToContinue => 'চালিয়ে যেতে\nআপনার ফোন নম্বর দিন';

  @override
  String get estimatedFareRange => 'আনুমানিক ভাড়ার সীমা';

  @override
  String get estimatedOnlyNote =>
      'শুধু আনুমানিক। গাড়ি নিশ্চিত হওয়ার পর চূড়ান্ত অফার বদলাতে পারে।';

  @override
  String get experienceLabel => 'অভিজ্ঞতা';

  @override
  String get fareInvoice => 'ভাড়ার ইনভয়েস';

  @override
  String get feedbackSubmitted => 'মতামত জমা হয়েছে';

  @override
  String get fetchingYourNumber => 'আপনার নম্বর আনা হচ্ছে';

  @override
  String get filterAll => 'সব';

  @override
  String get filterCancelled => 'বাতিল';

  @override
  String get helpCenter => 'হেল্প সেন্টার';

  @override
  String get helpIntro =>
      'জনপ্রিয় বিষয় দেখুন বা সরাসরি আমাদের সহায়তা দলের সঙ্গে যোগাযোগ করুন।';

  @override
  String get helplineCalling => 'হেল্পলাইন কল';

  @override
  String get howCanWeHelp => 'আমরা আপনাকে কীভাবে সাহায্য করতে পারি?';

  @override
  String get howWasYourRide => 'আপনার রাইড কেমন ছিল?';

  @override
  String get identityVerified => 'পরিচয় যাচাইকৃত';

  @override
  String get includedCharges => 'অন্তর্ভুক্ত চার্জ';

  @override
  String get journeyDate => 'যাত্রার তারিখ';

  @override
  String get journeyTime => 'যাত্রার সময়';

  @override
  String get licenceVerified => 'ড্রাইভিং লাইসেন্স যাচাইকৃত';

  @override
  String get linkShared => 'লিঙ্ক শেয়ার করা হয়েছে';

  @override
  String get messageLabel => 'বার্তা';

  @override
  String get messagingDriverToast => 'ড্রাইভারকে বার্তা পাঠানো হচ্ছে...';

  @override
  String get noCompletedRideFound => 'কোনো সম্পন্ন রাইড পাওয়া যায়নি।';

  @override
  String get noConfirmedBookingFound => 'কোনো নিশ্চিত বুকিং পাওয়া যায়নি।';

  @override
  String get noOfferAvailable => 'কোনো অফার নেই।';

  @override
  String get noOfferYet => 'এখনও কোনো অফার নেই।';

  @override
  String get noRequestFound => 'কোনো অনুরোধ পাওয়া যায়নি।';

  @override
  String get noReviewsYet => 'এখনও কোনো রিভিউ নেই।';

  @override
  String get noVideosYet => 'এখনও কোনো ভিডিও নেই।';

  @override
  String get noteForDriverHint => 'ড্রাইভারের জন্য নোট লিখুন (ঐচ্ছিক)...';

  @override
  String get numberOfVehicles => 'গাড়ির সংখ্যা';

  @override
  String get numberUpdated => 'নম্বর আপডেট হয়েছে';

  @override
  String get offerDetails => 'অফারের বিবরণ';

  @override
  String get offersReceived => 'প্রাপ্ত অফার';

  @override
  String get onboardingRiderBody1 =>
      'বিমানবন্দর, স্টেশন বা আপনার পছন্দের জায়গা, যেকোনো গন্তব্যে তখনই ক্যাব বুক করুন।';

  @override
  String get onboardingRiderBody2 =>
      'প্রতিটি ড্রাইভারের ব্যাকগ্রাউন্ড যাচাই করা হয় এবং আপনার মতো যাত্রীরা রেটিং দেন, যাতে আপনি নিশ্চিন্ত থাকেন।';

  @override
  String get onboardingRiderBody3 =>
      'সার্জ প্রাইসিংয়ের কোনো চমক নেই। বুক করার আগে সম্পূর্ণ ভাড়ার বিবরণ দেখুন।';

  @override
  String get onboardingRiderTitle1 => 'পাটনায় যেকোনো জায়গায় রাইড নিন';

  @override
  String get onboardingRiderTitle2 => 'নিরাপদ ও যাচাইকৃত ড্রাইভার';

  @override
  String get onboardingRiderTitle3 => 'স্বচ্ছ মূল্য';

  @override
  String get oneWay => 'একমুখী';

  @override
  String get otpVerificationTitle => 'OTP যাচাইকরণ';

  @override
  String get passengerReviews => 'যাত্রীদের রিভিউ';

  @override
  String get phoneCallTitle => 'ফোন কল';

  @override
  String get phoneVerifiedSuccess => 'ফোন সফলভাবে যাচাই হয়েছে!';

  @override
  String get photosLabel => 'ছবি';

  @override
  String get pickupTimeSlot => 'পিকআপের সময় স্লট';

  @override
  String get rateAndReview => 'রেটিং ও রিভিউ';

  @override
  String get ratingDistribution => 'রেটিংয়ের বণ্টন';

  @override
  String get ratingLabel => 'রেটিং';

  @override
  String get removeLabel => 'সরান';

  @override
  String get requestSent => 'অনুরোধ পাঠানো হয়েছে';

  @override
  String get resendOtpIn => 'OTP আবার পাঠান: ';

  @override
  String get reviewRequest => 'অনুরোধ পর্যালোচনা';

  @override
  String get reviewsLabel => 'রিভিউ';

  @override
  String get roundTrip => 'রাউন্ড ট্রিপ';

  @override
  String get selectDateAndTime => 'তারিখ ও সময় বেছে নিন';

  @override
  String get shareTrip => 'ট্রিপ শেয়ার করুন';

  @override
  String get shareWithDriverToStart => 'রাইড শুরু করতে ড্রাইভারকে জানান';

  @override
  String get simAutoFill => 'SIM থেকে স্বয়ংক্রিয় পূরণ';

  @override
  String get skipLabel => 'এড়িয়ে যান';

  @override
  String get sosAlertSent => 'SOS অ্যালার্ট পাঠানো হয়েছে';

  @override
  String get sosAlertToast =>
      'জরুরি SOS অ্যালার্ট পাঠানো হয়েছে! ২৪x৭ সহায়তা ও পুলিশকে জানানো হয়েছে।';

  @override
  String get sosLabel => 'SOS';

  @override
  String get specialNotesHint =>
      'যেমন: অতিরিক্ত মালপত্রের জায়গা, বিমানবন্দরের ফ্লাইটের তথ্য, ইংরেজি বলা ড্রাইভার...';

  @override
  String get specialNotesOptional => 'বিশেষ নোট (ঐচ্ছিক)';

  @override
  String get startRideOtp => 'রাইড শুরুর OTP';

  @override
  String get stillNeedHelp => 'এখনও সাহায্য দরকার?';

  @override
  String get submitRequest => 'অনুরোধ জমা দিন';

  @override
  String get submitReview => 'রিভিউ জমা দিন';

  @override
  String get successLabel => 'সফল';

  @override
  String get supportLabel => 'সহায়তা';

  @override
  String get thanksForRatingToast => 'আপনার রাইডে রেটিং দেওয়ার জন্য ধন্যবাদ!';

  @override
  String get thisWeekend => 'এই সপ্তাহান্তে';

  @override
  String get todayLabel => 'আজ';

  @override
  String get tomorrowLabel => 'আগামীকাল';

  @override
  String get totalFare => 'মোট ভাড়া';

  @override
  String get totalTrips => 'মোট ট্রিপ';

  @override
  String get tripDetails => 'ট্রিপের বিবরণ';

  @override
  String get tripHistory => 'ট্রিপের ইতিহাস';

  @override
  String get tripLinkCopiedToast => 'লাইভ ট্রিপ ট্র্যাকিং লিঙ্ক কপি হয়েছে!';

  @override
  String get tripsLabel => 'ট্রিপ';

  @override
  String get typeAMessage => 'বার্তা লিখুন…';

  @override
  String get vehicleGallery => 'গাড়ির গ্যালারি';

  @override
  String get vehiclePhotos => 'গাড়ির ছবি';

  @override
  String get vehiclesAvailable => 'উপলব্ধ গাড়ি';

  @override
  String get verificationLabel => 'যাচাইকরণ';

  @override
  String get verifiedDriverOnline => 'যাচাইকৃত ড্রাইভার · অনলাইন';

  @override
  String get verifiedLabel => 'যাচাইকৃত';

  @override
  String get videosLabel => 'ভিডিও';

  @override
  String get viewDetails => 'বিস্তারিত দেখুন';

  @override
  String get viewMyRequest => 'আমার অনুরোধ দেখুন';

  @override
  String get viewVehicle => 'গাড়ি দেখুন';

  @override
  String get weSentSixDigitOtp => 'আমরা ৬ সংখ্যার OTP পাঠিয়েছি:';

  @override
  String get weWillNotifyVehicles =>
      'উপযুক্ত গাড়ি ও ড্রাইভার পাওয়া গেলে আমরা আপনাকে জানাব।';

  @override
  String get welcomeTitle => 'স্বাগতম';

  @override
  String get wereHereForYou => 'আমরা আপনার পাশে আছি।';

  @override
  String get whatWentWell => 'কী ভালো ছিল?';

  @override
  String get yearsExp => 'বছরের অভিজ্ঞতা';

  @override
  String get yourDriverHasArrived => 'আপনার ড্রাইভার পৌঁছে গেছে';

  @override
  String get yourDrivers => 'আপনার ড্রাইভার';

  @override
  String get yourRating => 'আপনার রেটিং';

  @override
  String get backgroundCheck => 'ব্যাকগ্রাউন্ড যাচাই';

  @override
  String get bookingId => 'বুকিং ID';

  @override
  String get contactLabel => 'যোগাযোগ';

  @override
  String get dateLabel => 'তারিখ';

  @override
  String get distanceFare => 'দূরত্বের ভাড়া';

  @override
  String get driverLabelShort => 'ড্রাইভার';

  @override
  String get drivingLicense => 'ড্রাইভিং লাইসেন্স';

  @override
  String get durationLabel => 'সময়কাল';

  @override
  String get gpsEnabled => 'GPS চালু';

  @override
  String get languagesLabel => 'ভাষা';

  @override
  String get livesIn => 'বসবাস';

  @override
  String get memberSinceLabel => 'সদস্য হয়েছেন';

  @override
  String get nameLabel => 'নাম';

  @override
  String get nonSmoking => 'ধূমপানমুক্ত';

  @override
  String get notesLabel => 'নোট';

  @override
  String get passengersLabel => 'যাত্রী';

  @override
  String get paymentStatusLabel => 'পেমেন্টের অবস্থা';

  @override
  String get requestId => 'অনুরোধ ID';

  @override
  String get requirementsLabel => 'প্রয়োজনীয়তা';

  @override
  String get routeLabel => 'রুট';

  @override
  String get statusCompleted => 'সম্পন্ন';

  @override
  String get statusLabel => 'অবস্থা';

  @override
  String get statusUpcoming => 'আসন্ন';

  @override
  String get timeFare => 'সময়ের ভাড়া';

  @override
  String get totalCapacity => 'মোট ধারণক্ষমতা';

  @override
  String get totalPaid => 'মোট পরিশোধ';

  @override
  String get tripType => 'ট্রিপের ধরন';

  @override
  String get vehiclesConfirmed => 'নিশ্চিত গাড়ি';

  @override
  String get vehiclesLabel => 'গাড়ি';

  @override
  String get viewAllLabel => 'সব দেখুন';

  @override
  String devOtpLabel(String otp) {
    return 'OTP: $otp';
  }

  @override
  String newOtpSentTo(String phone) {
    return 'নতুন OTP +91 $phone নম্বরে পাঠানো হয়েছে';
  }

  @override
  String numberAutoFilledFromSim(String number) {
    return 'নম্বর +91 $number SIM থেকে স্বয়ংক্রিয়ভাবে পূরণ হয়েছে';
  }

  @override
  String memberSinceDate(String date) {
    return '$date থেকে সদস্য';
  }

  @override
  String connectingHelpline(String number) {
    return 'Taxiway হেল্পলাইনে সংযোগ করা হচ্ছে: $number...';
  }

  @override
  String openingGuideFor(String topic) {
    return '\"$topic\"-এর গাইড ও FAQ খোলা হচ্ছে...';
  }

  @override
  String waitingAtPlace(String place) {
    return '$place-এ অপেক্ষা করছে';
  }

  @override
  String callingPerson(String name) {
    return '$name-কে কল করা হচ্ছে...';
  }

  @override
  String meetAtPickupIn(int minutes) {
    return '$minutes মিনিটে পিকআপে দেখা করুন';
  }

  @override
  String kmAway(String km) {
    return '$km কিমি দূরে';
  }

  @override
  String messagePerson(String name) {
    return '$name-কে বার্তা পাঠান';
  }

  @override
  String withPerson(String name) {
    return '$name-এর সাথে';
  }

  @override
  String headingToPlace(String place) {
    return '$place-এর দিকে যাচ্ছেন';
  }

  @override
  String arriveSummary(String time, int minutes, String km) {
    return '$time-এ পৌঁছাবেন · $minutes মিনিট · $km কিমি বাকি';
  }

  @override
  String tripNumber(String id) {
    return 'ট্রিপ #$id';
  }

  @override
  String get pendingLabel => 'অপেক্ষমাণ';

  @override
  String get paidLabel => 'পরিশোধিত';

  @override
  String get statusFailed => 'ব্যর্থ';

  @override
  String get statusSubmitted => 'জমা দেওয়া হয়েছে';

  @override
  String get statusUnderReview => 'পর্যালোচনাধীন';

  @override
  String get statusOfferReady => 'অফার প্রস্তুত';

  @override
  String get statusConfirmed => 'নিশ্চিত';

  @override
  String get mediaFront => 'সামনে';

  @override
  String get mediaRear => 'পেছনে';

  @override
  String get mediaLeftSide => 'বাম পাশ';

  @override
  String get mediaRightSide => 'ডান পাশ';

  @override
  String get relativeToday => 'আজ';

  @override
  String get relativeOneDayAgo => '১ দিন আগে';

  @override
  String relativeDaysAgo(int count) {
    return '$count দিন আগে';
  }

  @override
  String relativeWeeksAgo(int count) {
    return '$count সপ্তাহ আগে';
  }

  @override
  String relativeMonthsAgo(int count) {
    return '$count মাস আগে';
  }

  @override
  String perMonthPrice(String price) {
    return '$price / মাস';
  }
}
