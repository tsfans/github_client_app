import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:github_client_app/common/global.dart';
import 'package:github_client_app/states/theme_model.dart';
import 'package:provider/provider.dart';

class ThemeChangeRoute extends StatelessWidget {
  const ThemeChangeRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(
      builder: (ctx, theme, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context).theme),
          ),
          body: ListView(
            children: Global.themes.map<Widget>((e) {
              return GestureDetector(
                child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                    child: Stack(children: [
                      Container(
                        color: e,
                        height: 40,
                      ),
                      if (theme.theme == e)
                        const Positioned(
                          top: 8,
                          right: 8,
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ])),
                onTap: () {
                  Provider.of<ThemeModel>(context, listen: false).theme = e;
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
