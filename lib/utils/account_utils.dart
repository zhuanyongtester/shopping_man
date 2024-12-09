
import 'package:flustars/flustars.dart';

import '../common/constant.dart';
import '../model/login_user.dart';

class AccountUtils {
  static User ?mUser;

  static bool? isLogin() {
    var token = SpUtil.getString(Constant.token, defValue: "");
    return token?.isNotEmpty;
  }

  static void saveUser(LoginUser user) {
    SpUtil.putObject(Constant.login_user, user);
  }

  static User getUser() {
    mUser ??= SpUtil.getObj(Constant.login_user, (v) => LoginUser.fromJson(v as Map<String, dynamic>))?.user;
    return mUser!;
  }
}
