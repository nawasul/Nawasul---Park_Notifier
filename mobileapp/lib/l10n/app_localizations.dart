import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Nawasul'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navVehicles.
  ///
  /// In en, this message translates to:
  /// **'Vehicles'**
  String get navVehicles;

  /// No description provided for @navOrderSticker.
  ///
  /// In en, this message translates to:
  /// **'Order sticker'**
  String get navOrderSticker;

  /// No description provided for @navAlerts.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get navAlerts;

  /// No description provided for @navAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get navAccount;

  /// No description provided for @placeholderBody.
  ///
  /// In en, this message translates to:
  /// **'This screen is not built yet.'**
  String get placeholderBody;

  /// No description provided for @actionContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get actionContinue;

  /// No description provided for @actionContinueNew.
  ///
  /// In en, this message translates to:
  /// **'Continue as new'**
  String get actionContinueNew;

  /// No description provided for @actionContinueReturning.
  ///
  /// In en, this message translates to:
  /// **'Continue as returning'**
  String get actionContinueReturning;

  /// No description provided for @actionRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get actionRetry;

  /// No description provided for @actionSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get actionSkip;

  /// No description provided for @actionNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get actionNext;

  /// No description provided for @actionGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get actionGetStarted;

  /// No description provided for @languageEn.
  ///
  /// In en, this message translates to:
  /// **'EN'**
  String get languageEn;

  /// No description provided for @languageAr.
  ///
  /// In en, this message translates to:
  /// **'AR'**
  String get languageAr;

  /// No description provided for @errorGenericTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorGenericTitle;

  /// No description provided for @errorGenericBody.
  ///
  /// In en, this message translates to:
  /// **'Please try again.'**
  String get errorGenericBody;

  /// No description provided for @emptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get emptyTitle;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Add your car'**
  String get onboardingTitle1;

  /// No description provided for @onboardingBody1.
  ///
  /// In en, this message translates to:
  /// **'Register your vehicle. It only takes a minute.'**
  String get onboardingBody1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Stick the QR on your car'**
  String get onboardingTitle2;

  /// No description provided for @onboardingBody2.
  ///
  /// In en, this message translates to:
  /// **'We send a sticker with a code. No plate number is printed.'**
  String get onboardingBody2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Get alerted, privately'**
  String get onboardingTitle3;

  /// No description provided for @onboardingBody3.
  ///
  /// In en, this message translates to:
  /// **'Your number is never shared.'**
  String get onboardingBody3;

  /// No description provided for @phoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your number'**
  String get phoneTitle;

  /// No description provided for @phoneSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll send a code on WhatsApp.'**
  String get phoneSubtitle;

  /// No description provided for @phoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a mobile number starting with 5.'**
  String get phoneInvalid;

  /// No description provided for @phoneRateLimited.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Try again in {seconds} s.'**
  String phoneRateLimited(int seconds);

  /// No description provided for @phoneNetwork.
  ///
  /// In en, this message translates to:
  /// **'Could not reach Nawasul. Check your connection and try again.'**
  String get phoneNetwork;

  /// No description provided for @phoneConsentBefore.
  ///
  /// In en, this message translates to:
  /// **'By continuing you agree to our '**
  String get phoneConsentBefore;

  /// No description provided for @phoneConsentTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms'**
  String get phoneConsentTerms;

  /// No description provided for @phoneConsentAnd.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get phoneConsentAnd;

  /// No description provided for @phoneConsentPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get phoneConsentPrivacy;

  /// No description provided for @phoneConsentAfter.
  ///
  /// In en, this message translates to:
  /// **', and to receive service messages (codes, alerts, order updates) on WhatsApp.'**
  String get phoneConsentAfter;

  /// No description provided for @phoneMarketing.
  ///
  /// In en, this message translates to:
  /// **'Send me offers and news'**
  String get phoneMarketing;

  /// No description provided for @verifyTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code we sent to WhatsApp'**
  String get verifyTitle;

  /// No description provided for @verifySentTo.
  ///
  /// In en, this message translates to:
  /// **'Sent to {phone}'**
  String verifySentTo(String phone);

  /// No description provided for @verifyEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit number'**
  String get verifyEdit;

  /// No description provided for @verifyResend.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get verifyResend;

  /// No description provided for @verifyResendIn.
  ///
  /// In en, this message translates to:
  /// **'Resend in {seconds} s'**
  String verifyResendIn(int seconds);

  /// No description provided for @verifyOpenWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'Open WhatsApp'**
  String get verifyOpenWhatsapp;

  /// No description provided for @verifyWrongCode.
  ///
  /// In en, this message translates to:
  /// **'That code is wrong. {count} attempts left.'**
  String verifyWrongCode(int count);

  /// No description provided for @verifyExpired.
  ///
  /// In en, this message translates to:
  /// **'That code has expired. Request a new one.'**
  String get verifyExpired;

  /// No description provided for @verifyLocked.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Try again in {seconds} s.'**
  String verifyLocked(int seconds);

  /// No description provided for @verifyNoWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t deliver a code. Make sure this number has WhatsApp, or contact support.'**
  String get verifyNoWhatsapp;

  /// No description provided for @verifyHelp.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get verifyHelp;

  /// No description provided for @nameTitle.
  ///
  /// In en, this message translates to:
  /// **'What should we call you?'**
  String get nameTitle;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @nameHint.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get nameHint;

  /// No description provided for @nameInvalid.
  ///
  /// In en, this message translates to:
  /// **'Use 2 to 50 characters.'**
  String get nameInvalid;

  /// No description provided for @cityLabel.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get cityLabel;

  /// No description provided for @cityHint.
  ///
  /// In en, this message translates to:
  /// **'Select your city'**
  String get cityHint;

  /// No description provided for @cityRiyadh.
  ///
  /// In en, this message translates to:
  /// **'Riyadh'**
  String get cityRiyadh;

  /// No description provided for @cityJeddah.
  ///
  /// In en, this message translates to:
  /// **'Jeddah'**
  String get cityJeddah;

  /// No description provided for @cityMakkah.
  ///
  /// In en, this message translates to:
  /// **'Makkah'**
  String get cityMakkah;

  /// No description provided for @cityMadinah.
  ///
  /// In en, this message translates to:
  /// **'Madinah'**
  String get cityMadinah;

  /// No description provided for @cityDammam.
  ///
  /// In en, this message translates to:
  /// **'Dammam'**
  String get cityDammam;

  /// No description provided for @cityKhobar.
  ///
  /// In en, this message translates to:
  /// **'Khobar'**
  String get cityKhobar;

  /// No description provided for @cityTaif.
  ///
  /// In en, this message translates to:
  /// **'Taif'**
  String get cityTaif;

  /// No description provided for @cityTabuk.
  ///
  /// In en, this message translates to:
  /// **'Tabuk'**
  String get cityTabuk;

  /// No description provided for @cityAbha.
  ///
  /// In en, this message translates to:
  /// **'Abha'**
  String get cityAbha;

  /// No description provided for @cityBuraydah.
  ///
  /// In en, this message translates to:
  /// **'Buraydah'**
  String get cityBuraydah;

  /// No description provided for @cityHail.
  ///
  /// In en, this message translates to:
  /// **'Hail'**
  String get cityHail;

  /// No description provided for @cityNajran.
  ///
  /// In en, this message translates to:
  /// **'Najran'**
  String get cityNajran;

  /// No description provided for @cityJazan.
  ///
  /// In en, this message translates to:
  /// **'Jazan'**
  String get cityJazan;

  /// No description provided for @cityYanbu.
  ///
  /// In en, this message translates to:
  /// **'Yanbu'**
  String get cityYanbu;

  /// No description provided for @alertsTitle.
  ///
  /// In en, this message translates to:
  /// **'Allow alerts'**
  String get alertsTitle;

  /// No description provided for @alertsBody.
  ///
  /// In en, this message translates to:
  /// **'Alerts arrive with sound. They may be missed if your phone is off, muted, or offline.'**
  String get alertsBody;

  /// No description provided for @alertsAllow.
  ///
  /// In en, this message translates to:
  /// **'Allow notifications'**
  String get alertsAllow;

  /// No description provided for @alertsLater.
  ///
  /// In en, this message translates to:
  /// **'Maybe later'**
  String get alertsLater;

  /// No description provided for @alertsAndroidTitle.
  ///
  /// In en, this message translates to:
  /// **'Let alerts ring loudly'**
  String get alertsAndroidTitle;

  /// No description provided for @alertsAndroidBody.
  ///
  /// In en, this message translates to:
  /// **'You can allow loud alerts in system settings. This step is optional.'**
  String get alertsAndroidBody;

  /// No description provided for @legalPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get legalPrivacy;

  /// No description provided for @legalTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms'**
  String get legalTerms;

  /// No description provided for @legalShipping.
  ///
  /// In en, this message translates to:
  /// **'Shipping and refunds'**
  String get legalShipping;

  /// No description provided for @legalMissing.
  ///
  /// In en, this message translates to:
  /// **'This document is not available.'**
  String get legalMissing;

  /// No description provided for @privacyS1Title.
  ///
  /// In en, this message translates to:
  /// **'What we collect'**
  String get privacyS1Title;

  /// No description provided for @privacyS1Body.
  ///
  /// In en, this message translates to:
  /// **'We collect your phone number, name, city, delivery address, vehicle details, device push token, and your order and alert history.'**
  String get privacyS1Body;

  /// No description provided for @privacyS2Title.
  ///
  /// In en, this message translates to:
  /// **'How we use it'**
  String get privacyS2Title;

  /// No description provided for @privacyS2Body.
  ///
  /// In en, this message translates to:
  /// **'We use this to send codes, alerts, and order updates. People who scan your sticker do not see your phone number.'**
  String get privacyS2Body;

  /// No description provided for @privacyS3Title.
  ///
  /// In en, this message translates to:
  /// **'Your choices'**
  String get privacyS3Title;

  /// No description provided for @privacyS3Body.
  ///
  /// In en, this message translates to:
  /// **'Offers and news are optional and off unless you ask for them. You can delete your account in the app.'**
  String get privacyS3Body;

  /// No description provided for @termsS1Title.
  ///
  /// In en, this message translates to:
  /// **'The service'**
  String get termsS1Title;

  /// No description provided for @termsS1Body.
  ///
  /// In en, this message translates to:
  /// **'Nawasul lets someone alert you about your car without sharing your number. Alerts may be delayed or missed if your phone is off, muted, or offline.'**
  String get termsS1Body;

  /// No description provided for @termsS2Title.
  ///
  /// In en, this message translates to:
  /// **'Stickers'**
  String get termsS2Title;

  /// No description provided for @termsS2Body.
  ///
  /// In en, this message translates to:
  /// **'A sticker is valid for 3, 6, or 12 months from the moment payment is confirmed. The app itself is free.'**
  String get termsS2Body;

  /// No description provided for @termsS3Title.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get termsS3Title;

  /// No description provided for @termsS3Body.
  ///
  /// In en, this message translates to:
  /// **'Service messages on WhatsApp (codes, alerts, and order updates) are part of using Nawasul. Offers and news are a separate choice.'**
  String get termsS3Body;

  /// No description provided for @shippingS1Title.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get shippingS1Title;

  /// No description provided for @shippingS1Body.
  ///
  /// In en, this message translates to:
  /// **'Each order is one sticker, sent to the address you give us. The time shown at checkout is an estimate.'**
  String get shippingS1Body;

  /// No description provided for @shippingS2Title.
  ///
  /// In en, this message translates to:
  /// **'Help with an order'**
  String get shippingS2Title;

  /// No description provided for @shippingS2Body.
  ///
  /// In en, this message translates to:
  /// **'If a sticker is lost or damaged, or you need help with an order, contact support.'**
  String get shippingS2Body;

  /// No description provided for @homeGreetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning, {name}'**
  String homeGreetingMorning(String name);

  /// No description provided for @homeGreetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon, {name}'**
  String homeGreetingAfternoon(String name);

  /// No description provided for @homeGreetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening, {name}'**
  String homeGreetingEvening(String name);

  /// No description provided for @homeAddVehicle.
  ///
  /// In en, this message translates to:
  /// **'Add vehicle'**
  String get homeAddVehicle;

  /// No description provided for @homeOrderSticker.
  ///
  /// In en, this message translates to:
  /// **'Order sticker'**
  String get homeOrderSticker;

  /// No description provided for @homeMyQr.
  ///
  /// In en, this message translates to:
  /// **'My QR'**
  String get homeMyQr;

  /// No description provided for @homeRecentAlerts.
  ///
  /// In en, this message translates to:
  /// **'Recent alerts'**
  String get homeRecentAlerts;

  /// No description provided for @homeSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get homeSeeAll;

  /// No description provided for @homeNoAlerts.
  ///
  /// In en, this message translates to:
  /// **'No alerts yet.'**
  String get homeNoAlerts;

  /// No description provided for @homeAddFirst.
  ///
  /// In en, this message translates to:
  /// **'Add your first vehicle'**
  String get homeAddFirst;

  /// No description provided for @homeNotProtected.
  ///
  /// In en, this message translates to:
  /// **'Not protected yet'**
  String get homeNotProtected;

  /// No description provided for @homeWaitingPayment.
  ///
  /// In en, this message translates to:
  /// **'Waiting for payment'**
  String get homeWaitingPayment;

  /// No description provided for @homeOnTheWay.
  ///
  /// In en, this message translates to:
  /// **'Sticker on the way'**
  String get homeOnTheWay;

  /// No description provided for @homeProtected.
  ///
  /// In en, this message translates to:
  /// **'Protected'**
  String get homeProtected;

  /// No description provided for @homeExpiresSoon.
  ///
  /// In en, this message translates to:
  /// **'Expires soon'**
  String get homeExpiresSoon;

  /// No description provided for @homeNotProtectedNow.
  ///
  /// In en, this message translates to:
  /// **'Not protected'**
  String get homeNotProtectedNow;

  /// No description provided for @homeViewOrder.
  ///
  /// In en, this message translates to:
  /// **'View order'**
  String get homeViewOrder;

  /// No description provided for @homeOrderNew.
  ///
  /// In en, this message translates to:
  /// **'Order new sticker'**
  String get homeOrderNew;

  /// No description provided for @homeDaysLeft.
  ///
  /// In en, this message translates to:
  /// **'{count} days left'**
  String homeDaysLeft(int count);

  /// No description provided for @homeValidUntil.
  ///
  /// In en, this message translates to:
  /// **'Valid until {date}'**
  String homeValidUntil(String date);

  /// No description provided for @homeBannerBlocked.
  ///
  /// In en, this message translates to:
  /// **'Alerts are blocked. Allow notifications to hear them.'**
  String get homeBannerBlocked;

  /// No description provided for @homeBannerExpiring.
  ///
  /// In en, this message translates to:
  /// **'This sticker expires soon.'**
  String get homeBannerExpiring;

  /// No description provided for @homeBannerExpired.
  ///
  /// In en, this message translates to:
  /// **'This sticker has expired.'**
  String get homeBannerExpired;

  /// No description provided for @homeBannerPayment.
  ///
  /// In en, this message translates to:
  /// **'Payment is still pending.'**
  String get homeBannerPayment;

  /// No description provided for @debugStates.
  ///
  /// In en, this message translates to:
  /// **'States'**
  String get debugStates;

  /// No description provided for @debugNoVehicle.
  ///
  /// In en, this message translates to:
  /// **'No vehicle'**
  String get debugNoVehicle;

  /// No description provided for @debugNoSticker.
  ///
  /// In en, this message translates to:
  /// **'No sticker'**
  String get debugNoSticker;

  /// No description provided for @debugPaymentPending.
  ///
  /// In en, this message translates to:
  /// **'Payment pending'**
  String get debugPaymentPending;

  /// No description provided for @debugInTransit.
  ///
  /// In en, this message translates to:
  /// **'In transit'**
  String get debugInTransit;

  /// No description provided for @debugActive.
  ///
  /// In en, this message translates to:
  /// **'Protected'**
  String get debugActive;

  /// No description provided for @debugExpiring.
  ///
  /// In en, this message translates to:
  /// **'Expires soon'**
  String get debugExpiring;

  /// No description provided for @debugExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get debugExpired;

  /// No description provided for @debugFailedPayment.
  ///
  /// In en, this message translates to:
  /// **'Payment failed'**
  String get debugFailedPayment;

  /// No description provided for @debugEmptyAlerts.
  ///
  /// In en, this message translates to:
  /// **'No alerts'**
  String get debugEmptyAlerts;

  /// No description provided for @vehiclesTitle.
  ///
  /// In en, this message translates to:
  /// **'Vehicles'**
  String get vehiclesTitle;

  /// No description provided for @vehiclesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No vehicles yet'**
  String get vehiclesEmpty;

  /// No description provided for @vehiclesAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get vehiclesAdd;

  /// No description provided for @vehiclePlate.
  ///
  /// In en, this message translates to:
  /// **'Plate'**
  String get vehiclePlate;

  /// No description provided for @vehiclePlateHint.
  ///
  /// In en, this message translates to:
  /// **'Letters and digits, for example ABC 1234'**
  String get vehiclePlateHint;

  /// No description provided for @vehicleMake.
  ///
  /// In en, this message translates to:
  /// **'Make'**
  String get vehicleMake;

  /// No description provided for @vehicleMakeOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get vehicleMakeOther;

  /// No description provided for @vehicleModel.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get vehicleModel;

  /// No description provided for @vehicleColor.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get vehicleColor;

  /// No description provided for @vehicleSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get vehicleSave;

  /// No description provided for @vehicleDuplicate.
  ///
  /// In en, this message translates to:
  /// **'This plate is already registered.'**
  String get vehicleDuplicate;

  /// No description provided for @vehicleAddedBanner.
  ///
  /// In en, this message translates to:
  /// **'Order a sticker to protect this car.'**
  String get vehicleAddedBanner;

  /// No description provided for @vehicleViewQr.
  ///
  /// In en, this message translates to:
  /// **'View QR'**
  String get vehicleViewQr;

  /// No description provided for @vehicleAlerts.
  ///
  /// In en, this message translates to:
  /// **'Recent alerts'**
  String get vehicleAlerts;

  /// No description provided for @vehicleOrders.
  ///
  /// In en, this message translates to:
  /// **'Latest order'**
  String get vehicleOrders;

  /// No description provided for @vehicleEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get vehicleEdit;

  /// No description provided for @vehicleDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get vehicleDelete;

  /// No description provided for @vehicleDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this vehicle?'**
  String get vehicleDeleteTitle;

  /// No description provided for @vehicleDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'An active sticker will stop working. Deleting a vehicle does not create a refund.'**
  String get vehicleDeleteBody;

  /// No description provided for @actionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// No description provided for @actionBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get actionBack;

  /// No description provided for @actionMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get actionMore;

  /// No description provided for @vehicleNotFound.
  ///
  /// In en, this message translates to:
  /// **'This vehicle is not available.'**
  String get vehicleNotFound;

  /// No description provided for @qrPreview.
  ///
  /// In en, this message translates to:
  /// **'Preview scan page'**
  String get qrPreview;

  /// No description provided for @qrInactive.
  ///
  /// In en, this message translates to:
  /// **'Your QR becomes active when your payment is confirmed.'**
  String get qrInactive;

  /// No description provided for @colorWhite.
  ///
  /// In en, this message translates to:
  /// **'White'**
  String get colorWhite;

  /// No description provided for @colorBlack.
  ///
  /// In en, this message translates to:
  /// **'Black'**
  String get colorBlack;

  /// No description provided for @colorSilver.
  ///
  /// In en, this message translates to:
  /// **'Silver'**
  String get colorSilver;

  /// No description provided for @colorGray.
  ///
  /// In en, this message translates to:
  /// **'Gray'**
  String get colorGray;

  /// No description provided for @colorBlue.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get colorBlue;

  /// No description provided for @colorRed.
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get colorRed;

  /// No description provided for @colorGreen.
  ///
  /// In en, this message translates to:
  /// **'Green'**
  String get colorGreen;

  /// No description provided for @colorBeige.
  ///
  /// In en, this message translates to:
  /// **'Beige'**
  String get colorBeige;

  /// No description provided for @alertBlocking.
  ///
  /// In en, this message translates to:
  /// **'Blocking another car'**
  String get alertBlocking;

  /// No description provided for @alertLights.
  ///
  /// In en, this message translates to:
  /// **'Lights left on'**
  String get alertLights;

  /// No description provided for @alertDoor.
  ///
  /// In en, this message translates to:
  /// **'Door or window open'**
  String get alertDoor;

  /// No description provided for @alertTire.
  ///
  /// In en, this message translates to:
  /// **'Flat tire or damage'**
  String get alertTire;

  /// No description provided for @alertOther.
  ///
  /// In en, this message translates to:
  /// **'Other, urgent'**
  String get alertOther;

  /// No description provided for @alertOrderUpdate.
  ///
  /// In en, this message translates to:
  /// **'Order update'**
  String get alertOrderUpdate;

  /// No description provided for @alertExpiry.
  ///
  /// In en, this message translates to:
  /// **'Sticker expiry'**
  String get alertExpiry;

  /// No description provided for @alertHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} h ago'**
  String alertHoursAgo(int count);

  /// No description provided for @alertDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} d ago'**
  String alertDaysAgo(int count);

  /// No description provided for @orderLabel.
  ///
  /// In en, this message translates to:
  /// **'Order {number}'**
  String orderLabel(String number);

  /// No description provided for @orderStep.
  ///
  /// In en, this message translates to:
  /// **'{step}/3'**
  String orderStep(int step);

  /// No description provided for @orderVehicleTitle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle and validity'**
  String get orderVehicleTitle;

  /// No description provided for @orderDeliveryTitle.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get orderDeliveryTitle;

  /// No description provided for @orderReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Review and pay'**
  String get orderReviewTitle;

  /// No description provided for @orderMonths.
  ///
  /// In en, this message translates to:
  /// **'{count} months'**
  String orderMonths(int count);

  /// No description provided for @orderBestValue.
  ///
  /// In en, this message translates to:
  /// **'Best value'**
  String get orderBestValue;

  /// No description provided for @orderValidFor.
  ///
  /// In en, this message translates to:
  /// **'Valid for {months} months from payment.'**
  String orderValidFor(int months);

  /// No description provided for @orderValidityStarts.
  ///
  /// In en, this message translates to:
  /// **'The new validity starts when payment is confirmed.'**
  String get orderValidityStarts;

  /// No description provided for @orderAddVehicle.
  ///
  /// In en, this message translates to:
  /// **'Add a new vehicle'**
  String get orderAddVehicle;

  /// No description provided for @orderNoVehicle.
  ///
  /// In en, this message translates to:
  /// **'Add a vehicle to continue.'**
  String get orderNoVehicle;

  /// No description provided for @orderDeliveryEta.
  ///
  /// In en, this message translates to:
  /// **'Estimated delivery: {eta}'**
  String orderDeliveryEta(String eta);

  /// No description provided for @orderPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get orderPhone;

  /// No description provided for @orderStreet.
  ///
  /// In en, this message translates to:
  /// **'Street'**
  String get orderStreet;

  /// No description provided for @orderDistrict.
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get orderDistrict;

  /// No description provided for @orderBuilding.
  ///
  /// In en, this message translates to:
  /// **'Building'**
  String get orderBuilding;

  /// No description provided for @orderShortAddress.
  ///
  /// In en, this message translates to:
  /// **'Saudi short address (optional)'**
  String get orderShortAddress;

  /// No description provided for @orderNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get orderNotes;

  /// No description provided for @orderSaveAddress.
  ///
  /// In en, this message translates to:
  /// **'Save this address'**
  String get orderSaveAddress;

  /// No description provided for @orderSummary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get orderSummary;

  /// No description provided for @orderEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get orderEdit;

  /// No description provided for @orderSticker.
  ///
  /// In en, this message translates to:
  /// **'Sticker'**
  String get orderSticker;

  /// No description provided for @orderDeliveryFee.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get orderDeliveryFee;

  /// No description provided for @orderVat.
  ///
  /// In en, this message translates to:
  /// **'VAT'**
  String get orderVat;

  /// No description provided for @orderTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get orderTotal;

  /// No description provided for @orderMethods.
  ///
  /// In en, this message translates to:
  /// **'mada · Apple Pay · Visa · Mastercard'**
  String get orderMethods;

  /// No description provided for @orderPayConsentBefore.
  ///
  /// In en, this message translates to:
  /// **'By paying you accept the '**
  String get orderPayConsentBefore;

  /// No description provided for @orderPayTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms'**
  String get orderPayTerms;

  /// No description provided for @orderPayAnd.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get orderPayAnd;

  /// No description provided for @orderPayShipping.
  ///
  /// In en, this message translates to:
  /// **'Shipping and refunds policy'**
  String get orderPayShipping;

  /// No description provided for @orderPayConsentAfter.
  ///
  /// In en, this message translates to:
  /// **'.'**
  String get orderPayConsentAfter;

  /// No description provided for @orderPay.
  ///
  /// In en, this message translates to:
  /// **'Pay {amount}'**
  String orderPay(String amount);

  /// No description provided for @orderConfirming.
  ///
  /// In en, this message translates to:
  /// **'Confirming your payment…'**
  String get orderConfirming;

  /// No description provided for @orderPending.
  ///
  /// In en, this message translates to:
  /// **'We\'re confirming your payment. We\'ll notify you.'**
  String get orderPending;

  /// No description provided for @orderBackHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get orderBackHome;

  /// No description provided for @orderFailed.
  ///
  /// In en, this message translates to:
  /// **'Payment failed'**
  String get orderFailed;

  /// No description provided for @orderWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting for payment'**
  String get orderWaiting;

  /// No description provided for @orderPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get orderPaid;

  /// No description provided for @orderPrinted.
  ///
  /// In en, this message translates to:
  /// **'Printed'**
  String get orderPrinted;

  /// No description provided for @orderShipped.
  ///
  /// In en, this message translates to:
  /// **'Shipped'**
  String get orderShipped;

  /// No description provided for @orderDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get orderDelivered;

  /// No description provided for @orderCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get orderCancelled;

  /// No description provided for @orderExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get orderExpired;

  /// No description provided for @ordersTitle.
  ///
  /// In en, this message translates to:
  /// **'My orders'**
  String get ordersTitle;

  /// No description provided for @ordersEmpty.
  ///
  /// In en, this message translates to:
  /// **'No orders yet'**
  String get ordersEmpty;

  /// No description provided for @orderInvoice.
  ///
  /// In en, this message translates to:
  /// **'Download invoice'**
  String get orderInvoice;

  /// No description provided for @orderNeedHelp.
  ///
  /// In en, this message translates to:
  /// **'Need help with this order?'**
  String get orderNeedHelp;

  /// No description provided for @orderTracking.
  ///
  /// In en, this message translates to:
  /// **'Tracking number'**
  String get orderTracking;

  /// No description provided for @actionCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get actionCopy;

  /// No description provided for @orderCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get orderCopied;

  /// No description provided for @orderNotFound.
  ///
  /// In en, this message translates to:
  /// **'This order is not available.'**
  String get orderNotFound;

  /// No description provided for @debugPaySection.
  ///
  /// In en, this message translates to:
  /// **'Next payment'**
  String get debugPaySection;

  /// No description provided for @debugPaySucceeds.
  ///
  /// In en, this message translates to:
  /// **'Succeeds'**
  String get debugPaySucceeds;

  /// No description provided for @debugPayFails.
  ///
  /// In en, this message translates to:
  /// **'Fails'**
  String get debugPayFails;

  /// No description provided for @debugPayPending.
  ///
  /// In en, this message translates to:
  /// **'Stays pending'**
  String get debugPayPending;

  /// No description provided for @debugMarkDelivered.
  ///
  /// In en, this message translates to:
  /// **'Mark delivered'**
  String get debugMarkDelivered;

  /// No description provided for @alertsToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get alertsToday;

  /// No description provided for @alertsYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get alertsYesterday;

  /// No description provided for @alertChannelPush.
  ///
  /// In en, this message translates to:
  /// **'Push'**
  String get alertChannelPush;

  /// No description provided for @alertChannelWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get alertChannelWhatsapp;

  /// No description provided for @alertStatusSent.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get alertStatusSent;

  /// No description provided for @alertStatusDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get alertStatusDelivered;

  /// No description provided for @alertStatusRead.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get alertStatusRead;

  /// No description provided for @alertStatusFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get alertStatusFailed;

  /// No description provided for @alertStopAlarm.
  ///
  /// In en, this message translates to:
  /// **'Stop alarm'**
  String get alertStopAlarm;

  /// No description provided for @alertComing.
  ///
  /// In en, this message translates to:
  /// **'I\'m coming'**
  String get alertComing;

  /// No description provided for @alertComingDone.
  ///
  /// In en, this message translates to:
  /// **'You told them you\'re coming.'**
  String get alertComingDone;

  /// No description provided for @alertSpam.
  ///
  /// In en, this message translates to:
  /// **'Report as spam'**
  String get alertSpam;

  /// No description provided for @alertSpamTitle.
  ///
  /// In en, this message translates to:
  /// **'Report this alert?'**
  String get alertSpamTitle;

  /// No description provided for @alertSpamBody.
  ///
  /// In en, this message translates to:
  /// **'It will be removed from your alerts.'**
  String get alertSpamBody;

  /// No description provided for @alertSpamConfirm.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get alertSpamConfirm;

  /// No description provided for @alertDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Alerts may be delayed or missed if your phone is off, muted, or offline.'**
  String get alertDisclaimer;

  /// No description provided for @alertNotFound.
  ///
  /// In en, this message translates to:
  /// **'This alert is not available.'**
  String get alertNotFound;

  /// No description provided for @debugSimulateAlert.
  ///
  /// In en, this message translates to:
  /// **'Simulate alert'**
  String get debugSimulateAlert;

  /// No description provided for @accountEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get accountEdit;

  /// No description provided for @accountPhoneLocked.
  ///
  /// In en, this message translates to:
  /// **'To change your number, contact support.'**
  String get accountPhoneLocked;

  /// No description provided for @accountNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get accountNotifications;

  /// No description provided for @accountLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get accountLanguage;

  /// No description provided for @accountHelp.
  ///
  /// In en, this message translates to:
  /// **'Help and contact'**
  String get accountHelp;

  /// No description provided for @accountLegal.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get accountLegal;

  /// No description provided for @accountDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get accountDelete;

  /// No description provided for @accountLogOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get accountLogOut;

  /// No description provided for @accountLogOutTitle.
  ///
  /// In en, this message translates to:
  /// **'Log out?'**
  String get accountLogOutTitle;

  /// No description provided for @accountLogOutBody.
  ///
  /// In en, this message translates to:
  /// **'You can sign in again with your number.'**
  String get accountLogOutBody;

  /// No description provided for @accountVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String accountVersion(String version);

  /// No description provided for @accountWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp alerts'**
  String get accountWhatsapp;

  /// No description provided for @accountPush.
  ///
  /// In en, this message translates to:
  /// **'Push alerts'**
  String get accountPush;

  /// No description provided for @accountOneChannel.
  ///
  /// In en, this message translates to:
  /// **'At least one of these stays on.'**
  String get accountOneChannel;

  /// No description provided for @accountAlarmStyle.
  ///
  /// In en, this message translates to:
  /// **'Alert style'**
  String get accountAlarmStyle;

  /// No description provided for @accountAlarmLoud.
  ///
  /// In en, this message translates to:
  /// **'Loud alarm'**
  String get accountAlarmLoud;

  /// No description provided for @accountAlarmNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get accountAlarmNormal;

  /// No description provided for @accountMarketing.
  ///
  /// In en, this message translates to:
  /// **'Offers and news'**
  String get accountMarketing;

  /// No description provided for @accountTestAlert.
  ///
  /// In en, this message translates to:
  /// **'Send test alert'**
  String get accountTestAlert;

  /// No description provided for @accountChecklist.
  ///
  /// In en, this message translates to:
  /// **'On this phone'**
  String get accountChecklist;

  /// No description provided for @accountNotifAllowed.
  ///
  /// In en, this message translates to:
  /// **'Notifications allowed'**
  String get accountNotifAllowed;

  /// No description provided for @accountLoudReady.
  ///
  /// In en, this message translates to:
  /// **'Loud alerts set up'**
  String get accountLoudReady;

  /// No description provided for @accountStatusOn.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get accountStatusOn;

  /// No description provided for @accountStatusOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get accountStatusOff;

  /// No description provided for @accountFix.
  ///
  /// In en, this message translates to:
  /// **'Fix'**
  String get accountFix;

  /// No description provided for @accountSettingsPhone.
  ///
  /// In en, this message translates to:
  /// **'This opens system settings on your phone.'**
  String get accountSettingsPhone;

  /// No description provided for @accountContact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get accountContact;

  /// No description provided for @accountWhatsappContact.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get accountWhatsappContact;

  /// No description provided for @accountEmailContact.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get accountEmailContact;

  /// No description provided for @alertTestTitle.
  ///
  /// In en, this message translates to:
  /// **'Test alert'**
  String get alertTestTitle;

  /// No description provided for @deleteBody.
  ///
  /// In en, this message translates to:
  /// **'Vehicles and alert history are removed. The sticker stops working. Records required by law, such as invoices, are kept.'**
  String get deleteBody;

  /// No description provided for @deleteInProgress.
  ///
  /// In en, this message translates to:
  /// **'A sticker order is still on the way. Contact support if you need help with it.'**
  String get deleteInProgress;

  /// No description provided for @deleteReason.
  ///
  /// In en, this message translates to:
  /// **'Reason (optional)'**
  String get deleteReason;

  /// No description provided for @deleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete your account?'**
  String get deleteConfirmTitle;

  /// No description provided for @deleteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This cannot be undone.'**
  String get deleteConfirmBody;

  /// No description provided for @faqHowTitle.
  ///
  /// In en, this message translates to:
  /// **'How does it work?'**
  String get faqHowTitle;

  /// No description provided for @faqHowBody.
  ///
  /// In en, this message translates to:
  /// **'Someone scans the sticker on your car, picks a reason, and you get a push, a WhatsApp message, and an alert in the app. Your number is not shared.'**
  String get faqHowBody;

  /// No description provided for @faqNumberTitle.
  ///
  /// In en, this message translates to:
  /// **'Is my number visible?'**
  String get faqNumberTitle;

  /// No description provided for @faqNumberBody.
  ///
  /// In en, this message translates to:
  /// **'No. People who scan your sticker do not see your phone number.'**
  String get faqNumberBody;

  /// No description provided for @faqReachTitle.
  ///
  /// In en, this message translates to:
  /// **'What if I\'m not reachable?'**
  String get faqReachTitle;

  /// No description provided for @faqReachBody.
  ///
  /// In en, this message translates to:
  /// **'Alerts may be delayed or missed if your phone is off, muted, or offline. The same alert is also sent on WhatsApp.'**
  String get faqReachBody;

  /// No description provided for @faqExpireTitle.
  ///
  /// In en, this message translates to:
  /// **'What if my sticker expires?'**
  String get faqExpireTitle;

  /// No description provided for @faqExpireBody.
  ///
  /// In en, this message translates to:
  /// **'Order a new sticker. You can still open the app, see your vehicles, and read old alerts.'**
  String get faqExpireBody;

  /// No description provided for @faqDeliveryTitle.
  ///
  /// In en, this message translates to:
  /// **'How long does delivery take?'**
  String get faqDeliveryTitle;

  /// No description provided for @faqDeliveryBody.
  ///
  /// In en, this message translates to:
  /// **'Estimated delivery is {eta}.'**
  String faqDeliveryBody(String eta);

  /// No description provided for @faqDeliveryPending.
  ///
  /// In en, this message translates to:
  /// **'The estimated delivery time is shown when you order a sticker.'**
  String get faqDeliveryPending;

  /// No description provided for @faqMoveTitle.
  ///
  /// In en, this message translates to:
  /// **'Can I move the sticker to another car?'**
  String get faqMoveTitle;

  /// No description provided for @faqMoveBody.
  ///
  /// In en, this message translates to:
  /// **'A sticker belongs to one vehicle. Order a new sticker for another car.'**
  String get faqMoveBody;

  /// No description provided for @faqSilentTitle.
  ///
  /// In en, this message translates to:
  /// **'Do alerts work when my phone is silent?'**
  String get faqSilentTitle;

  /// No description provided for @faqSilentBody.
  ///
  /// In en, this message translates to:
  /// **'Alerts may be delayed or missed if your phone is off, muted, or offline. You can choose a loud alarm in Notifications.'**
  String get faqSilentBody;

  /// No description provided for @faqDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'How do I delete my account?'**
  String get faqDeleteTitle;

  /// No description provided for @faqDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'Open Account, then Delete account. Vehicles and alert history are removed, and the sticker stops working. Invoices are kept.'**
  String get faqDeleteBody;

  /// No description provided for @offlineBanner.
  ///
  /// In en, this message translates to:
  /// **'You are offline. Some details may be out of date.'**
  String get offlineBanner;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
