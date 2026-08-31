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
}
