// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'Taxiway';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageHindi => 'हिन्दी';

  @override
  String get languageBengali => 'বাংলা';

  @override
  String get languagePickerTitle => 'अपनी भाषा चुनें';

  @override
  String get languagePickerSubtitle =>
      'आप इसे होम स्क्रीन से कभी भी बदल सकते हैं।';

  @override
  String get continueLabel => 'जारी रखें';

  @override
  String get onboardSlide1Title => 'सुरक्षित। भरोसेमंद। हर समय।';

  @override
  String get onboardSlide1Subtitle =>
      'सत्यापित ड्राइवर, पारदर्शी किराया, और हर बार एक शानदार सवारी।';

  @override
  String get onboardSlide2Title => 'अपनी सवारी को लाइव ट्रैक करें';

  @override
  String get onboardSlide2Subtitle =>
      'पिकअप से ड्रॉप-ऑफ तक, अपने ड्राइवर को वास्तविक समय में आते हुए देखें।';

  @override
  String get onboardSlide3Title => 'एक टैप, कई वाहन';

  @override
  String get onboardSlide3Subtitle =>
      'अकेले सफ़र से लेकर पूरी ग्रुप बुकिंग तक, Taxiway आपके साथ बढ़ता है।';

  @override
  String get getStarted => 'शुरू करें';

  @override
  String get login => 'लॉगिन';

  @override
  String get appVersion => 'v1.0.0';

  @override
  String get welcome => 'स्वागत है!';

  @override
  String get enterPhoneSubtitle => 'जारी रखने के लिए अपना फ़ोन नंबर दर्ज करें।';

  @override
  String get enterMobileNumber => 'मोबाइल नंबर दर्ज करें';

  @override
  String get agreeToTerms => 'जारी रखकर, आप हमारी ';

  @override
  String get termsAndConditions => 'नियम व शर्तों';

  @override
  String get andWord => ' और ';

  @override
  String get privacyPolicy => 'गोपनीयता नीति';

  @override
  String get verifyYourNumber => 'अपना नंबर सत्यापित करें';

  @override
  String otpSentTo(String phone) {
    return 'हमने +91 $phone पर 6 अंकों का OTP भेजा है';
  }

  @override
  String get otpDemoHint => '(इस डेमो के लिए 123456 का उपयोग करें)';

  @override
  String resendIn(String time) {
    return '$time में पुनः भेजें';
  }

  @override
  String get resendOtp => 'OTP पुनः भेजें';

  @override
  String get verifyAndContinue => 'सत्यापित करें और जारी रखें';

  @override
  String get invalidOtp => 'गलत OTP। कृपया पुनः प्रयास करें।';

  @override
  String get otpResent => 'OTP पुनः भेज दिया गया है।';

  @override
  String get enterDestinationHint =>
      'वाहन और किराया देखने के लिए गंतव्य दर्ज करें।';

  @override
  String get bulkBookingTitle => 'बल्क बुकिंग';

  @override
  String get bulkBookingSubtitle =>
      'समूह या निर्धारित यात्रा के लिए कई वाहन बुक करें।';

  @override
  String get selectVehicle => 'वाहन चुनें';

  @override
  String get bookRide => 'सवारी बुक करें';

  @override
  String get selectAVehicle => 'एक वाहन चुनें';

  @override
  String get fromLabel => 'से';

  @override
  String get toLabel => 'तक';

  @override
  String get searchPickup => 'पिकअप खोजें';

  @override
  String get enterDestination => 'गंतव्य दर्ज करें';

  @override
  String get distanceLabel => 'दूरी';

  @override
  String get estTimeLabel => 'अनु. समय';

  @override
  String get profileTitle => 'प्रोफ़ाइल';

  @override
  String get myTrips => 'मेरी यात्राएं';

  @override
  String get helpSupport => 'सहायता और समर्थन';

  @override
  String get languageMenuItem => 'भाषा';

  @override
  String get logout => 'लॉगआउट';

  @override
  String get guest => 'अतिथि';

  @override
  String get logoutConfirmBody => 'क्या आप वाकई लॉगआउट करना चाहते हैं?';

  @override
  String get cancel => 'रद्द करें';
}
