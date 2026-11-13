// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Taxiway';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageHindi => 'हिन्दी';

  @override
  String get languageBengali => 'বাংলা';

  @override
  String get languagePickerTitle => 'Choose your language';

  @override
  String get languagePickerSubtitle =>
      'You can change this anytime from the home screen.';

  @override
  String get continueLabel => 'Continue';

  @override
  String get onboardSlide1Title => 'Safe. Reliable. Anytime.';

  @override
  String get onboardSlide1Subtitle =>
      'Verified drivers, transparent fares, and a smooth ride every time.';

  @override
  String get onboardSlide2Title => 'Track your ride, live';

  @override
  String get onboardSlide2Subtitle =>
      'Watch your driver approach in real time, from pickup to drop-off.';

  @override
  String get onboardSlide3Title => 'One tap, multiple vehicles';

  @override
  String get onboardSlide3Subtitle =>
      'From a solo ride to a full group booking, Taxiway scales with you.';

  @override
  String get getStarted => 'Get Started';

  @override
  String get login => 'Login';

  @override
  String get appVersion => 'v1.0.0';

  @override
  String get welcome => 'Welcome!';

  @override
  String get enterPhoneSubtitle => 'Enter your phone number to continue.';

  @override
  String get enterMobileNumber => 'Enter mobile number';

  @override
  String get agreeToTerms => 'By continuing, you agree to our ';

  @override
  String get termsAndConditions => 'Terms & Conditions';

  @override
  String get andWord => ' and ';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get verifyYourNumber => 'Verify your number';

  @override
  String otpSentTo(String phone) {
    return 'We\'ve sent a 6-digit OTP to +91 $phone';
  }

  @override
  String get otpDemoHint => '(Use 123456 for this demo)';

  @override
  String resendIn(String time) {
    return 'Resend in $time';
  }

  @override
  String get resendOtp => 'Resend OTP';

  @override
  String get verifyAndContinue => 'Verify & Continue';

  @override
  String get invalidOtp => 'Invalid OTP. Please try again.';

  @override
  String get otpResent => 'OTP resent.';

  @override
  String get enterDestinationHint =>
      'Enter a destination to see vehicles and fare.';

  @override
  String get bulkBookingTitle => 'Bulk Booking';

  @override
  String get bulkBookingSubtitle =>
      'Book multiple vehicles for a group or scheduled trip.';

  @override
  String get selectVehicle => 'Select Vehicle';

  @override
  String get bookRide => 'Book Ride';

  @override
  String get selectAVehicle => 'Select a Vehicle';

  @override
  String get fromLabel => 'From';

  @override
  String get toLabel => 'To';

  @override
  String get searchPickup => 'Search Pickup';

  @override
  String get enterDestination => 'Enter Destination';

  @override
  String get distanceLabel => 'Distance';

  @override
  String get estTimeLabel => 'Est. Time';

  @override
  String get profileTitle => 'Profile';

  @override
  String get myTrips => 'My Trips';

  @override
  String get helpSupport => 'Help & Support';

  @override
  String get languageMenuItem => 'Language';

  @override
  String get logout => 'Logout';

  @override
  String get guest => 'Guest';

  @override
  String get logoutConfirmBody => 'Are you sure you want to logout?';

  @override
  String get cancel => 'Cancel';

  @override
  String get deleteMyAccount => 'Delete my account';

  @override
  String get deleteAccountDialogTitle => 'Delete Account';

  @override
  String get deleteAccountDialogBody =>
      'This opens a secure page in your browser where you can permanently delete your account and all associated data. This cannot be undone.';

  @override
  String get continueWord => 'Continue';

  @override
  String seatsCountShort(int count) {
    return '$count seats';
  }

  @override
  String get couldNotLoadVehicles => 'Couldn\'t load vehicles.';

  @override
  String seaterCount(int count) {
    return '$count Seater';
  }

  @override
  String minutesShort(int count) {
    return '$count min';
  }

  @override
  String kmShort(String value) {
    return '$value km';
  }

  @override
  String get pickupLabel => 'Pickup';

  @override
  String get destinationLabel => 'Destination';

  @override
  String get driverLocationLabel => 'Driver Location';

  @override
  String get expandMapLabel => 'Full Screen';

  @override
  String get collapseMapLabel => 'Collapse';

  @override
  String get fromPickupLabel => 'From (Pickup)';

  @override
  String get toDestinationLabel => 'To (Destination)';

  @override
  String get whereDoYouWantToGo => 'Where do you want to go?';

  @override
  String get baseFareLabel => 'Base Fare';

  @override
  String get timeLabel => 'Time';

  @override
  String get tollsParkingNote => 'Tolls & parking extra';

  @override
  String get pickupLocationTitle => 'Pickup Location';

  @override
  String get dragMapPickupHint =>
      'Drag the map to move the pin, or search pickup location below.';

  @override
  String get searchPickupMapHint => 'Search pickup location on real map...';

  @override
  String get useCurrentGpsLocation => 'Use current GPS location';

  @override
  String get detectLocationAutomatically => 'Detect location automatically';

  @override
  String closestResultsLabel(int count) {
    return 'Closest Results ($count)';
  }

  @override
  String get recentPickupsLabel => 'Recent Pickups';

  @override
  String get clearAllLabel => 'Clear all';

  @override
  String get confirmPickupLabel => 'Confirm Pickup';

  @override
  String get selectPickupLocationLabel => 'Select Pickup Location';

  @override
  String get noExactMatchTitle => 'No exact match found on map.';

  @override
  String get dragPinToSelectHint =>
      'Drag the map pin to select this location directly.';

  @override
  String get noRecentPickupsTitle => 'No recent pickups';

  @override
  String get searchPickupAboveHint =>
      'Search pickup above or drag the pin on map.';

  @override
  String get removeFromHistoryTooltip => 'Remove from history';

  @override
  String get liveRouteShowingHint =>
      'Showing live road route to selected destination. Tap map or search to change.';

  @override
  String get tapMapToSeeRouteHint =>
      'Tap on map or search below to see live road route.';

  @override
  String get searchDestinationMapHint => 'Search destination on real map...';

  @override
  String closestMatchesLabel(int count) {
    return 'Closest Matches ($count)';
  }

  @override
  String get recentSearchHistoryLabel => 'Recent Search History';

  @override
  String get confirmDestinationLabel => 'Confirm Destination';

  @override
  String get selectDestinationFromMapLabel =>
      'Select Destination from Map / List';

  @override
  String get tapMapDirectlyHint =>
      'Tap on the map directly to select this spot.';

  @override
  String get noRecentSearchesTitle => 'No recent searches';

  @override
  String get typeAboveToSearchHint =>
      'Type above to search real places or tap on the map.';

  @override
  String get missingBookingDetails => 'Missing booking details.';

  @override
  String get confirmYourRide => 'Confirm your ride';

  @override
  String seatsCount(int count) {
    return '$count Seats';
  }

  @override
  String get acLabel => 'AC';

  @override
  String tripDistanceValue(String value) {
    return 'Trip Distance: $value km';
  }

  @override
  String estTimeValue(String value) {
    return 'Est. Time: $value min';
  }

  @override
  String get paymentMethodLabel => 'Payment Method';

  @override
  String get upiTitle => 'UPI (GPay, PhonePe, Paytm)';

  @override
  String get upiSubtitle => 'Pay directly via any UPI app / QR code';

  @override
  String get cashPaymentTitle => 'Cash Payment';

  @override
  String get cashPaymentSubtitle =>
      'Pay driver directly after completing the trip';

  @override
  String get cardPaymentTitle => 'Credit / Debit Card';

  @override
  String get cardPaymentSubtitle => 'Visa, MasterCard, RuPay, Corporate cards';

  @override
  String confirmBookingLabel(String value) {
    return 'Confirm Booking — $value';
  }

  @override
  String get bookingFailedTitle => 'Booking Failed';

  @override
  String get bookingFailedMessage =>
      'Couldn\'t complete booking right now. Please try again.';

  @override
  String get changeVehicleLabel => 'Change Vehicle';

  @override
  String get cancelRideTitle => 'Cancel Ride?';

  @override
  String get cancelRideBody =>
      'Are you sure you want to cancel this ride? No cancellation fee applies within 5 minutes.';

  @override
  String get keepRideLabel => 'Keep Ride';

  @override
  String get cancelRideLabel => 'Cancel Ride';

  @override
  String get bookingConfirmedTitle => 'Booking Confirmed';

  @override
  String get noActiveBookingLabel => 'No active booking.';

  @override
  String get yourBookingConfirmedHeading => 'Your booking is confirmed!';

  @override
  String get driverAllocatedSubtitle => 'Driver has been allocated';

  @override
  String get driverMayCallTitle => 'Driver may call you';

  @override
  String get keepPhoneReachableSubtitle => 'Please keep your phone reachable';

  @override
  String get liveTrackDriverLabel => 'Live Track Driver';

  @override
  String reviewCountSuffix(int count) {
    return '($count trips)';
  }

  @override
  String get verifiedDriverLabel => 'Verified Driver';

  @override
  String get connectingCallTitle => 'Connecting Call';

  @override
  String callingDriverMessage(String name) {
    return 'Calling $name (+91 98765 00000)...';
  }

  @override
  String get driverOnWayHeading => 'Driver is on the way';

  @override
  String get driverArrivedLabel => 'Driver has arrived!';

  @override
  String kmAwaySuffix(String value) {
    return '$value km away';
  }

  @override
  String get arrivingInLabel => 'Arriving in';

  @override
  String get dropLabel => 'Drop';

  @override
  String get findingDriverHeading => 'Finding a suitable driver...';

  @override
  String get findingDriverSubtitle => 'This usually takes a few seconds.';

  @override
  String get cancelRequestLabel => 'Cancel Request';

  @override
  String get bookNow => 'Book Now';

  @override
  String get scheduleForLater => 'Schedule for Later';

  @override
  String get scheduleRide => 'Schedule Ride';

  @override
  String get scheduleTooSoonError =>
      'Please choose a time at least 30 minutes from now.';

  @override
  String get scheduleTooFarError =>
      'Scheduling is only available up to 7 days ahead.';

  @override
  String get noVehiclesMatchFilter => 'No vehicles match this filter.';

  @override
  String get seatsFilterAny => 'Any';

  @override
  String seatsFilterPlus(int count) {
    return '$count+ Seats';
  }

  @override
  String get upcomingScheduledRideTitle => 'Upcoming Scheduled Ride';

  @override
  String get waitingForDriverLabel => 'Waiting for a driver...';

  @override
  String driverAssignedNameLabel(String name) {
    return 'Driver: $name';
  }

  @override
  String scheduledForLabel(String value) {
    return 'Scheduled for $value';
  }

  @override
  String get addEmailForReceiptLabel => 'Add your email for a booking receipt';

  @override
  String get emailOptionalHint => 'you@example.com (optional)';

  @override
  String get validationEmailInvalid => 'Please enter a valid email address.';

  @override
  String get scheduledRideConfirmationToast =>
      'Your ride has been scheduled! We\'ll notify you once a driver accepts.';

  @override
  String get profileSetupTitle => 'Tell us about you';

  @override
  String get profileSetupSubtitle =>
      'Just the essentials. You can change this anytime.';

  @override
  String get fullNameLabel => 'Full name';

  @override
  String get fullNameHint => 'Enter your full name';

  @override
  String get emailOptionalLabel => 'Email (optional)';

  @override
  String get emailHint => 'Enter your email';

  @override
  String profileSavedTitle(String name) {
    return 'You\'re all set, $name';
  }

  @override
  String get profileSavedMessage => 'Your account is ready.';

  @override
  String get startRidingButton => 'Start riding';

  @override
  String get profileSaveError =>
      'Couldn\'t save your profile. Please try again.';

  @override
  String get connectionOfflineTitle => 'No internet connection';

  @override
  String get connectionSlowTitle => 'Slow connection';

  @override
  String get connectionRestoredTitle => 'Back online';

  @override
  String get connectionServerTroubleTitle =>
      'We\'re having trouble reaching our servers';

  @override
  String get connectionRetryAction => 'Retry';

  @override
  String get connectionCheckingAction => 'Checking…';

  @override
  String get errorOfflineTitle => 'You\'re offline';

  @override
  String get errorOfflineMessage =>
      'Check your Wi-Fi or mobile data and try again.';

  @override
  String get errorTimeoutTitle => 'This is taking too long';

  @override
  String get errorTimeoutMessage =>
      'Your connection seems slow. Try again in a moment.';

  @override
  String get errorServerTitle => 'We\'re having trouble on our end';

  @override
  String get errorServerMessage =>
      'This isn\'t your connection. Please try again shortly.';

  @override
  String get errorMaintenanceTitle => 'Back shortly';

  @override
  String get errorMaintenanceMessage =>
      'Taxiway is being updated to serve you better.';

  @override
  String get errorGenericTitle => 'Something went wrong';

  @override
  String get errorGenericMessage => 'We couldn\'t load this. Please try again.';

  @override
  String get tryAgainLabel => 'Try again';

  @override
  String get tryingAgainLabel => 'Trying again…';

  @override
  String get goBackLabel => 'Go back';

  @override
  String get bookARideAction => 'Book a ride';

  @override
  String get emptyDefaultTitle => 'Nothing here yet';

  @override
  String get emptyDefaultMessage => 'Items will show up here.';

  @override
  String get tripsEmptyTitle => 'No trips yet';

  @override
  String get tripsEmptyMessage => 'Your bookings will appear here.';

  @override
  String get chatEmptyTitle => 'No messages yet';

  @override
  String get chatEmptyMessage => 'Say hello!';

  @override
  String get chatLoadFailed => 'Couldn\'t load messages';

  @override
  String get messageSendFailed => 'Message didn\'t send. Please try again.';

  @override
  String get otpSendFailed => 'Couldn\'t send the OTP. Please try again.';

  @override
  String get otpResendFailed => 'Couldn\'t resend the OTP. Please try again.';

  @override
  String get otpVerifyFailed => 'Couldn\'t verify the code. Please try again.';

  @override
  String get otpExpired => 'This code has expired. Please request a new one.';

  @override
  String get googleSignInFailed =>
      'Couldn\'t sign in with Google. Please try again.';

  @override
  String get supportNumberMissing => 'Support number isn\'t set up yet.';

  @override
  String get supportUnreachable =>
      'Couldn\'t reach support right now. Please try again.';

  @override
  String get chooseOnMapLabel => 'Choose on map';

  @override
  String get yourRouteTitle => 'Your route';

  @override
  String get rideCompleteTitle => 'Ride complete';

  @override
  String get thanksForRidingLabel => 'Thanks for riding with Taxiway';

  @override
  String rateYourRideWith(String name) {
    return 'How was your ride with $name?';
  }

  @override
  String get doneLabel => 'Done';

  @override
  String get viewReceiptLabel => 'View receipt';

  @override
  String paidWithLabel(String method) {
    return 'Paid with $method';
  }

  @override
  String get aboutDriver => 'About Driver';

  @override
  String get addPhoneToFinishSetup =>
      'Add your phone number to finish setting up your account.';

  @override
  String get addSpecialNotesOptional =>
      'Add Special Notes / Instructions (Optional)';

  @override
  String get addTipOptional => 'Add a Tip (Optional)';

  @override
  String get additionalRequirements => 'Additional Requirements';

  @override
  String get almostThere => 'Almost there';

  @override
  String get approxPassengers => 'Approx. Passengers';

  @override
  String get arrangingVehiclesNote =>
      'We\'re arranging vehicles for your trip. You\'ll be notified when an offer is ready.';

  @override
  String get assignedVehicle => 'Assigned Vehicle';

  @override
  String get autoFillSimNumber => 'Auto-fill SIM number';

  @override
  String get backToHome => 'Back to Home';

  @override
  String get backgroundChecked => 'Background Checked';

  @override
  String get bulkBookingConfirmedTitle => 'Bulk Booking Confirmed';

  @override
  String get bulkRequestSubmittedHeading =>
      'Your bulk booking request has been submitted!';

  @override
  String get bulkRequestSubmittedToast =>
      'Bulk booking request submitted for review!';

  @override
  String get bulkRequestTitle => 'Bulk Request';

  @override
  String get callDriver => 'Call Driver';

  @override
  String get callLabel => 'Call';

  @override
  String get callingDriverToast =>
      'Calling driver Amit Kumar (+91 98765 00000)...';

  @override
  String get cancelRideAction => 'Cancel ride';

  @override
  String get changeLabel => 'Change';

  @override
  String get changePhoneNumber => 'Change Phone Number';

  @override
  String get chatLabel => 'Chat';

  @override
  String get checkVehicleNumberBeforeBoarding =>
      'Please check the vehicle number before boarding.';

  @override
  String get checkingSimForNumber => 'Checking your SIM for a phone number…';

  @override
  String get chooseTravelSchedule => 'Choose your travel schedule';

  @override
  String get codeResent => 'Code Resent';

  @override
  String get completionLabel => 'Completion';

  @override
  String get confirmBooking => 'Confirm Booking';

  @override
  String get confirmDateAndSchedule => 'Confirm Date & Schedule';

  @override
  String get contactPerson => 'Contact Person';

  @override
  String get contactSupport => 'Contact Support';

  @override
  String get contactSupportRequestChange => 'Contact Support / Request Change';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get devModeNoSms => 'Dev Mode — No SMS Gateway';

  @override
  String get didntReceiveCode => 'Didn\'t receive code? ';

  @override
  String get driverAndVehicle => 'Driver & Vehicle';

  @override
  String get driverAndVehicleList => 'Driver & Vehicle List';

  @override
  String get driverArrivedTitle => 'Driver Arrived';

  @override
  String get driverProfileAndReviews => 'Driver Profile & Reviews';

  @override
  String get enterCorrectMobileForOtp =>
      'Enter your correct mobile number to receive a new OTP';

  @override
  String get enterPhoneToContinue => 'Enter your phone number\nto continue';

  @override
  String get estimatedFareRange => 'Estimated Fare Range';

  @override
  String get estimatedOnlyNote =>
      'Estimated only. Final offer may vary after vehicle confirmation.';

  @override
  String get experienceLabel => 'Experience';

  @override
  String get fareInvoice => 'Fare Invoice';

  @override
  String get feedbackSubmitted => 'Feedback Submitted';

  @override
  String get fetchingYourNumber => 'Fetching your number';

  @override
  String get filterAll => 'All';

  @override
  String get filterCancelled => 'Cancelled';

  @override
  String get helpCenter => 'Help Center';

  @override
  String get helpIntro =>
      'Browse popular topics or connect directly with our support team.';

  @override
  String get helplineCalling => 'Helpline Calling';

  @override
  String get howCanWeHelp => 'How can we help you?';

  @override
  String get howWasYourRide => 'How was your ride?';

  @override
  String get identityVerified => 'Identity Verified';

  @override
  String get includedCharges => 'Included Charges';

  @override
  String get journeyDate => 'Journey Date';

  @override
  String get journeyTime => 'Journey Time';

  @override
  String get licenceVerified => 'Driving Licence Verified';

  @override
  String get linkShared => 'Link Shared';

  @override
  String get messageLabel => 'Message';

  @override
  String get messagingDriverToast => 'Messaging driver Amit Kumar...';

  @override
  String get noCompletedRideFound => 'No completed ride found.';

  @override
  String get noConfirmedBookingFound => 'No confirmed booking found.';

  @override
  String get noOfferAvailable => 'No offer available.';

  @override
  String get noOfferYet => 'No offer available yet.';

  @override
  String get noRequestFound => 'No request found.';

  @override
  String get noReviewsYet => 'No reviews yet.';

  @override
  String get noVideosYet => 'No videos yet.';

  @override
  String get noteForDriverHint => 'Leave a note for the driver (optional)...';

  @override
  String get numberOfVehicles => 'Number of Vehicles';

  @override
  String get numberUpdated => 'Number Updated';

  @override
  String get offerDetails => 'Offer Details';

  @override
  String get offersReceived => 'Offers Received';

  @override
  String get onboardingRiderBody1 =>
      'Book a cab to any destination instantly — airport, station, or your favourite spot.';

  @override
  String get onboardingRiderBody2 =>
      'Every driver is background-checked and rated by riders like you, for your peace of mind.';

  @override
  String get onboardingRiderBody3 =>
      'No surge pricing surprises. See the full fare breakdown before you book.';

  @override
  String get onboardingRiderTitle1 => 'Ride Anywhere in Patna';

  @override
  String get onboardingRiderTitle2 => 'Safe & Verified Drivers';

  @override
  String get onboardingRiderTitle3 => 'Transparent Pricing';

  @override
  String get oneWay => 'One Way';

  @override
  String get otpVerificationTitle => 'OTP Verification';

  @override
  String get passengerReviews => 'Passenger Reviews';

  @override
  String get phoneCallTitle => 'Phone Call';

  @override
  String get phoneVerifiedSuccess => 'Phone verified successfully!';

  @override
  String get photosLabel => 'Photos';

  @override
  String get pickupTimeSlot => 'Pickup Time Slot';

  @override
  String get rateAndReview => 'Rate & Review';

  @override
  String get ratingDistribution => 'Rating Distribution';

  @override
  String get ratingLabel => 'Rating';

  @override
  String get removeLabel => 'Remove';

  @override
  String get requestSent => 'Request Sent';

  @override
  String get resendOtpIn => 'Resend OTP in ';

  @override
  String get reviewRequest => 'Review Request';

  @override
  String get reviewsLabel => 'Reviews';

  @override
  String get roundTrip => 'Round Trip';

  @override
  String get selectDateAndTime => 'Select Date & Time';

  @override
  String get shareTrip => 'Share trip';

  @override
  String get shareWithDriverToStart => 'Share with driver to start ride';

  @override
  String get simAutoFill => 'SIM Auto-Fill';

  @override
  String get skipLabel => 'Skip';

  @override
  String get sosAlertSent => 'SOS Alert Sent';

  @override
  String get sosAlertToast =>
      'Emergency SOS alert triggered! 24x7 support & police alerted.';

  @override
  String get sosLabel => 'SOS';

  @override
  String get specialNotesHint =>
      'e.g. Extra luggage space, airport flight details, English speaking driver...';

  @override
  String get specialNotesOptional => 'Special Notes (Optional)';

  @override
  String get startRideOtp => 'START RIDE OTP';

  @override
  String get stillNeedHelp => 'Still need help?';

  @override
  String get submitRequest => 'Submit Request';

  @override
  String get submitReview => 'Submit Review';

  @override
  String get successLabel => 'Success';

  @override
  String get supportLabel => 'Support';

  @override
  String get thanksForRatingToast => 'Thank you for rating your ride!';

  @override
  String get thisWeekend => 'This Weekend';

  @override
  String get todayLabel => 'Today';

  @override
  String get tomorrowLabel => 'Tomorrow';

  @override
  String get totalFare => 'Total Fare';

  @override
  String get totalTrips => 'Total Trips';

  @override
  String get tripDetails => 'Trip Details';

  @override
  String get tripHistory => 'Trip History';

  @override
  String get tripLinkCopiedToast =>
      'Live trip tracking link copied to clipboard!';

  @override
  String get tripsLabel => 'Trips';

  @override
  String get typeAMessage => 'Type a message…';

  @override
  String get vehicleGallery => 'Vehicle Gallery';

  @override
  String get vehiclePhotos => 'Vehicle Photos';

  @override
  String get vehiclesAvailable => 'Vehicles Available';

  @override
  String get verificationLabel => 'Verification';

  @override
  String get verifiedDriverOnline => 'Verified Driver · Online';

  @override
  String get verifiedLabel => 'Verified';

  @override
  String get videosLabel => 'Videos';

  @override
  String get viewDetails => 'View Details';

  @override
  String get viewMyRequest => 'View My Request';

  @override
  String get viewVehicle => 'View Vehicle';

  @override
  String get weSentSixDigitOtp => 'We\'ve sent a 6-digit OTP to';

  @override
  String get weWillNotifyVehicles =>
      'We will notify you when suitable vehicles and drivers are available.';

  @override
  String get welcomeTitle => 'Welcome';

  @override
  String get wereHereForYou => 'We\'re here for you.';

  @override
  String get whatWentWell => 'What went well?';

  @override
  String get yearsExp => 'Years Exp.';

  @override
  String get yourDriverHasArrived => 'Your driver has arrived';

  @override
  String get yourDrivers => 'Your Drivers';

  @override
  String get yourRating => 'Your Rating';
}
