// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'राइडगो ड्राइवर';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageHindi => 'हिन्दी';

  @override
  String get languageBengali => 'বাংলা';

  @override
  String get languagePickerTitle => 'अपनी भाषा चुनें';

  @override
  String get driverLoginTitle => 'ड्राइवर लॉगिन';

  @override
  String get enterMobileNumber => 'मोबाइल नंबर दर्ज करें';

  @override
  String get continueLabel => 'जारी रखें';

  @override
  String get unregisteredNumberError =>
      'यह नंबर ड्राइवर के रूप में पंजीकृत नहीं है। कृपया ऑफिस से संपर्क करें।';

  @override
  String get verifyMobileNumber => 'मोबाइल नंबर सत्यापित करें';

  @override
  String otpSentTo(String phone) {
    return 'हमने +91 $phone पर 6 अंकों का OTP भेजा है';
  }

  @override
  String get otpDemoHint => '(डेमो के लिए 123456 का उपयोग करें)';

  @override
  String get loginLabel => 'लॉगिन';

  @override
  String get resendOtp => 'OTP फिर से भेजें';

  @override
  String resendIn(String time) {
    return '00:$time में OTP फिर से भेजें';
  }

  @override
  String get canResendNow => 'अब आप OTP फिर से भेज सकते हैं';

  @override
  String get invalidOtp => 'गलत OTP। कृपया पुनः प्रयास करें।';

  @override
  String get verificationPendingTitle => 'सत्यापन लंबित है';

  @override
  String get verificationPendingMessage =>
      'कृपया अपना KYC/सत्यापन Taxiway ऑफिस में पूरा करें या सहायता से संपर्क करें।';

  @override
  String get callOfficeSupport => 'ऑफिस / सहायता को कॉल करें';

  @override
  String get accountSuspendedTitle => 'खाता अस्थायी रूप से अनुपलब्ध है';

  @override
  String get accountSuspendedMessage =>
      'अधिक जानकारी के लिए कृपया Taxiway सहायता से संपर्क करें।';

  @override
  String get backToLogin => 'लॉगिन पर वापस जाएं';

  @override
  String get driverDashboardTitle => 'ड्राइवर डैशबोर्ड';

  @override
  String get verifiedDriver => 'सत्यापित ड्राइवर';

  @override
  String get currentPlan => 'वर्तमान प्लान';

  @override
  String ridesIncluded(int count) {
    return '$count राइड्स शामिल';
  }

  @override
  String get ridesUsed => 'राइड्स उपयोग की गईं';

  @override
  String get ridesRemaining => 'शेष राइड्स';

  @override
  String get renewalDateLabel => 'नवीनीकरण तिथि';

  @override
  String get nextRide => 'अगली राइड';

  @override
  String get noUpcomingRides => 'अभी कोई आगामी राइड नहीं है।';

  @override
  String get customerLabel => 'ग्राहक';

  @override
  String get expectedFare => 'अनुमानित किराया';

  @override
  String get viewRideDetails => 'राइड विवरण देखें';

  @override
  String get callCustomer => 'ग्राहक को कॉल करें';

  @override
  String get logout => 'लॉगआउट';

  @override
  String get logoutConfirmTitle => 'लॉगआउट करें?';

  @override
  String get logoutConfirmMessage =>
      'फिर से लॉगिन करने के लिए आपको अपना नंबर दोबारा सत्यापित करना होगा।';

  @override
  String get myRidesTitle => 'मेरी राइड्स';

  @override
  String get upcomingTab => 'आगामी';

  @override
  String get completedTab => 'पूर्ण';

  @override
  String get noUpcomingRidesTitle => 'कोई आगामी राइड नहीं';

  @override
  String get noCompletedRidesTitle => 'अभी तक कोई पूर्ण राइड नहीं';

  @override
  String get rideDetailsTitle => 'राइड विवरण';

  @override
  String get dateLabel => 'तारीख';

  @override
  String get timeLabel => 'समय';

  @override
  String get pickupLabel => 'पिकअप';

  @override
  String get destinationLabel => 'गंतव्य';

  @override
  String get vehicleLabel => 'वाहन';

  @override
  String get fareLabel => 'किराया';

  @override
  String get paymentStatusLabel => 'भुगतान स्थिति';

  @override
  String get rideStatusLabel => 'राइड स्थिति';

  @override
  String get openMap => 'मैप खोलें';

  @override
  String get markCompleted => 'पूर्ण के रूप में चिह्नित करें';

  @override
  String get markedCompletedToast => 'राइड पूर्ण के रूप में चिह्नित की गई।';

  @override
  String get paid => 'भुगतान हो गया';

  @override
  String get pending => 'लंबित';

  @override
  String get subscriptionTitle => 'सदस्यता और भुगतान';

  @override
  String get validUntil => 'मान्य है जब तक';

  @override
  String get thisMonthCollected => 'इस महीने एकत्रित';

  @override
  String get completedRidesLabel => 'पूर्ण राइड्स';

  @override
  String get todayCollected => 'आज एकत्रित';

  @override
  String get pendingPaymentLabel => 'लंबित भुगतान';

  @override
  String get lastPayment => 'अंतिम भुगतान';

  @override
  String get paidOn => 'भुगतान तिथि';

  @override
  String get nextRenewal => 'अगला नवीनीकरण';

  @override
  String get paymentMethodLabel => 'भुगतान का तरीका';

  @override
  String get renewSubscription => 'सदस्यता नवीनीकृत करें';

  @override
  String get renewedToast => 'सदस्यता सफलतापूर्वक नवीनीकृत हुई!';

  @override
  String get scheduledTab => 'शेड्यूल्ड';

  @override
  String get noScheduledRidesTitle => 'कोई शेड्यूल्ड राइड नहीं';

  @override
  String get scheduledRideDetailTitle => 'शेड्यूल्ड राइड';

  @override
  String get openToAllDriversLabel =>
      'सभी योग्य ड्राइवरों के लिए खुला है — किसी और से पहले स्वीकार करें।';

  @override
  String get acceptRideLabel => 'राइड स्वीकार करें';

  @override
  String get declineLabel => 'अस्वीकार करें';

  @override
  String get scheduledRideAcceptedToast =>
      'राइड की पुष्टि हो गई! यह आपकी आगामी राइड्स में है।';

  @override
  String get scheduledRideUnavailableTitle => 'बहुत देर हो गई';

  @override
  String get scheduledRideAcceptFailedMessage =>
      'यह राइड स्वीकार नहीं की जा सकी। कृपया पुनः प्रयास करें।';

  @override
  String get scheduledRideDeclineFailedMessage =>
      'यह राइड अस्वीकार नहीं की जा सकी। कृपया पुनः प्रयास करें।';

  @override
  String get scheduledRidesAvailableTitle => 'शेड्यूल्ड राइड उपलब्ध हैं';

  @override
  String scheduledRidesAvailableCount(int count) {
    return '$count राइड ड्राइवर की प्रतीक्षा में';
  }

  @override
  String get viewAllLabel => 'सभी देखें';
}
