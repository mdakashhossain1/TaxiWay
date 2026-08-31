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
}
