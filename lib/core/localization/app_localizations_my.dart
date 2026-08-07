// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Burmese (`my`).
class AppLocalizationsMy extends AppLocalizations {
  AppLocalizationsMy([String locale = 'my']) : super(locale);

  @override
  String get appTitle => 'လုံခြုံစိတ်ချရသော အက်ပ်';

  @override
  String welcomeMessage(String username) {
    return '$username၊ ပြန်လည်ကြိုဆိုပါသည်!';
  }

  @override
  String get login => 'အကောင့်ဝင်ရန်';

  @override
  String get logout => 'ထွက်ရန်';

  @override
  String get settings => 'ဆက်တင်များ';

  @override
  String get language => 'ဘာသာစကား';

  @override
  String get english => 'English';

  @override
  String get languageCode => 'my';

  @override
  String networkStatus(Object status) {
    return 'Your network connection is :$status.';
  }

  @override
  String get offlineDataNotice =>
      'သိမ်းဆည်းထားသော အော့ဖ်လိုင်းဒေတာကို ပြသနေသည်။';

  @override
  String get errorUnknown => 'မမျှော်လင့်ထားသော အမှားတစ်ခု ဖြစ်ပွားခဲ့သည်။';

  @override
  String get errorNetwork => 'အင်တာနက်ချိတ်ဆက်မှု မရှိပါ။';

  @override
  String get errorConnectionTimeout => 'ချိတ်ဆက်ချိန် ကျော်လွန်သွားပါသည်။';

  @override
  String get errorReceiveTimeout =>
      'ဆာဗာမှ ပြန်လည်တုံ့ပြန်ရန် အချိန်ကျော်လွန်သွားပါသည်။';

  @override
  String get errorSendTimeout =>
      'တောင်းဆိုမှု ပေးပို့ချိန် ကျော်လွန်သွားပါသည်။';

  @override
  String get errorRequestCancelled => 'တောင်းဆိုမှုကို ပယ်ဖျက်လိုက်ပါသည်။';

  @override
  String get errorCertificate => 'ဆာဗာ လုံခြုံရေး လက်မှတ်ကို စစ်ဆေး၍ မရပါ။';

  @override
  String get errorSocket => 'ဆာဗာသို့ ချိတ်ဆက်၍ မရပါ။';

  @override
  String get errorHostLookup => 'ဆာဗာလိပ်စာကို ရှာမတွေ့ပါ။';

  @override
  String get errorBadRequest => 'မမှန်ကန်သော တောင်းဆိုမှုဖြစ်ပါသည်။';

  @override
  String get errorUnauthorized =>
      'Session သက်တမ်းကုန်သွားပါပြီ။ ကျေးဇူးပြု၍ ပြန်လည်ဝင်ရောက်ပါ။';

  @override
  String get errorForbidden =>
      'ဤလုပ်ဆောင်ချက်ကို လုပ်ဆောင်ရန် ခွင့်ပြုချက်မရှိပါ။';

  @override
  String get errorNotFound => 'တောင်းဆိုထားသော ဒေတာကို မတွေ့ပါ။';

  @override
  String get errorMethodNotAllowed => 'ဤလုပ်ဆောင်မှုကို ခွင့်မပြုပါ။';

  @override
  String get errorRequestTimeout => 'တောင်းဆိုမှု အချိန်ကျော်လွန်သွားပါသည်။';

  @override
  String get errorConflict => 'ဒေတာ ပဋိပက္ခ ဖြစ်ပွားနေပါသည်။';

  @override
  String get errorGone => 'တောင်းဆိုထားသော အချက်အလက် မရှိတော့ပါ။';

  @override
  String get errorValidation => 'အချက်အလက် စစ်ဆေးမှု မအောင်မြင်ပါ။';

  @override
  String get errorTooManyRequests =>
      'တောင်းဆိုမှုများလွန်းနေပါသည်။ ခဏအကြာတွင် ထပ်မံကြိုးစားပါ။';

  @override
  String get errorInternalServer => 'ဆာဗာတွင် အမှားဖြစ်ပွားနေပါသည်။';

  @override
  String get errorBadGateway => 'Gateway အမှားဖြစ်ပွားနေပါသည်။';

  @override
  String get errorServiceUnavailable => 'ဝန်ဆောင်မှုကို ယာယီအသုံးမပြုနိုင်ပါ။';

  @override
  String get errorGatewayTimeout => 'Gateway အချိန်ကျော်လွန်သွားပါသည်။';

  @override
  String get errorNotImplemented => 'ဤလုပ်ဆောင်ချက်ကို မထည့်သွင်းရသေးပါ။';

  @override
  String get errorDataParsing => 'ဆာဗာမှ ဒေတာကို ဖတ်ရှု၍ မရပါ။';

  @override
  String get errorInvalidResponse => 'ဆာဗာမှ ပြန်လာသော ဒေတာ မမှန်ကန်ပါ။';

  @override
  String get errorEmptyResponse => 'ဒေတာ မရှိပါ။';

  @override
  String get errorCache => 'သိမ်းဆည်းထားသော ဒေတာကို ဖတ်ရှု၍ မရပါ။';

  @override
  String get errorSecureStorage =>
      'လုံခြုံသော သိမ်းဆည်းမှု အမှားဖြစ်ပွားပါသည်။';

  @override
  String get errorDatabase => 'ဒေတာဘေ့စ် လုပ်ဆောင်မှု မအောင်မြင်ပါ။';

  @override
  String get errorPermission => 'ခွင့်ပြုချက် မရှိပါ။';

  @override
  String get errorTokenExpired => 'သင့် Session သက်တမ်းကုန်သွားပါပြီ။';

  @override
  String get errorMaintenance => 'စနစ်ကို ပြုပြင်ထိန်းသိမ်းနေပါသည်။';
}
