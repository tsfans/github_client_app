import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:github_client_app/common/github.dart';
import 'package:github_client_app/common/global.dart';
import 'package:github_client_app/models/user.dart';
import 'package:github_client_app/states/user_model.dart';
import 'package:provider/provider.dart';

class LoginRoute extends StatefulWidget {
  const LoginRoute({super.key});

  @override
  State<LoginRoute> createState() => _LoginRouteState();
}

class _LoginRouteState extends State<LoginRoute> {
  final TextEditingController _unameController = TextEditingController();
  final TextEditingController _pswController = TextEditingController();
  bool _isShowPwd = false;
  bool _nameAutoFocus = true;
  final GlobalKey _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _unameController.text = Global.profile.lastLogin ?? "";
    if (_unameController.text.isNotEmpty) {
      _nameAutoFocus = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var appLoc = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(appLoc.login),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              TextFormField(
                autofocus: _nameAutoFocus,
                controller: _unameController,
                decoration: InputDecoration(
                  labelText: appLoc.username,
                  hintText: appLoc.username,
                  prefixIcon: const Icon(Icons.person),
                ),
                validator: (val) {
                  return val == null || val.trim().isNotEmpty
                      ? null
                      : appLoc.usernameRequired;
                },
              ),
              TextFormField(
                autofocus: !_nameAutoFocus,
                controller: _pswController,
                decoration: InputDecoration(
                  labelText: appLoc.password,
                  hintText: appLoc.password,
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                        _isShowPwd ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _isShowPwd = !_isShowPwd;
                      });
                    },
                  ),
                ),
                obscureText: !_isShowPwd,
                validator: (val) {
                  return val == null || val.trim().isNotEmpty
                      ? null
                      : appLoc.passwordRequired;
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints.expand(height: 55.0),
                  child: ElevatedButton(
                    onPressed: _onlogin,
                    child: Text(appLoc.login),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _onlogin() async {
    if ((_formKey.currentState as FormState).validate()) {
      showLoginLoading(context);
      User? user;
      try {
        user = await Github(context)
            .login(_unameController.text, _pswController.text);
        Provider.of<UserModel>(context, listen: false).user = user;
      } on DioException catch (e) {
        if (e.response?.statusCode == 401) {
          showToast(AppLocalizations.of(context).usernameOrPasswordWrong);
        } else {
          showToast(e.toString());
        }
      } finally {
        Navigator.of(context).pop();
      }

      if (user != null) {
        Navigator.of(context).pop();
      }
    }
  }

  void showLoginLoading(BuildContext context, [String? text]) {
    text = text ?? "Loading...";
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          return Center(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(3.0),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 10.0)
                  ]),
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              constraints: const BoxConstraints(minHeight: 120, minWidth: 180),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Text(
                      text!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  void showToast(String text) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey[600],
        fontSize: 16.0);
  }
}
