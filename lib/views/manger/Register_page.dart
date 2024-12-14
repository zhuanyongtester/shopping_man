import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../utils/utils.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailOrPhoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _verificationCodeController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();


  int _countdown = 0;
  bool _isSendButtonEnabled = true;
  bool _isPasswordVisible = false;
  bool _isAccountValid = true; // 账号是否有效
  bool _isPasswordValid = true; // 密码是否有效
  bool _isFormValid = false; // 整个表单是否有效
  String _accountValidationMessage = ''; // 账号验证信息
  String _passwordValidationMessage = ''; // 密码验证信息

  String _confirmPasswordValidationMessage = ''; // 确认密码验证信息
  Timer? _timer;
  void _checkAccountExists(String account) {
    if (account.isEmpty) {
      setState(() {
        _isAccountValid = false;
        _accountValidationMessage = AppLocalizations.of(context)!.rg_account_empty;
      });
      return;
    }

    // 模拟账号检查
    bool accountExists = _mockAccountCheck(account);

    setState(() {
      _isAccountValid = !accountExists;
      _accountValidationMessage = accountExists
          ? AppLocalizations.of(context)!.rg_account_exists
          : AppLocalizations.of(context)!.rg_account_available;
    });
    _updateFormValidation();
  }

  bool _mockAccountCheck(String account) {
    List<String> existingAccounts = ["example@example.com", "1234567890"];
    return existingAccounts.contains(account);
  }

  bool _isPasswordStrong(String password) {
    // 检查密码是否包含字母和数字，并且长度大于6位
    RegExp regex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{7,}$');
    return regex.hasMatch(password);
  }
  void sendVerificationCode() {
    String account = _emailOrPhoneController.text;
    if (account.isEmpty) {
      Fluttertoast.showToast(msg: AppLocalizations.of(context)!.fg_account_msg, toastLength: Toast.LENGTH_SHORT);
      return;
    }

    // 账号存在验证
    bool accountExists = _mockAccountCheck(account);
    if (accountExists) {
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
  void _updateFormValidation() {
    setState(() {
      // 检查密码是否符合要求
      _isPasswordValid = _isPasswordStrong(_passwordController.text);

      // 检查确认密码是否一致
      if (_passwordController.text != _confirmPasswordController.text) {
        _confirmPasswordValidationMessage = AppLocalizations.of(context)!.rg_password_mismatch;
      } else {
        _confirmPasswordValidationMessage = '';
      }

      // 判断表单是否有效
      _isFormValid = _isAccountValid &&
          _isPasswordValid &&
          _passwordController.text == _confirmPasswordController.text &&
          _firstNameController.text.isNotEmpty &&
          _lastNameController.text.isNotEmpty &&
          _emailOrPhoneController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _confirmPasswordController.text.isNotEmpty;
    });
  }

  Future<void> _registerUser() async {
    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;
    String emailOrPhone = _emailOrPhoneController.text;
    String password = _passwordController.text;

    if (firstName.isEmpty || lastName.isEmpty || emailOrPhone.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(msg: AppLocalizations.of(context)!.fg_content_msg, toastLength: Toast.LENGTH_SHORT);
      return;
    }

    if (password != _confirmPasswordController.text) {
      Fluttertoast.showToast(msg: AppLocalizations.of(context)!.fg_verify_pw_again, toastLength: Toast.LENGTH_SHORT);
      return;
    }

    // 模拟上传数据到云端
    await Future.delayed(Duration(seconds: 2), () {
      Fluttertoast.showToast(msg: AppLocalizations.of(context)!.fg_modify_success, toastLength: Toast.LENGTH_SHORT);
      Navigator.pop(context); // 返回登录页面
    });
  }


  bool _isPasswordValidFunc(String password) {
    RegExp passwordRegExp = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$');
    return passwordRegExp.hasMatch(password);
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
        _passwordValidationMessage = AppLocalizations.of(context)!.fg_invalid_password;
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
          AppLocalizations.of(context)!.rg_title,
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
                  AppLocalizations.of(context)!.rg_top_title,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ),
              SizedBox(height: 20),

              // 名字输入框
              TextField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.rg_first_name,
                  border: OutlineInputBorder(),
                ),
                onChanged: (text) {
                  _updateFormValidation();
                },
              ),
              SizedBox(height: 20),

              // 姓氏输入框
              TextField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.rg_last_name,
                  border: OutlineInputBorder(),
                ),
                onChanged: (text) {
                  _updateFormValidation();
                },
              ),
              SizedBox(height: 20),

              // 账号输入框
              TextField(
                controller: _emailOrPhoneController,
                keyboardType: TextInputType.emailAddress,
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
                  if (_emailOrPhoneController.text.isEmpty) {
                    setState(() {
                      _isAccountValid = false;
                      _accountValidationMessage = AppLocalizations.of(context)!.rg_account_empty;
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
              // 密码输入框
              TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.fg_new_pw,
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  errorText: _isPasswordValid
                      ? null
                      : AppLocalizations.of(context)!.rg_password_invalid, // 显示密码错误信息
                ),
                onChanged: (text) {
                  _updateFormValidation();
                },
                onEditingComplete: () {
                  if (_passwordController.text.isEmpty) {
                    setState(() {
                      _isPasswordValid = false;
                      _passwordValidationMessage = AppLocalizations.of(context)!.fg_account_msg;
                    });
                  }
                },
              ),
              // 密码规则提示
              if (!_isPasswordValid)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Align(
                    alignment: Alignment.centerLeft, // 设置左对齐
                    child: Text(
                      AppLocalizations.of(context)!.rg_password_rules, // 自定义的密码规则提示
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 20),

              // 确认密码输入框
              TextField(
                controller: _confirmPasswordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.fg_new_pw_again,
                  border: OutlineInputBorder(),
                  errorText: _confirmPasswordController.text != _passwordController.text
                      ? _confirmPasswordValidationMessage
                      : null, // 显示密码不匹配错误信息
                ),
                onChanged: (text) {
                  _updateFormValidation();
                },
                onEditingComplete: () {
                  if (_confirmPasswordController.text.isEmpty) {
                    setState(() {
                      _confirmPasswordValidationMessage = AppLocalizations.of(context)!.fg_verify_pw_again;
                    });
                  }
                },
              ),
              SizedBox(height: 20),

              // 底部按钮
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isFormValid ? _registerUser : null, // 只有表单有效时才能点击
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.rg_register_submit,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // 返回登录页面
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.fg_back,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
