import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../utils/utils.dart';

class ForgotPassWordPage extends StatefulWidget {
  @override
  _ForgotPassWordPageState createState() => _ForgotPassWordPageState();
}

class _ForgotPassWordPageState extends State<ForgotPassWordPage> {
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _verificationCodeController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isSendButtonEnabled = true;
  bool _isAccountValid = true; // 账号验证标志
  String _accountValidationMessage = ''; // 账号验证提示信息
  String _passwordErrorMessage = ''; // 密码错误信息
  bool _isPasswordValid = true; // 密码是否有效
  int _countdown = 0;
  Timer? _timer;
  bool _isFormValid = false; // 表单验证标志

  final FocusNode _verificationCodeFocusNode = FocusNode();

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

  void sendVerificationCode() {
    String account = _accountController.text;
    if (account.isEmpty) {
      Fluttertoast.showToast(msg: AppLocalizations.of(context)!.fg_account_msg, toastLength: Toast.LENGTH_SHORT);
      return;
    }

    // 账号存在验证
    bool accountExists = _mockAccountCheck(account);
    if (!accountExists) {
      setState(() {
        _isAccountValid = false;
        _accountValidationMessage = AppLocalizations.of(context)!.fg_account_not_exists; // 提示账号不存在
      });
      return;
    }

    setState(() {
      _isAccountValid = true;
      _accountValidationMessage = ''; // 账号存在，不显示提示信息
      _isSendButtonEnabled = false;
      _countdown = 60;
    });

    _startCountdown();
    Fluttertoast.showToast(msg: AppLocalizations.of(context)!.fg_verify_msg, toastLength: Toast.LENGTH_SHORT);
  }

  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 1) {
          _countdown--;
        } else {
          _isSendButtonEnabled = true;
          _countdown = 0;
          timer.cancel();
        }
      });
    });
  }

  bool _isPasswordValidFunc(String password) {
    RegExp passwordRegExp = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$');
    return passwordRegExp.hasMatch(password);
  }

  void _updateFormValidation() {
    setState(() {
      _isPasswordValid = _isPasswordValidFunc(_newPasswordController.text);

      _isFormValid = _isAccountValid && _isPasswordValid && _newPasswordController.text == _confirmPasswordController.text;
    });
  }

  void verifyCodeAndSetPassword() {
    String verificationCode = _verificationCodeController.text;
    String newPassword = _newPasswordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (verificationCode.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      Fluttertoast.showToast(msg: AppLocalizations.of(context)!.fg_content_msg, toastLength: Toast.LENGTH_SHORT);
      return;
    }

    if (newPassword != confirmPassword) {
      Fluttertoast.showToast(msg: AppLocalizations.of(context)!.fg_verify_pw_again, toastLength: Toast.LENGTH_SHORT);
      return;
    }

    if (!_isPasswordValidFunc(newPassword)) {
      setState(() {
        _passwordErrorMessage = AppLocalizations.of(context)!.fg_invalid_password;
        _isPasswordValid = false;
      });
      return;
    }

    Fluttertoast.showToast(msg: AppLocalizations.of(context)!.fg_modify_success, toastLength: Toast.LENGTH_SHORT);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          AppLocalizations.of(context)!.fg_title,
          style: TextStyle(fontSize: 16.0, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Image.asset(
                  Utils.getImgPath("ic_logo"),
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  AppLocalizations.of(context)!.fg_top_title,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ),
              SizedBox(height: 20),

              // 输入账号
              TextField(
                controller: _accountController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.fg_account,
                  border: OutlineInputBorder(),
                  errorText: _isAccountValid ? null : _accountValidationMessage,
                  suffixIcon: _isAccountValid
                      ? Icon(Icons.check, color: Colors.green)
                      : Icon(Icons.error, color: Colors.red),
                ),
                onChanged: (text) {
                  _checkAccountExists(text);
                },
                onEditingComplete: () {
                  // 当账号输入框失去焦点时检查账号是否为空
                  if (_accountController.text.isEmpty) {
                    setState(() {
                      _isAccountValid = false;
                      _accountValidationMessage = AppLocalizations.of(context)!.fg_account_msg; // 账号为空提示
                    });
                  }
                },
              ),
              SizedBox(height: 20),

              // 验证码输入框和按钮
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _verificationCodeController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.fg_verify_code,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _isSendButtonEnabled ? sendVerificationCode : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isSendButtonEnabled ? Colors.teal : Colors.grey,
                    ),
                    child: Text(
                      _isSendButtonEnabled ? AppLocalizations.of(context)!.fg_send_vcdoe : "$_countdown s",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // 输入新密码
              TextField(
                controller: _newPasswordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.fg_new_pw,
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                onChanged: (password) {
                  setState(() {
                    _isPasswordValid = _isPasswordValidFunc(password);
                    _passwordErrorMessage = '';
                  });
                },
              ),
              if (!_isPasswordValid)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppLocalizations.of(context)!.rg_password_rules,
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                ),
              SizedBox(height: 20),

              // 输入确认密码
              TextField(
                controller: _confirmPasswordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.fg_verify_pw_again,
                  border: OutlineInputBorder(),
                  errorText: _newPasswordController.text != _confirmPasswordController.text
                      ? AppLocalizations.of(context)!.fg_verify_pw_again
                      : null,
                ),
                onChanged: (text) {
                  _updateFormValidation();
                },
              ),
              SizedBox(height: 20),

              // 底部按钮
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isFormValid ? verifyCodeAndSetPassword : null,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                      child: Text(AppLocalizations.of(context)!.fg_submit, style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                      child: Text(AppLocalizations.of(context)!.fg_back, style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
