import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:github_client_app/states/locale_model.dart';
import 'package:provider/provider.dart';

class LanguageRoute extends StatelessWidget {
  const LanguageRoute({super.key});

  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).primaryColor;
    var locale = Provider.of<LocaleModel>(context);
    var appLoc = AppLocalizations.of(context);

    Widget buildLanguageItem(String language, String localeVal) {
      return ListTile(
        title: Text(
          language,
          style: TextStyle(color: locale.locale == localeVal ? color : null),
        ),
        trailing:
            locale.locale == localeVal ? Icon(Icons.done, color: color) : null,
        onTap: () {
          locale.locale = localeVal;
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(appLoc.language),
      ),
      body: ListView(
        children: [
          buildLanguageItem("简体中文", "zh_CN"),
          buildLanguageItem("English", "en_US"),
          buildLanguageItem(appLoc.auto, ""),
        ],
      ),
    );
  }
}
