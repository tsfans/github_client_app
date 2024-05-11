import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'messages_all.dart';

class AppLocalizations {
  static Future<AppLocalizations> load(Locale locale) {
    final String name =
        locale.countryCode != null && locale.countryCode!.isEmpty
            ? locale.languageCode
            : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return AppLocalizations();
    });
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  String get title {
    return Intl.message("GitHub Client",
        locale: "en_US", name: "title", desc: "app title");
  }

  String get home {
    return Intl.message("App Home",
        locale: "en_US", name: "home", desc: "app home");
  }

  String get login {
    return Intl.message("login", locale: "en_US", name: "login", desc: "login");
  }

  String get noRepo {
    return Intl.message("no more reository",
        locale: "en_US", name: "noRepo", desc: "no more reository");
  }

  String get noRepoDesc {
    return Intl.message("no description",
        locale: "en_US", name: "noRepoDesc", desc: "no description");
  }

  String get theme {
    return Intl.message("theme", locale: "en_US", name: "theme", desc: "theme");
  }

  String get language {
    return Intl.message("language",
        locale: "en_US", name: "language", desc: "language");
  }

  String get logout {
    return Intl.message("logout",
        locale: "en_US", name: "logout", desc: "logout");
  }

  String get logoutTip {
    return Intl.message("logoutTip",
        locale: "en_US", name: "logoutTip", desc: "logoutTip");
  }

  String get cancel {
    return Intl.message("cancel",
        locale: "en_US", name: "cancel", desc: "cancel");
  }

  String get yes {
    return Intl.message("yes", locale: "en_US", name: "yes", desc: "yes");
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ["zh", "en"].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return AppLocalizations.load(locale);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}
