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
}
