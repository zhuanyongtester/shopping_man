import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../common/colors.dart';
import '../../common/constant.dart';
import '../../model/login_user.dart';
import '../../route/fluro_navigator.dart';
import '../../route/routes.dart';
import '../../utils/account_utils.dart';
import '../../utils/repository_utils.dart';
import '../../utils/toast_utils.dart';
import '../../utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var leftRightPadding = 30.0;
  var topBottomPadding = 4.0;

  var _userPassController = new TextEditingController();
  var _userNameController = new TextEditingController();
  bool _agreeToTerms = false;
  bool _agreeToPrivacyPolicy = false;
  bool _isPasswordVisible = false;
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;
  bool _isAccountValid = true; // 账号验证标志
  String _accountValidationMessage = ''; // 账号验证提示信息
  String _passwordErrorMessage = ''; // 密码错误信息


  void _checkAccountExists(String account) {
    // 账号为空时不进行勾选标志显示
    if (account.isEmpty) {
      setState(() {
        _isAccountValid = false;
        _accountValidationMessage = AppLocalizations.of(context)!.fg_account_msg; // 账号为空提示
      });
      return;
    }

    // 模拟账号检查
    bool accountExists = _mockAccountCheck(account);

    setState(() {
      _isAccountValid = accountExists; // 账号是否存在
      _accountValidationMessage = accountExists
          ? ''
          : AppLocalizations.of(context)!.fg_account_not_exists;
    });
  }

  bool _mockAccountCheck(String account) {
    List<String> existingAccounts = ["example@example.com", "1234567890"];
    return existingAccounts.contains(account);
  }


  @override
  void initState() {
    super.initState();
    _loadSavedAccount();  // 加载已保存的账号
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }
  @override
  void dispose() {
    _userNameController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // 加载已保存的账号信息
  _loadSavedAccount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedUsername = prefs.getString('username');
    if (savedUsername != null) {
      _userNameController.text = savedUsername; // 恢复账号
    }
  }

  // 保存账号信息
  _saveAccount(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', username); // 保存账号
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text(
          AppLocalizations.of(context)!.lg_title,
          style: const TextStyle(fontSize: 16.0, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: leftRightPadding),
          child: Column(
            children: <Widget>[
              // Logo
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Image.asset(
                  Utils.getImgPath("ic_logo"),
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                ),
              ),
              // Subtitle
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  AppLocalizations.of(context)!.lg_top_title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: colorA8ACBC,
                  ),
                ),
              ),
              // Username field
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: TextField(
                  controller: _userNameController,
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    labelText: "Account",
                    hintText: AppLocalizations.of(context)!.lg_account_hit,
                    hintStyle: const TextStyle(fontSize: 16, color: colorA8ACBC),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.auto, // 默认自动浮动
                  ),

                  onChanged: (value) {
                    _saveAccount(value);
                  },
                ),
              ),
              // Password field with visibility toggle
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: TextField(
                  controller: _userPassController,
                  obscureText: !_isPasswordVisible,

                  decoration: InputDecoration(
                    labelText: "PassWord",
                    hintText: AppLocalizations.of(context)!.lg_password,
                    hintStyle: const TextStyle(fontSize: 16, color: colorA8ACBC),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.auto, // 默认自动浮动

                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: colorA8ACBC,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
              ),
              // Terms checkbox
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  children: <Widget>[
                    Checkbox(
                      value: _agreeToTerms,
                      onChanged: (value) {
                        setState(() {
                          _agreeToTerms = value!;
                        });
                      },
                    ),
                    Text(
                      AppLocalizations.of(context)!.lg_remember_me,
                      style: const TextStyle(fontSize: 14, color: color373D52),
                    ),
                  ],
                ),
              ),
              // Privacy policy checkbox
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  children: <Widget>[
                    Checkbox(
                      value: _agreeToPrivacyPolicy,
                      onChanged: (value) {
                        setState(() {
                          _agreeToPrivacyPolicy = value!;
                        });
                      },
                    ),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(fontSize: 14, color: color373D52),
                        children: <TextSpan>[
                          TextSpan(text: AppLocalizations.of(context)!.lg_privacy_agree),
                          TextSpan(
                            text: AppLocalizations.of(context)!.lg_privacy_network,
                            style: const TextStyle(color: pwColor),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                NavigatorUtils.push(context, Routes.privacy, replace: false);
                              },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Login button
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _agreeToPrivacyPolicy ? mainColor : Colors.grey,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: _agreeToPrivacyPolicy ? login : null,
                  child: Text(
                    AppLocalizations.of(context)!.lg_sign_in,
                    style: const TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                ),
              ),
              // Forgot password and register
              Padding(
                padding: const EdgeInsets.only(top: 150),
                child: Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        NavigatorUtils.push(context, Routes.forgotPassword, replace: false);
                      },
                      child: Text(
                        AppLocalizations.of(context)!.lg_forgot_password,
                        style: const TextStyle(color: pwColor, fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 10),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(fontSize: 14, color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(text: AppLocalizations.of(context)!.lg_register_des),
                          TextSpan(
                            text: AppLocalizations.of(context)!.lg_start_register,
                            style: const TextStyle(color: pwColor),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                NavigatorUtils.push(context, Routes.register, replace: false);
                              },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void login() async {
    if (_userNameController.text.isEmpty || _userPassController.text.isEmpty) {
      ToastUtils.showToast(context, AppLocalizations.of(context)!.lg_input_noted,duration: 0, gravity: ToastGravity.CENTER);
      return;
    }
    Repository.loadAsset("login_user", fileDir: "user").then((json) async {
      LoginUser loginUser = LoginUser.fromJson(Repository.toMap(json));
      await SpUtil.getInstance();
      AccountUtils.saveUser(loginUser);
      SpUtil.putString(Constant.token, loginUser.token);
      SpUtil.putString(Constant.user_key, loginUser.user.userKey);
      if (loginUser != null && loginUser.token.isNotEmpty) {

        NavigatorUtils.push(context, Routes.root, replace: true);
      }
    });
  }

}
