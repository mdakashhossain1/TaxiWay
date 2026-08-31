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

  @override
  String get deleteMyAccount => 'मेरा खाता हटाएं';

  @override
  String get deleteAccountDialogTitle => 'खाता हटाएं';

  @override
  String get deleteAccountDialogBody =>
      'यह आपके ब्राउज़र में एक सुरक्षित पेज खोलेगा जहां आप अपना खाता और सभी संबंधित डेटा स्थायी रूप से हटा सकते हैं। इसे पूर्ववत नहीं किया जा सकता।';

  @override
  String get continueWord => 'जारी रखें';

  @override
  String seatsCountShort(int count) {
    return '$count सीटें';
  }

  @override
  String get couldNotLoadVehicles => 'वाहन लोड नहीं हो सके।';

  @override
  String seaterCount(int count) {
    return '$count सीटर';
  }

  @override
  String minutesShort(int count) {
    return '$count मिनट';
  }

  @override
  String kmShort(String value) {
    return '$value किमी';
  }

  @override
  String get pickupLabel => 'पिकअप';

  @override
  String get destinationLabel => 'गंतव्य';

  @override
  String get driverLocationLabel => 'ड्राइवर का स्थान';

  @override
  String get expandMapLabel => 'फुल स्क्रीन';

  @override
  String get collapseMapLabel => 'छोटा करें';

  @override
  String get fromPickupLabel => 'से (पिकअप)';

  @override
  String get toDestinationLabel => 'तक (गंतव्य)';

  @override
  String get whereDoYouWantToGo => 'आप कहाँ जाना चाहते हैं?';

  @override
  String get baseFareLabel => 'बेस किराया';

  @override
  String get timeLabel => 'समय';

  @override
  String get tollsParkingNote => 'टोल और पार्किंग अतिरिक्त';

  @override
  String get pickupLocationTitle => 'पिकअप स्थान';

  @override
  String get dragMapPickupHint =>
      'पिन हटाने के लिए मैप को खींचें, या नीचे पिकअप स्थान खोजें।';

  @override
  String get searchPickupMapHint => 'वास्तविक मैप पर पिकअप स्थान खोजें...';

  @override
  String get useCurrentGpsLocation => 'वर्तमान GPS स्थान उपयोग करें';

  @override
  String get detectLocationAutomatically => 'स्वचालित रूप से स्थान पहचानें';

  @override
  String closestResultsLabel(int count) {
    return 'निकटतम परिणाम ($count)';
  }

  @override
  String get recentPickupsLabel => 'हाल के पिकअप';

  @override
  String get clearAllLabel => 'सभी हटाएं';

  @override
  String get confirmPickupLabel => 'पिकअप की पुष्टि करें';

  @override
  String get selectPickupLocationLabel => 'पिकअप स्थान चुनें';

  @override
  String get noExactMatchTitle => 'मैप पर कोई सटीक मिलान नहीं मिला।';

  @override
  String get dragPinToSelectHint =>
      'इस स्थान को सीधे चुनने के लिए मैप पिन खींचें।';

  @override
  String get noRecentPickupsTitle => 'कोई हाल का पिकअप नहीं';

  @override
  String get searchPickupAboveHint => 'ऊपर पिकअप खोजें या मैप पर पिन खींचें।';

  @override
  String get removeFromHistoryTooltip => 'इतिहास से हटाएं';

  @override
  String get liveRouteShowingHint =>
      'चयनित गंतव्य के लिए लाइव सड़क मार्ग दिखाया जा रहा है। बदलने के लिए मैप पर टैप करें या खोजें।';

  @override
  String get tapMapToSeeRouteHint =>
      'लाइव सड़क मार्ग देखने के लिए मैप पर टैप करें या नीचे खोजें।';

  @override
  String get searchDestinationMapHint => 'वास्तविक मैप पर गंतव्य खोजें...';

  @override
  String closestMatchesLabel(int count) {
    return 'निकटतम मिलान ($count)';
  }

  @override
  String get recentSearchHistoryLabel => 'हाल की खोज इतिहास';

  @override
  String get confirmDestinationLabel => 'गंतव्य की पुष्टि करें';

  @override
  String get selectDestinationFromMapLabel => 'मैप / सूची से गंतव्य चुनें';

  @override
  String get tapMapDirectlyHint =>
      'इस स्थान को चुनने के लिए सीधे मैप पर टैप करें।';

  @override
  String get noRecentSearchesTitle => 'कोई हाल की खोज नहीं';

  @override
  String get typeAboveToSearchHint =>
      'वास्तविक स्थान खोजने के लिए ऊपर टाइप करें या मैप पर टैप करें।';

  @override
  String get missingBookingDetails => 'बुकिंग विवरण गुम है।';

  @override
  String get confirmYourRide => 'अपनी सवारी की पुष्टि करें';

  @override
  String seatsCount(int count) {
    return '$count सीटें';
  }

  @override
  String get acLabel => 'एसी';

  @override
  String tripDistanceValue(String value) {
    return 'यात्रा दूरी: $value किमी';
  }

  @override
  String estTimeValue(String value) {
    return 'अनु. समय: $value मिनट';
  }

  @override
  String get paymentMethodLabel => 'भुगतान विधि';

  @override
  String get upiTitle => 'UPI (GPay, PhonePe, Paytm)';

  @override
  String get upiSubtitle => 'किसी भी UPI ऐप / QR कोड से सीधे भुगतान करें';

  @override
  String get cashPaymentTitle => 'नकद भुगतान';

  @override
  String get cashPaymentSubtitle =>
      'यात्रा पूरी होने के बाद सीधे ड्राइवर को भुगतान करें';

  @override
  String get cardPaymentTitle => 'क्रेडिट / डेबिट कार्ड';

  @override
  String get cardPaymentSubtitle => 'Visa, MasterCard, RuPay, कॉर्पोरेट कार्ड';

  @override
  String confirmBookingLabel(String value) {
    return 'बुकिंग की पुष्टि करें — $value';
  }

  @override
  String get bookingFailedTitle => 'बुकिंग विफल';

  @override
  String get bookingFailedMessage =>
      'अभी बुकिंग पूरी नहीं हो सकी। कृपया पुनः प्रयास करें।';

  @override
  String get changeVehicleLabel => 'वाहन बदलें';

  @override
  String get cancelRideTitle => 'सवारी रद्द करें?';

  @override
  String get cancelRideBody =>
      'क्या आप वाकई इस सवारी को रद्द करना चाहते हैं? 5 मिनट के भीतर कोई रद्दीकरण शुल्क नहीं लगता।';

  @override
  String get keepRideLabel => 'सवारी रखें';

  @override
  String get cancelRideLabel => 'सवारी रद्द करें';

  @override
  String get bookingConfirmedTitle => 'बुकिंग की पुष्टि हो गई';

  @override
  String get noActiveBookingLabel => 'कोई सक्रिय बुकिंग नहीं।';

  @override
  String get yourBookingConfirmedHeading => 'आपकी बुकिंग की पुष्टि हो गई है!';

  @override
  String get driverAllocatedSubtitle => 'ड्राइवर आवंटित कर दिया गया है';

  @override
  String get driverMayCallTitle => 'ड्राइवर आपको कॉल कर सकता है';

  @override
  String get keepPhoneReachableSubtitle => 'कृपया अपना फ़ोन सुलभ रखें';

  @override
  String get liveTrackDriverLabel => 'ड्राइवर को लाइव ट्रैक करें';

  @override
  String reviewCountSuffix(int count) {
    return '($count यात्राएं)';
  }

  @override
  String get verifiedDriverLabel => 'सत्यापित ड्राइवर';

  @override
  String get connectingCallTitle => 'कॉल जोड़ी जा रही है';

  @override
  String callingDriverMessage(String name) {
    return '$name को कॉल किया जा रहा है (+91 98765 00000)...';
  }

  @override
  String get driverOnWayHeading => 'ड्राइवर रास्ते में है';

  @override
  String get driverArrivedLabel => 'ड्राइवर पहुंच गया है!';

  @override
  String kmAwaySuffix(String value) {
    return '$value किमी दूर';
  }

  @override
  String get arrivingInLabel => 'आगमन में';

  @override
  String get dropLabel => 'ड्रॉप';

  @override
  String get findingDriverHeading => 'उपयुक्त ड्राइवर खोजा जा रहा है...';

  @override
  String get findingDriverSubtitle => 'इसमें आमतौर पर कुछ सेकंड लगते हैं।';

  @override
  String get cancelRequestLabel => 'अनुरोध रद्द करें';

  @override
  String get bookNow => 'अभी बुक करें';

  @override
  String get scheduleForLater => 'बाद के लिए शेड्यूल करें';

  @override
  String get scheduleRide => 'राइड शेड्यूल करें';

  @override
  String get scheduleTooSoonError =>
      'कृपया अभी से कम से कम 30 मिनट बाद का समय चुनें।';

  @override
  String get scheduleTooFarError =>
      'शेड्यूलिंग केवल 7 दिन आगे तक ही उपलब्ध है।';

  @override
  String get noVehiclesMatchFilter => 'इस फ़िल्टर से कोई वाहन मेल नहीं खाता।';

  @override
  String get seatsFilterAny => 'कोई भी';

  @override
  String seatsFilterPlus(int count) {
    return '$count+ सीट';
  }

  @override
  String get upcomingScheduledRideTitle => 'आगामी शेड्यूल्ड राइड';

  @override
  String get waitingForDriverLabel => 'ड्राइवर की प्रतीक्षा है...';

  @override
  String driverAssignedNameLabel(String name) {
    return 'ड्राइवर: $name';
  }

  @override
  String scheduledForLabel(String value) {
    return '$value के लिए शेड्यूल्ड';
  }

  @override
  String get addEmailForReceiptLabel => 'बुकिंग रसीद के लिए अपना ईमेल जोड़ें';

  @override
  String get emailOptionalHint => 'you@example.com (वैकल्पिक)';

  @override
  String get validationEmailInvalid => 'कृपया एक मान्य ईमेल पता दर्ज करें।';

  @override
  String get scheduledRideConfirmationToast =>
      'आपकी राइड शेड्यूल हो गई है! ड्राइवर के स्वीकार करते ही हम आपको सूचित करेंगे।';
}
