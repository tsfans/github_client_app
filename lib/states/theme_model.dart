import 'package:flutter/material.dart';
import 'package:github_client_app/common/global.dart';
import 'package:github_client_app/states/profile_change_notifier.dart';

class ThemeModel extends ProfileChangeNotifier {
  // get current theme, default to BLUE
  MaterialColor get theme =>
      Global.themes.firstWhere((element) => element.value == profile.theme,
          orElse: () => Colors.blue);
  // set current theme and notify listeners
  set theme(ColorSwatch color) {
    if (color != theme) {
      profile.theme = color[500]!.value;
      notifyListeners();
    }
  }
}
