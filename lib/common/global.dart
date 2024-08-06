import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:github_client_app/common/github.dart';
import 'package:github_client_app/common/net_cache.dart';
import 'package:github_client_app/models/cacheConfig.dart';
import 'package:github_client_app/models/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _themes = <MaterialColor>[
  Colors.blue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.red
];

class Global {
  static late SharedPreferences _prefs;

  // default theme is blue
  static Profile profile = Profile(theme: 0);

  // cache network data
  static NetCache netCache = NetCache();

  // availabes themes
  static List<MaterialColor> get themes => _themes;

  // is relase version
  static bool get isRelease => const bool.fromEnvironment("dart.vm.product");

  // init global params on app start
  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();
    _prefs = await SharedPreferences.getInstance();

    var existedProfile = _prefs.getString("profile");
    if (existedProfile != null) {
      try {
        profile = Profile.fromJson(jsonDecode(existedProfile));
      } catch (e) {
        print(e);
      }
    }

    // set default cache config
    profile.cache =
        profile.cache ?? CacheConfig(enable: true, maxAge: 3600, maxCount: 100);

    // init network config
    Github.init();
  }

  // persist profile data
  static saveProfile() =>
      _prefs.setString("profile", jsonEncode(profile.toJson()));
}
