import 'package:flutter/widgets.dart';
import 'package:github_client_app/states/profile_change_notifier.dart';

class LocaleModel extends ProfileChangeNotifier {
  String? get locale => profile.locale;

  set locale(String? locale) {
    if (locale != null && profile.locale != locale) {
      profile.locale = locale;
      notifyListeners();
    }
  }

  Locale? getLocale() {
    if (profile.locale == null) return null;
    var t = profile.locale!.split("_");
    if (t.length != 2) return null;
    return Locale(t[0], t[1]);
  }
}
