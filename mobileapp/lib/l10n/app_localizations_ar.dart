// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'نواصل';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navVehicles => 'المركبات';

  @override
  String get navOrderSticker => 'اطلب ملصقاً';

  @override
  String get navAlerts => 'التنبيهات';

  @override
  String get navAccount => 'الحساب';

  @override
  String get placeholderBody => 'هذه الشاشة غير مكتملة بعد.';

  @override
  String get actionContinue => 'متابعة';

  @override
  String get actionContinueNew => 'متابعة كمستخدم جديد';

  @override
  String get actionContinueReturning => 'متابعة كمستخدم سابق';

  @override
  String get actionRetry => 'حاول مرة أخرى';

  @override
  String get actionSkip => 'تخطي';

  @override
  String get actionNext => 'التالي';

  @override
  String get actionGetStarted => 'ابدأ';

  @override
  String get languageEn => 'EN';

  @override
  String get languageAr => 'AR';

  @override
  String get errorGenericTitle => 'حدث خطأ';

  @override
  String get errorGenericBody => 'يرجى المحاولة مرة أخرى.';

  @override
  String get emptyTitle => 'لا يوجد شيء هنا';

  @override
  String get onboardingTitle1 => 'أضف سيارتك';

  @override
  String get onboardingBody1 => 'سجّل مركبتك. لن يستغرق ذلك سوى دقيقة.';

  @override
  String get onboardingTitle2 => 'ألصق الرمز على سيارتك';

  @override
  String get onboardingBody2 => 'نرسل ملصقاً يحمل رمزاً. لا يُطبع رقم اللوحة.';

  @override
  String get onboardingTitle3 => 'تنبيهات خاصة';

  @override
  String get onboardingBody3 => 'لن يُشارك رقمك أبداً.';

  @override
  String get phoneTitle => 'أدخل رقمك';

  @override
  String get phoneSubtitle => 'سنرسل رمزاً عبر واتساب.';

  @override
  String get phoneInvalid => 'أدخل رقم جوال يبدأ بالرقم 5.';

  @override
  String phoneRateLimited(int seconds) {
    return 'محاولات كثيرة. أعد المحاولة بعد $seconds ث.';
  }

  @override
  String get phoneNetwork =>
      'تعذر الاتصال بنواصل. تحقق من الشبكة ثم أعد المحاولة.';

  @override
  String get phoneConsentBefore => 'بالمتابعة فأنت توافق على ';

  @override
  String get phoneConsentTerms => 'الشروط';

  @override
  String get phoneConsentAnd => ' و';

  @override
  String get phoneConsentPrivacy => 'سياسة الخصوصية';

  @override
  String get phoneConsentAfter =>
      '، وعلى استلام رسائل الخدمة (الرموز والتنبيهات وتحديثات الطلب) عبر واتساب.';

  @override
  String get phoneMarketing => 'أرسل لي العروض والأخبار';

  @override
  String get verifyTitle =>
      'أدخل الرمز المكوّن من 6 أرقام الذي أرسلناه عبر واتساب';

  @override
  String verifySentTo(String phone) {
    return 'أُرسل إلى $phone';
  }

  @override
  String get verifyEdit => 'تعديل الرقم';

  @override
  String get verifyResend => 'إعادة إرسال الرمز';

  @override
  String verifyResendIn(int seconds) {
    return 'إعادة الإرسال بعد $seconds ث';
  }

  @override
  String get verifyOpenWhatsapp => 'افتح واتساب';

  @override
  String verifyWrongCode(int count) {
    return 'الرمز غير صحيح. تبقّت $count محاولات.';
  }

  @override
  String get verifyExpired => 'انتهت صلاحية الرمز. اطلب رمزاً جديداً.';

  @override
  String verifyLocked(int seconds) {
    return 'محاولات كثيرة. أعد المحاولة بعد $seconds ث.';
  }

  @override
  String get verifyNoWhatsapp =>
      'تعذر تسليم الرمز. تأكد أن هذا الرقم يستخدم واتساب، أو تواصل مع الدعم.';

  @override
  String get verifyHelp => 'المساعدة';

  @override
  String get nameTitle => 'بماذا نناديك؟';

  @override
  String get nameLabel => 'الاسم';

  @override
  String get nameHint => 'اسمك';

  @override
  String get nameInvalid => 'استخدم من 2 إلى 50 حرفاً.';

  @override
  String get cityLabel => 'المدينة';

  @override
  String get cityHint => 'اختر مدينتك';

  @override
  String get cityRiyadh => 'الرياض';

  @override
  String get cityJeddah => 'جدة';

  @override
  String get cityMakkah => 'مكة';

  @override
  String get cityMadinah => 'المدينة';

  @override
  String get cityDammam => 'الدمام';

  @override
  String get cityKhobar => 'الخبر';

  @override
  String get cityTaif => 'الطائف';

  @override
  String get cityTabuk => 'تبوك';

  @override
  String get cityAbha => 'أبها';

  @override
  String get cityBuraydah => 'بريدة';

  @override
  String get cityHail => 'حائل';

  @override
  String get cityNajran => 'نجران';

  @override
  String get cityJazan => 'جازان';

  @override
  String get cityYanbu => 'ينبع';

  @override
  String get alertsTitle => 'السماح بالتنبيهات';

  @override
  String get alertsBody =>
      'تصل التنبيهات مع صوت. قد تفوتك إذا كان الهاتف مغلقاً أو صامتاً أو غير متصل.';

  @override
  String get alertsAllow => 'السماح بالتنبيهات';

  @override
  String get alertsLater => 'لاحقاً';

  @override
  String get alertsAndroidTitle => 'اجعل التنبيه عالياً';

  @override
  String get alertsAndroidBody =>
      'يمكنك السماح بتنبيه عالٍ من إعدادات النظام. هذه الخطوة اختيارية.';

  @override
  String get legalPrivacy => 'سياسة الخصوصية';

  @override
  String get legalTerms => 'الشروط';

  @override
  String get legalShipping => 'الشحن والاسترداد';

  @override
  String get legalMissing => 'هذا المستند غير متاح.';

  @override
  String get privacyS1Title => 'ماذا نجمع';

  @override
  String get privacyS1Body =>
      'نجمع رقم هاتفك واسمك ومدينتك وعنوان التوصيل وبيانات المركبة ورمز التنبيهات وسجل الطلبات والتنبيهات.';

  @override
  String get privacyS2Title => 'كيف نستخدمها';

  @override
  String get privacyS2Body =>
      'نستخدمها لإرسال الرموز والتنبيهات وتحديثات الطلب. من يمسح الملصق لا يرى رقم هاتفك.';

  @override
  String get privacyS3Title => 'اختياراتك';

  @override
  String get privacyS3Body =>
      'العروض والأخبار اختيارية وتبقى متوقفة ما لم تطلبها. يمكنك حذف حسابك من التطبيق.';

  @override
  String get termsS1Title => 'الخدمة';

  @override
  String get termsS1Body =>
      'يتيح لك نواصل أن ينبّهك أحد بشأن سيارتك دون مشاركة رقمك. قد يتأخر التنبيه أو يفوتك إذا كان الهاتف مغلقاً أو صامتاً أو غير متصل.';

  @override
  String get termsS2Title => 'الملصقات';

  @override
  String get termsS2Body =>
      'يسري الملصق لثلاثة أو ستة أو اثني عشر شهراً من تأكيد الدفع. التطبيق نفسه مجاني.';

  @override
  String get termsS3Title => 'الرسائل';

  @override
  String get termsS3Body =>
      'رسائل الخدمة عبر واتساب (الرموز والتنبيهات وتحديثات الطلب) جزء من استخدام نواصل. العروض والأخبار خيار منفصل.';

  @override
  String get shippingS1Title => 'التوصيل';

  @override
  String get shippingS1Body =>
      'كل طلب ملصق واحد يُرسل إلى العنوان الذي تعطينا إياه. المدة الظاهرة عند الطلب تقديرية.';

  @override
  String get shippingS2Title => 'المساعدة في الطلب';

  @override
  String get shippingS2Body =>
      'إذا فُقد الملصق أو تلف، أو احتجت مساعدة في طلب، تواصل مع الدعم.';

  @override
  String homeGreetingMorning(String name) {
    return 'صباح الخير، $name';
  }

  @override
  String homeGreetingAfternoon(String name) {
    return 'طاب يومك، $name';
  }

  @override
  String homeGreetingEvening(String name) {
    return 'مساء الخير، $name';
  }

  @override
  String get homeAddVehicle => 'أضف مركبة';

  @override
  String get homeOrderSticker => 'اطلب ملصقاً';

  @override
  String get homeMyQr => 'رمزي';

  @override
  String get homeRecentAlerts => 'أحدث التنبيهات';

  @override
  String get homeSeeAll => 'عرض الكل';

  @override
  String get homeNoAlerts => 'لا توجد تنبيهات بعد.';

  @override
  String get homeAddFirst => 'أضف مركبتك الأولى';

  @override
  String get homeNotProtected => 'غير محمي بعد';

  @override
  String get homeWaitingPayment => 'بانتظار الدفع';

  @override
  String get homeOnTheWay => 'الملصق في الطريق';

  @override
  String get homeProtected => 'محمي';

  @override
  String get homeExpiresSoon => 'تنتهي الصلاحية قريباً';

  @override
  String get homeNotProtectedNow => 'غير محمي';

  @override
  String get homeViewOrder => 'عرض الطلب';

  @override
  String get homeOrderNew => 'اطلب ملصقاً جديداً';

  @override
  String homeDaysLeft(int count) {
    return 'متبقٍ $count يوماً';
  }

  @override
  String homeValidUntil(String date) {
    return 'صالح حتى $date';
  }

  @override
  String get homeBannerBlocked => 'التنبيهات موقوفة. اسمح بها لتسمعها.';

  @override
  String get homeBannerExpiring => 'صلاحية هذا الملصق قاربت على الانتهاء.';

  @override
  String get homeBannerExpired => 'انتهت صلاحية هذا الملصق.';

  @override
  String get homeBannerPayment => 'الدفع ما زال معلقاً.';

  @override
  String get debugStates => 'الحالات';

  @override
  String get debugNoVehicle => 'بدون مركبة';

  @override
  String get debugNoSticker => 'بدون ملصق';

  @override
  String get debugPaymentPending => 'دفع معلّق';

  @override
  String get debugInTransit => 'في الطريق';

  @override
  String get debugActive => 'محمي';

  @override
  String get debugExpiring => 'قاربت النهاية';

  @override
  String get debugExpired => 'منتهٍ';

  @override
  String get debugFailedPayment => 'فشل الدفع';

  @override
  String get debugEmptyAlerts => 'بلا تنبيهات';

  @override
  String get vehiclesTitle => 'المركبات';

  @override
  String get vehiclesEmpty => 'لا توجد مركبات بعد';

  @override
  String get vehiclesAdd => 'إضافة';

  @override
  String get vehiclePlate => 'اللوحة';

  @override
  String get vehiclePlateHint => 'حروف وأرقام، مثل ABC 1234';

  @override
  String get vehicleMake => 'الشركة';

  @override
  String get vehicleMakeOther => 'أخرى';

  @override
  String get vehicleModel => 'الطراز';

  @override
  String get vehicleColor => 'اللون';

  @override
  String get vehicleSave => 'حفظ';

  @override
  String get vehicleDuplicate => 'هذه اللوحة مسجلة بالفعل.';

  @override
  String get vehicleAddedBanner => 'اطلب ملصقاً لحماية هذه السيارة.';

  @override
  String get vehicleViewQr => 'عرض الرمز';

  @override
  String get vehicleAlerts => 'أحدث التنبيهات';

  @override
  String get vehicleOrders => 'آخر طلب';

  @override
  String get vehicleEdit => 'تعديل';

  @override
  String get vehicleDelete => 'حذف';

  @override
  String get vehicleDeleteTitle => 'حذف هذه المركبة؟';

  @override
  String get vehicleDeleteBody =>
      'سيتوقف الملصق النشط عن العمل. حذف المركبة لا ينشئ استرداداً.';

  @override
  String get actionCancel => 'إلغاء';

  @override
  String get actionBack => 'رجوع';

  @override
  String get actionMore => 'المزيد';

  @override
  String get vehicleNotFound => 'هذه المركبة غير متاحة.';

  @override
  String get qrPreview => 'معاينة صفحة المسح';

  @override
  String get qrInactive => 'يصبح الرمز نشطاً عند تأكيد الدفع.';

  @override
  String get colorWhite => 'أبيض';

  @override
  String get colorBlack => 'أسود';

  @override
  String get colorSilver => 'فضي';

  @override
  String get colorGray => 'رمادي';

  @override
  String get colorBlue => 'أزرق';

  @override
  String get colorRed => 'أحمر';

  @override
  String get colorGreen => 'أخضر';

  @override
  String get colorBeige => 'بيج';

  @override
  String get alertBlocking => 'يعيق سيارة أخرى';

  @override
  String get alertLights => 'الأضواء ما زالت تعمل';

  @override
  String get alertDoor => 'باب أو نافذة مفتوحة';

  @override
  String get alertTire => 'إطار فارغ أو ضرر';

  @override
  String get alertOther => 'أمر آخر عاجل';

  @override
  String get alertOrderUpdate => 'تحديث الطلب';

  @override
  String get alertExpiry => 'انتهاء الملصق';

  @override
  String alertHoursAgo(int count) {
    return 'قبل $count س';
  }

  @override
  String alertDaysAgo(int count) {
    return 'قبل $count ي';
  }

  @override
  String orderLabel(String number) {
    return 'طلب $number';
  }

  @override
  String orderStep(int step) {
    return '$step/3';
  }

  @override
  String get orderVehicleTitle => 'المركبة والمدة';

  @override
  String get orderDeliveryTitle => 'التوصيل';

  @override
  String get orderReviewTitle => 'المراجعة والدفع';

  @override
  String orderMonths(int count) {
    return '$count شهر';
  }

  @override
  String get orderBestValue => 'أفضل قيمة';

  @override
  String orderValidFor(int months) {
    return 'يسري $months شهرًا من تأكيد الدفع.';
  }

  @override
  String get orderValidityStarts => 'تبدأ المدة الجديدة عند تأكيد الدفع.';

  @override
  String get orderAddVehicle => 'أضف مركبة جديدة';

  @override
  String get orderNoVehicle => 'أضف مركبة للمتابعة.';

  @override
  String orderDeliveryEta(String eta) {
    return 'التوصيل المتوقع: $eta';
  }

  @override
  String get orderPhone => 'الجوال';

  @override
  String get orderStreet => 'الشارع';

  @override
  String get orderDistrict => 'الحي';

  @override
  String get orderBuilding => 'المبنى';

  @override
  String get orderShortAddress => 'العنوان المختصر (اختياري)';

  @override
  String get orderNotes => 'ملاحظات (اختياري)';

  @override
  String get orderSaveAddress => 'احفظ هذا العنوان';

  @override
  String get orderSummary => 'الملخص';

  @override
  String get orderEdit => 'تعديل';

  @override
  String get orderSticker => 'الملصق';

  @override
  String get orderDeliveryFee => 'التوصيل';

  @override
  String get orderVat => 'ضريبة القيمة المضافة';

  @override
  String get orderTotal => 'المجموع';

  @override
  String get orderMethods => 'mada · Apple Pay · Visa · Mastercard';

  @override
  String get orderPayConsentBefore => 'بالدفع أنت توافق على ';

  @override
  String get orderPayTerms => 'الشروط';

  @override
  String get orderPayAnd => ' و';

  @override
  String get orderPayShipping => 'سياسة الشحن والاسترداد';

  @override
  String get orderPayConsentAfter => '.';

  @override
  String orderPay(String amount) {
    return 'ادفع $amount';
  }

  @override
  String get orderConfirming => 'نؤكد عملية الدفع…';

  @override
  String get orderPending => 'نؤكد عملية الدفع. سنبلغك عند الاكتمال.';

  @override
  String get orderBackHome => 'العودة للرئيسية';

  @override
  String get orderFailed => 'فشل الدفع';

  @override
  String get orderWaiting => 'بانتظار الدفع';

  @override
  String get orderPaid => 'مدفوع';

  @override
  String get orderPrinted => 'طُبع';

  @override
  String get orderShipped => 'شُحن';

  @override
  String get orderDelivered => 'تم التسليم';

  @override
  String get orderCancelled => 'ملغى';

  @override
  String get orderExpired => 'منتهٍ';

  @override
  String get ordersTitle => 'طلباتي';

  @override
  String get ordersEmpty => 'لا توجد طلبات بعد';

  @override
  String get orderInvoice => 'تنزيل الفاتورة';

  @override
  String get orderNeedHelp => 'تحتاج مساعدة في هذا الطلب؟';

  @override
  String get orderTracking => 'رقم التتبع';

  @override
  String get actionCopy => 'نسخ';

  @override
  String get orderCopied => 'تم النسخ';

  @override
  String get orderNotFound => 'هذا الطلب غير متاح.';

  @override
  String get debugPaySection => 'الدفع التالي';

  @override
  String get debugPaySucceeds => 'ينجح';

  @override
  String get debugPayFails => 'يفشل';

  @override
  String get debugPayPending => 'يبقى قيد التأكيد';

  @override
  String get debugMarkDelivered => 'تعليم كمستلم';

  @override
  String get alertsToday => 'اليوم';

  @override
  String get alertsYesterday => 'أمس';

  @override
  String get alertChannelPush => 'إشعار';

  @override
  String get alertChannelWhatsapp => 'واتساب';

  @override
  String get alertStatusSent => 'أُرسل';

  @override
  String get alertStatusDelivered => 'تم التسليم';

  @override
  String get alertStatusRead => 'قُرئ';

  @override
  String get alertStatusFailed => 'فشل';

  @override
  String get alertStopAlarm => 'إيقاف التنبيه';

  @override
  String get alertComing => 'أنا قادم';

  @override
  String get alertComingDone => 'أخبرتهم أنك في الطريق.';

  @override
  String get alertSpam => 'إبلاغ كرسالة مزعجة';

  @override
  String get alertSpamTitle => 'الإبلاغ عن هذا التنبيه؟';

  @override
  String get alertSpamBody => 'سيُزال من قائمة التنبيهات.';

  @override
  String get alertSpamConfirm => 'إبلاغ';

  @override
  String get alertDisclaimer =>
      'قد تتأخر التنبيهات أو تفوتك إذا كان الهاتف مغلقًا أو صامتًا أو غير متصل.';

  @override
  String get alertNotFound => 'هذا التنبيه غير متاح.';

  @override
  String get debugSimulateAlert => 'محاكاة تنبيه';

  @override
  String get accountEdit => 'تعديل الملف';

  @override
  String get accountPhoneLocked => 'لتغيير رقمك، تواصل مع الدعم.';

  @override
  String get accountNotifications => 'التنبيهات';

  @override
  String get accountLanguage => 'اللغة';

  @override
  String get accountHelp => 'المساعدة والتواصل';

  @override
  String get accountLegal => 'الشؤون القانونية';

  @override
  String get accountDelete => 'حذف الحساب';

  @override
  String get accountLogOut => 'تسجيل الخروج';

  @override
  String get accountLogOutTitle => 'تسجيل الخروج؟';

  @override
  String get accountLogOutBody => 'يمكنك تسجيل الدخول مرة أخرى برقمك.';

  @override
  String accountVersion(String version) {
    return 'الإصدار $version';
  }

  @override
  String get accountWhatsapp => 'تنبيهات واتساب';

  @override
  String get accountPush => 'تنبيهات التطبيق';

  @override
  String get accountOneChannel =>
      'يبقى واحد من هذين الخيارين مفعّلاً على الأقل.';

  @override
  String get accountAlarmStyle => 'نمط التنبيه';

  @override
  String get accountAlarmLoud => 'تنبيه مرتفع';

  @override
  String get accountAlarmNormal => 'عادي';

  @override
  String get accountMarketing => 'العروض والأخبار';

  @override
  String get accountTestAlert => 'إرسال تنبيه تجريبي';

  @override
  String get accountChecklist => 'على هذا الهاتف';

  @override
  String get accountNotifAllowed => 'التنبيهات مسموحة';

  @override
  String get accountLoudReady => 'التنبيه المرتفع جاهز';

  @override
  String get accountStatusOn => 'مفعّل';

  @override
  String get accountStatusOff => 'غير مفعّل';

  @override
  String get accountFix => 'إصلاح';

  @override
  String get accountSettingsPhone => 'هذا يفتح إعدادات النظام على هاتفك.';

  @override
  String get accountContact => 'تواصل';

  @override
  String get accountWhatsappContact => 'واتساب';

  @override
  String get accountEmailContact => 'البريد';

  @override
  String get alertTestTitle => 'تنبيه تجريبي';

  @override
  String get deleteBody =>
      'تُحذف المركبات وسجل التنبيهات. يتوقف الملصق عن العمل. تُحفظ السجلات التي يفرضها النظام، مثل الفواتير.';

  @override
  String get deleteInProgress =>
      'طلب ملصق ما زال في الطريق. تواصل مع الدعم إذا احتجت مساعدة.';

  @override
  String get deleteReason => 'السبب (اختياري)';

  @override
  String get deleteConfirmTitle => 'حذف حسابك؟';

  @override
  String get deleteConfirmBody => 'لا يمكن التراجع عن هذا.';

  @override
  String get faqHowTitle => 'كيف يعمل؟';

  @override
  String get faqHowBody =>
      'يمسح شخص الملصق على سيارتك، يختار سبباً، ويصلك إشعار ورسالة واتساب وتنبيه داخل التطبيق. رقمك غير ظاهر.';

  @override
  String get faqNumberTitle => 'هل رقمي ظاهر؟';

  @override
  String get faqNumberBody => 'لا. من يمسح الملصق لا يرى رقم هاتفك.';

  @override
  String get faqReachTitle => 'ماذا لو لم أكن متاحاً؟';

  @override
  String get faqReachBody =>
      'قد تتأخر التنبيهات أو تفوتك إذا كان الهاتف مغلقاً أو صامتاً أو غير متصل. يُرسل التنبيه أيضاً عبر واتساب.';

  @override
  String get faqExpireTitle => 'ماذا لو انتهت صلاحية الملصق؟';

  @override
  String get faqExpireBody =>
      'اطلب ملصقاً جديداً. يبقى بإمكانك فتح التطبيق ورؤية مركباتك وقراءة التنبيهات السابقة.';

  @override
  String get faqDeliveryTitle => 'كم يستغرق التوصيل؟';

  @override
  String faqDeliveryBody(String eta) {
    return 'التوصيل المتوقع: $eta.';
  }

  @override
  String get faqDeliveryPending => 'يظهر وقت التوصيل المتوقع عند طلب الملصق.';

  @override
  String get faqMoveTitle => 'هل يمكن نقل الملصق إلى سيارة أخرى؟';

  @override
  String get faqMoveBody =>
      'الملصق مرتبط بمركبة واحدة. اطلب ملصقاً جديداً لسيارة أخرى.';

  @override
  String get faqSilentTitle => 'هل تعمل التنبيهات والهاتف صامت؟';

  @override
  String get faqSilentBody =>
      'قد تتأخر التنبيهات أو تفوتك إذا كان الهاتف مغلقاً أو صامتاً أو غير متصل. يمكنك اختيار تنبيه مرتفع من التنبيهات.';

  @override
  String get faqDeleteTitle => 'كيف أحذف حسابي؟';

  @override
  String get faqDeleteBody =>
      'افتح الحساب ثم حذف الحساب. تُحذف المركبات وسجل التنبيهات ويتوقف الملصق. تُحفظ الفواتير.';

  @override
  String get offlineBanner => 'أنت غير متصل. قد لا تكون بعض التفاصيل محدثة.';
}
