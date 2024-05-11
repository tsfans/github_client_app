import 'package:github_client_app/models/user.dart';
import 'package:github_client_app/states/profile_change_notifier.dart';

class UserModel extends ProfileChangeNotifier {
  User? get user => profile.user;

  bool get isLogin => user != null;
  bool get unLogin => user == null;

  set user(User? user) {
    if (user?.login != profile.user?.login) {
      profile.lastLogin = profile.user?.login;
      profile.user = user;
      notifyListeners();
    }
  }
}
