// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Nawasul';

  @override
  String get navHome => 'Home';

  @override
  String get navVehicles => 'Vehicles';

  @override
  String get navOrderSticker => 'Order sticker';

  @override
  String get navAlerts => 'Alerts';

  @override
  String get navAccount => 'Account';

  @override
  String get placeholderBody => 'This screen is not built yet.';

  @override
  String get actionContinue => 'Continue';

  @override
  String get actionContinueNew => 'Continue as new';

  @override
  String get actionContinueReturning => 'Continue as returning';

  @override
  String get actionRetry => 'Try again';

  @override
  String get actionSkip => 'Skip';

  @override
  String get actionNext => 'Next';

  @override
  String get actionGetStarted => 'Get started';

  @override
  String get languageEn => 'EN';

  @override
  String get languageAr => 'AR';

  @override
  String get errorGenericTitle => 'Something went wrong';

  @override
  String get errorGenericBody => 'Please try again.';

  @override
  String get emptyTitle => 'Nothing here yet';

  @override
  String get onboardingTitle1 => 'Add your car';

  @override
  String get onboardingBody1 =>
      'Register your vehicle. It only takes a minute.';

  @override
  String get onboardingTitle2 => 'Stick the QR on your car';

  @override
  String get onboardingBody2 =>
      'We send a sticker with a code. No plate number is printed.';

  @override
  String get onboardingTitle3 => 'Get alerted, privately';

  @override
  String get onboardingBody3 => 'Your number is never shared.';

  @override
  String get phoneTitle => 'Enter your number';

  @override
  String get phoneSubtitle => 'We\'ll send a code on WhatsApp.';

  @override
  String get phoneInvalid => 'Enter a mobile number starting with 5.';

  @override
  String phoneRateLimited(int seconds) {
    return 'Too many attempts. Try again in $seconds s.';
  }

  @override
  String get phoneNetwork =>
      'Could not reach Nawasul. Check your connection and try again.';

  @override
  String get phoneConsentBefore => 'By continuing you agree to our ';

  @override
  String get phoneConsentTerms => 'Terms';

  @override
  String get phoneConsentAnd => ' and ';

  @override
  String get phoneConsentPrivacy => 'Privacy Policy';

  @override
  String get phoneConsentAfter =>
      ', and to receive service messages (codes, alerts, order updates) on WhatsApp.';

  @override
  String get phoneMarketing => 'Send me offers and news';

  @override
  String get verifyTitle => 'Enter the 6-digit code we sent to WhatsApp';

  @override
  String verifySentTo(String phone) {
    return 'Sent to $phone';
  }

  @override
  String get verifyEdit => 'Edit number';

  @override
  String get verifyResend => 'Resend code';

  @override
  String verifyResendIn(int seconds) {
    return 'Resend in $seconds s';
  }

  @override
  String get verifyOpenWhatsapp => 'Open WhatsApp';

  @override
  String verifyWrongCode(int count) {
    return 'That code is wrong. $count attempts left.';
  }

  @override
  String get verifyExpired => 'That code has expired. Request a new one.';

  @override
  String verifyLocked(int seconds) {
    return 'Too many attempts. Try again in $seconds s.';
  }

  @override
  String get verifyNoWhatsapp =>
      'We couldn\'t deliver a code. Make sure this number has WhatsApp, or contact support.';

  @override
  String get verifyHelp => 'Help';

  @override
  String get nameTitle => 'What should we call you?';

  @override
  String get nameLabel => 'Name';

  @override
  String get nameHint => 'Your name';

  @override
  String get nameInvalid => 'Use 2 to 50 characters.';

  @override
  String get cityLabel => 'City';

  @override
  String get cityHint => 'Select your city';

  @override
  String get cityRiyadh => 'Riyadh';

  @override
  String get cityJeddah => 'Jeddah';

  @override
  String get cityMakkah => 'Makkah';

  @override
  String get cityMadinah => 'Madinah';

  @override
  String get cityDammam => 'Dammam';

  @override
  String get cityKhobar => 'Khobar';

  @override
  String get cityTaif => 'Taif';

  @override
  String get cityTabuk => 'Tabuk';

  @override
  String get cityAbha => 'Abha';

  @override
  String get cityBuraydah => 'Buraydah';

  @override
  String get cityHail => 'Hail';

  @override
  String get cityNajran => 'Najran';

  @override
  String get cityJazan => 'Jazan';

  @override
  String get cityYanbu => 'Yanbu';

  @override
  String get alertsTitle => 'Allow alerts';

  @override
  String get alertsBody =>
      'Alerts arrive with sound. They may be missed if your phone is off, muted, or offline.';

  @override
  String get alertsAllow => 'Allow notifications';

  @override
  String get alertsLater => 'Maybe later';

  @override
  String get alertsAndroidTitle => 'Let alerts ring loudly';

  @override
  String get alertsAndroidBody =>
      'You can allow loud alerts in system settings. This step is optional.';

  @override
  String get legalPrivacy => 'Privacy Policy';

  @override
  String get legalTerms => 'Terms';

  @override
  String get legalShipping => 'Shipping and refunds';

  @override
  String get legalMissing => 'This document is not available.';

  @override
  String get privacyS1Title => 'What we collect';

  @override
  String get privacyS1Body =>
      'We collect your phone number, name, city, delivery address, vehicle details, device push token, and your order and alert history.';

  @override
  String get privacyS2Title => 'How we use it';

  @override
  String get privacyS2Body =>
      'We use this to send codes, alerts, and order updates. People who scan your sticker do not see your phone number.';

  @override
  String get privacyS3Title => 'Your choices';

  @override
  String get privacyS3Body =>
      'Offers and news are optional and off unless you ask for them. You can delete your account in the app.';

  @override
  String get termsS1Title => 'The service';

  @override
  String get termsS1Body =>
      'Nawasul lets someone alert you about your car without sharing your number. Alerts may be delayed or missed if your phone is off, muted, or offline.';

  @override
  String get termsS2Title => 'Stickers';

  @override
  String get termsS2Body =>
      'A sticker is valid for 3, 6, or 12 months from the moment payment is confirmed. The app itself is free.';

  @override
  String get termsS3Title => 'Messages';

  @override
  String get termsS3Body =>
      'Service messages on WhatsApp (codes, alerts, and order updates) are part of using Nawasul. Offers and news are a separate choice.';

  @override
  String get shippingS1Title => 'Delivery';

  @override
  String get shippingS1Body =>
      'Each order is one sticker, sent to the address you give us. The time shown at checkout is an estimate.';

  @override
  String get shippingS2Title => 'Help with an order';

  @override
  String get shippingS2Body =>
      'If a sticker is lost or damaged, or you need help with an order, contact support.';

  @override
  String homeGreetingMorning(String name) {
    return 'Good morning, $name';
  }

  @override
  String homeGreetingAfternoon(String name) {
    return 'Good afternoon, $name';
  }

  @override
  String homeGreetingEvening(String name) {
    return 'Good evening, $name';
  }

  @override
  String get homeAddVehicle => 'Add vehicle';

  @override
  String get homeOrderSticker => 'Order sticker';

  @override
  String get homeMyQr => 'My QR';

  @override
  String get homeRecentAlerts => 'Recent alerts';

  @override
  String get homeSeeAll => 'See all';

  @override
  String get homeNoAlerts => 'No alerts yet.';

  @override
  String get homeAddFirst => 'Add your first vehicle';

  @override
  String get homeNotProtected => 'Not protected yet';

  @override
  String get homeWaitingPayment => 'Waiting for payment';

  @override
  String get homeOnTheWay => 'Sticker on the way';

  @override
  String get homeProtected => 'Protected';

  @override
  String get homeExpiresSoon => 'Expires soon';

  @override
  String get homeNotProtectedNow => 'Not protected';

  @override
  String get homeViewOrder => 'View order';

  @override
  String get homeOrderNew => 'Order new sticker';

  @override
  String homeDaysLeft(int count) {
    return '$count days left';
  }

  @override
  String homeValidUntil(String date) {
    return 'Valid until $date';
  }

  @override
  String get homeBannerBlocked =>
      'Alerts are blocked. Allow notifications to hear them.';

  @override
  String get homeBannerExpiring => 'This sticker expires soon.';

  @override
  String get homeBannerExpired => 'This sticker has expired.';

  @override
  String get homeBannerPayment => 'Payment is still pending.';

  @override
  String get debugStates => 'States';

  @override
  String get debugNoVehicle => 'No vehicle';

  @override
  String get debugNoSticker => 'No sticker';

  @override
  String get debugPaymentPending => 'Payment pending';

  @override
  String get debugInTransit => 'In transit';

  @override
  String get debugActive => 'Protected';

  @override
  String get debugExpiring => 'Expires soon';

  @override
  String get debugExpired => 'Expired';

  @override
  String get debugFailedPayment => 'Payment failed';

  @override
  String get debugEmptyAlerts => 'No alerts';

  @override
  String get vehiclesTitle => 'Vehicles';

  @override
  String get vehiclesEmpty => 'No vehicles yet';

  @override
  String get vehiclesAdd => 'Add';

  @override
  String get vehiclePlate => 'Plate';

  @override
  String get vehiclePlateHint => 'Letters and digits, for example ABC 1234';

  @override
  String get vehicleMake => 'Make';

  @override
  String get vehicleMakeOther => 'Other';

  @override
  String get vehicleModel => 'Model';

  @override
  String get vehicleColor => 'Color';

  @override
  String get vehicleSave => 'Save';

  @override
  String get vehicleDuplicate => 'This plate is already registered.';

  @override
  String get vehicleAddedBanner => 'Order a sticker to protect this car.';

  @override
  String get vehicleViewQr => 'View QR';

  @override
  String get vehicleAlerts => 'Recent alerts';

  @override
  String get vehicleOrders => 'Latest order';

  @override
  String get vehicleEdit => 'Edit';

  @override
  String get vehicleDelete => 'Delete';

  @override
  String get vehicleDeleteTitle => 'Delete this vehicle?';

  @override
  String get vehicleDeleteBody =>
      'An active sticker will stop working. Deleting a vehicle does not create a refund.';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionBack => 'Back';

  @override
  String get actionMore => 'More';

  @override
  String get vehicleNotFound => 'This vehicle is not available.';

  @override
  String get qrPreview => 'Preview scan page';

  @override
  String get qrInactive =>
      'Your QR becomes active when your payment is confirmed.';

  @override
  String get colorWhite => 'White';

  @override
  String get colorBlack => 'Black';

  @override
  String get colorSilver => 'Silver';

  @override
  String get colorGray => 'Gray';

  @override
  String get colorBlue => 'Blue';

  @override
  String get colorRed => 'Red';

  @override
  String get colorGreen => 'Green';

  @override
  String get colorBeige => 'Beige';

  @override
  String get alertBlocking => 'Blocking another car';

  @override
  String get alertLights => 'Lights left on';

  @override
  String get alertDoor => 'Door or window open';

  @override
  String get alertTire => 'Flat tire or damage';

  @override
  String get alertOther => 'Other, urgent';

  @override
  String get alertOrderUpdate => 'Order update';

  @override
  String get alertExpiry => 'Sticker expiry';

  @override
  String alertHoursAgo(int count) {
    return '$count h ago';
  }

  @override
  String alertDaysAgo(int count) {
    return '$count d ago';
  }

  @override
  String orderLabel(String number) {
    return 'Order $number';
  }

  @override
  String orderStep(int step) {
    return '$step/3';
  }

  @override
  String get orderVehicleTitle => 'Vehicle and validity';

  @override
  String get orderDeliveryTitle => 'Delivery';

  @override
  String get orderReviewTitle => 'Review and pay';

  @override
  String orderMonths(int count) {
    return '$count months';
  }

  @override
  String get orderBestValue => 'Best value';

  @override
  String orderValidFor(int months) {
    return 'Valid for $months months from payment.';
  }

  @override
  String get orderValidityStarts =>
      'The new validity starts when payment is confirmed.';

  @override
  String get orderAddVehicle => 'Add a new vehicle';

  @override
  String get orderNoVehicle => 'Add a vehicle to continue.';

  @override
  String orderDeliveryEta(String eta) {
    return 'Estimated delivery: $eta';
  }

  @override
  String get orderPhone => 'Phone';

  @override
  String get orderStreet => 'Street';

  @override
  String get orderDistrict => 'District';

  @override
  String get orderBuilding => 'Building';

  @override
  String get orderShortAddress => 'Saudi short address (optional)';

  @override
  String get orderNotes => 'Notes (optional)';

  @override
  String get orderSaveAddress => 'Save this address';

  @override
  String get orderSummary => 'Summary';

  @override
  String get orderEdit => 'Edit';

  @override
  String get orderSticker => 'Sticker';

  @override
  String get orderDeliveryFee => 'Delivery';

  @override
  String get orderVat => 'VAT';

  @override
  String get orderTotal => 'Total';

  @override
  String get orderMethods => 'mada · Apple Pay · Visa · Mastercard';

  @override
  String get orderPayConsentBefore => 'By paying you accept the ';

  @override
  String get orderPayTerms => 'Terms';

  @override
  String get orderPayAnd => ' and ';

  @override
  String get orderPayShipping => 'Shipping and refunds policy';

  @override
  String get orderPayConsentAfter => '.';

  @override
  String orderPay(String amount) {
    return 'Pay $amount';
  }

  @override
  String get orderConfirming => 'Confirming your payment…';

  @override
  String get orderPending =>
      'We\'re confirming your payment. We\'ll notify you.';

  @override
  String get orderBackHome => 'Back to Home';

  @override
  String get orderFailed => 'Payment failed';

  @override
  String get orderWaiting => 'Waiting for payment';

  @override
  String get orderPaid => 'Paid';

  @override
  String get orderPrinted => 'Printed';

  @override
  String get orderShipped => 'Shipped';

  @override
  String get orderDelivered => 'Delivered';

  @override
  String get orderCancelled => 'Cancelled';

  @override
  String get orderExpired => 'Expired';

  @override
  String get ordersTitle => 'My orders';

  @override
  String get ordersEmpty => 'No orders yet';

  @override
  String get orderInvoice => 'Download invoice';

  @override
  String get orderNeedHelp => 'Need help with this order?';

  @override
  String get orderTracking => 'Tracking number';

  @override
  String get actionCopy => 'Copy';

  @override
  String get orderCopied => 'Copied';

  @override
  String get orderNotFound => 'This order is not available.';

  @override
  String get debugPaySection => 'Next payment';

  @override
  String get debugPaySucceeds => 'Succeeds';

  @override
  String get debugPayFails => 'Fails';

  @override
  String get debugPayPending => 'Stays pending';

  @override
  String get debugMarkDelivered => 'Mark delivered';

  @override
  String get alertsToday => 'Today';

  @override
  String get alertsYesterday => 'Yesterday';

  @override
  String get alertChannelPush => 'Push';

  @override
  String get alertChannelWhatsapp => 'WhatsApp';

  @override
  String get alertStatusSent => 'Sent';

  @override
  String get alertStatusDelivered => 'Delivered';

  @override
  String get alertStatusRead => 'Read';

  @override
  String get alertStatusFailed => 'Failed';

  @override
  String get alertStopAlarm => 'Stop alarm';

  @override
  String get alertComing => 'I\'m coming';

  @override
  String get alertComingDone => 'You told them you\'re coming.';

  @override
  String get alertSpam => 'Report as spam';

  @override
  String get alertSpamTitle => 'Report this alert?';

  @override
  String get alertSpamBody => 'It will be removed from your alerts.';

  @override
  String get alertSpamConfirm => 'Report';

  @override
  String get alertDisclaimer =>
      'Alerts may be delayed or missed if your phone is off, muted, or offline.';

  @override
  String get alertNotFound => 'This alert is not available.';

  @override
  String get debugSimulateAlert => 'Simulate alert';

  @override
  String get accountEdit => 'Edit profile';

  @override
  String get accountPhoneLocked => 'To change your number, contact support.';

  @override
  String get accountNotifications => 'Notifications';

  @override
  String get accountLanguage => 'Language';

  @override
  String get accountHelp => 'Help and contact';

  @override
  String get accountLegal => 'Legal';

  @override
  String get accountDelete => 'Delete account';

  @override
  String get accountLogOut => 'Log out';

  @override
  String get accountLogOutTitle => 'Log out?';

  @override
  String get accountLogOutBody => 'You can sign in again with your number.';

  @override
  String accountVersion(String version) {
    return 'Version $version';
  }

  @override
  String get accountWhatsapp => 'WhatsApp alerts';

  @override
  String get accountPush => 'Push alerts';

  @override
  String get accountOneChannel => 'At least one of these stays on.';

  @override
  String get accountAlarmStyle => 'Alert style';

  @override
  String get accountAlarmLoud => 'Loud alarm';

  @override
  String get accountAlarmNormal => 'Normal';

  @override
  String get accountMarketing => 'Offers and news';

  @override
  String get accountTestAlert => 'Send test alert';

  @override
  String get accountChecklist => 'On this phone';

  @override
  String get accountNotifAllowed => 'Notifications allowed';

  @override
  String get accountLoudReady => 'Loud alerts set up';

  @override
  String get accountStatusOn => 'On';

  @override
  String get accountStatusOff => 'Off';

  @override
  String get accountFix => 'Fix';

  @override
  String get accountSettingsPhone =>
      'This opens system settings on your phone.';

  @override
  String get accountContact => 'Contact';

  @override
  String get accountWhatsappContact => 'WhatsApp';

  @override
  String get accountEmailContact => 'Email';

  @override
  String get alertTestTitle => 'Test alert';

  @override
  String get deleteBody =>
      'Vehicles and alert history are removed. The sticker stops working. Records required by law, such as invoices, are kept.';

  @override
  String get deleteInProgress =>
      'A sticker order is still on the way. Contact support if you need help with it.';

  @override
  String get deleteReason => 'Reason (optional)';

  @override
  String get deleteConfirmTitle => 'Delete your account?';

  @override
  String get deleteConfirmBody => 'This cannot be undone.';

  @override
  String get faqHowTitle => 'How does it work?';

  @override
  String get faqHowBody =>
      'Someone scans the sticker on your car, picks a reason, and you get a push, a WhatsApp message, and an alert in the app. Your number is not shared.';

  @override
  String get faqNumberTitle => 'Is my number visible?';

  @override
  String get faqNumberBody =>
      'No. People who scan your sticker do not see your phone number.';

  @override
  String get faqReachTitle => 'What if I\'m not reachable?';

  @override
  String get faqReachBody =>
      'Alerts may be delayed or missed if your phone is off, muted, or offline. The same alert is also sent on WhatsApp.';

  @override
  String get faqExpireTitle => 'What if my sticker expires?';

  @override
  String get faqExpireBody =>
      'Order a new sticker. You can still open the app, see your vehicles, and read old alerts.';

  @override
  String get faqDeliveryTitle => 'How long does delivery take?';

  @override
  String faqDeliveryBody(String eta) {
    return 'Estimated delivery is $eta.';
  }

  @override
  String get faqDeliveryPending =>
      'The estimated delivery time is shown when you order a sticker.';

  @override
  String get faqMoveTitle => 'Can I move the sticker to another car?';

  @override
  String get faqMoveBody =>
      'A sticker belongs to one vehicle. Order a new sticker for another car.';

  @override
  String get faqSilentTitle => 'Do alerts work when my phone is silent?';

  @override
  String get faqSilentBody =>
      'Alerts may be delayed or missed if your phone is off, muted, or offline. You can choose a loud alarm in Notifications.';

  @override
  String get faqDeleteTitle => 'How do I delete my account?';

  @override
  String get faqDeleteBody =>
      'Open Account, then Delete account. Vehicles and alert history are removed, and the sticker stops working. Invoices are kept.';

  @override
  String get offlineBanner =>
      'You are offline. Some details may be out of date.';
}
