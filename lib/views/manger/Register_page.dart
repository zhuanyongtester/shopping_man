import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../utils/utils.dart';
import 'common/Validator.dart';
class RegisterPage extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterPage> {

  TextEditingController loginIdController = TextEditingController(); //登录ID
  TextEditingController firstNameController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController verificationCodeController = TextEditingController();

  String loginType = 'email'; // 切换 email 和 phone
  String selectedGender = 'male'; // 性别下拉框
  DateTime? selectedBirthday; // 存储生日
  int age = 0; // 自动计算的年龄
  String locationMessage = "当前位置未获取";
  bool _isSendButtonEnabled = true; // 按钮状态：true 为可点击，false 为不可点击
  int _countdown = 60; // 倒计时秒数
  Timer? timer; // 定时器
  String confirmPasswordError = ""; // 确认密码错误提示
  // 添加在类中 (State)
  bool isPasswordVisible = false; // 控制密码可见状态
  List<String> passwordErrors = []; // 记录密码不符合的规则
  String loginIdValidationStatus = ""; // 用于展示验证结果
  Map<String, String> formErrors = {}; // 表单错误提示
  bool _isAccountValid = true; // 账号验证标志
// 切换密码可见状态
  void _togglePasswordVisibility() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }
  // 发送验证码并启动倒计时
  void sendVerificationCode() {
    setState(() {
      _isSendButtonEnabled = false; // 禁用按钮
      _countdown = 60; // 重置倒计时
    });

    // 启动倒计时
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--; // 倒计时减 1
        } else {
          timer.cancel(); // 倒计时结束，停止定时器
          _isSendButtonEnabled = true; // 重新启用按钮
        }
      });
    });

    // 模拟发送验证码到后台（此处替换为实际的 API 调用）
    print("发送验证码请求...");
  }

  @override
  void dispose() {
    // 页面销毁时清理定时器
    timer?.cancel();
    verificationCodeController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); // 获取当前位置
  }

  // 获取当前位置
  void _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      // 反向地理编码，获取地理位置名称
      List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);

      Placemark place = placemarks[0]; // 获取第一个地理位置
      String address =
          "${place.locality ?? ""}, ${place.administrativeArea ?? ""}, ${place.country ?? ""}";
      setState(() {
        locationController.text = address; // 更新输入框内容
        locationMessage = address;
      });
    } catch (e) {
      print("获取位置失败: $e");
      setState(() {
        locationMessage = "获取位置失败，请检查权限或网络连接";
      });
    }
  }

  // 选择生日并计算年龄
  void _selectBirthday() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        selectedBirthday = pickedDate;
        birthdayController.text = "${pickedDate.toLocal()}".split(' ')[0];
        age = DateTime.now().year - pickedDate.year; // 计算年龄
      });
    }
  }

  // 切换 Email 和 Phone 输入框
  void _toggleLoginType() {
    setState(() {
      loginType = loginType == 'email' ? 'phone' : 'email';
      loginIdController.clear();
    });
  }
  // 实时检查密码强度
  void _checkPasswordStrength(String password) {
    setState(() {
      passwordErrors = Validator.checkPasswordStrength(password); // 调用验证类
    });
  }

  // 验证确认密码
  void _validateConfirmPassword(String confirmPassword) {
    setState(() {
      confirmPasswordError  = Validator.validateConfirmPassword(passwordController.text, confirmPassword) ?? "";
    });
  }
// 验证登录 ID
  void _validateLoginId(String value) {
    setState(() {
      loginIdValidationStatus = ""; // 清空验证结果提示
      String? loginError = Validator.validateLoginID(value, loginType);
      if (loginError != null) {
        _isAccountValid=false;
      } else {
        _isAccountValid=true;
      }
    });
  }

  // 提交表单逻辑
  void _submitForm() {
    setState(() {
      formErrors.clear(); // 清空表单错误提示
    });
    // 验证登录 ID
    if (loginIdValidationStatus.isNotEmpty) {
      _isAccountValid=false;
      setState(() {
        formErrors["loginId"] = loginIdValidationStatus; // 添加登录ID错误提示

      });
    }

    if (formErrors.isNotEmpty) {
      _showSnackbar("请修正表单错误");
      return;
    }

    // 提交成功逻辑
    print("Form is valid! Submit now.");


    print("Login Type: $loginType");
    print("Login ID: ${loginIdController.text}");
    print("First Name: ${firstNameController.text}");
    print("Gender: $selectedGender");
    print("Birthday: ${birthdayController.text}");
    print("Age: $age");
    print("Location: ${locationController.text}");
    print("Password: ${passwordController.text}");
    print("Verification Code: ${verificationCodeController.text}");
  }
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: Duration(seconds: 2)),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          "Register", // 替换为国际化标题
          style: TextStyle(fontSize: 16.0, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 20),
            Center(
              child: Image.asset(
                Utils.getImgPath("ic_logo"),
                height: 150,
                width: 150,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                AppLocalizations.of(context)!.rg_top_title,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ),
            SizedBox(height: 20),
            // Email or Phone Input Field
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: loginIdController,
                    decoration: InputDecoration(
                      labelText:
                      loginType == 'email' ? "Email" : "Phone Number",
                      prefixIcon: Icon(
                          loginType == 'email' ? Icons.email : Icons.phone),
                      border: OutlineInputBorder(),
                      errorText: formErrors["loginId"], // 显示错误提示
                      suffixIcon:loginIdController.text.isEmpty
                           ?null
                           :_isAccountValid
                          ? Icon(Icons.check, color: Colors.green)
                          : Icon(Icons.error, color: Colors.red),

                    ),
                    keyboardType: loginType == 'email'
                        ? TextInputType.emailAddress
                        : TextInputType.phone,
                    onChanged: (value) => _validateLoginId(loginIdController.text), // 验证登录 ID

                  ),
                ),
                IconButton(
                  icon: Icon(Icons.swap_horiz),
                  onPressed: _toggleLoginType,
                  tooltip: "Switch to ${loginType == 'email' ? 'Phone' : 'Email'}",
                ),
              ],
            ),
            SizedBox(height: 20),

            // Name Input
            TextField(
              controller: firstNameController,
              decoration: InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            // Gender Dropdown
            DropdownButtonFormField<String>(
              value: selectedGender,
              onChanged: (String? newValue) {
                setState(() {
                  selectedGender = newValue!;
                });
              },
              items: <String>['male', 'female', 'prefer not to say']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: "Gender",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            // Birthday Picker
            TextField(
              controller: birthdayController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: "Birthday",
                prefixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(),
              ),
              onTap: _selectBirthday,
            ),
            SizedBox(height: 20),

            // Location Input (Read-Only)
            TextField(
              controller: locationController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: "Location",
                prefixIcon: Icon(Icons.location_on),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            // Password Input
            TextField(
              controller: passwordController,
              obscureText: !isPasswordVisible, // 控制密码是否可见
              onChanged: _checkPasswordStrength, // 监听输入，实时检查规则
              decoration: InputDecoration(
                labelText:  AppLocalizations.of(context)!.fg_new_pw,
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: _togglePasswordVisibility, // 切换密码可见状态
                ),
              ),
            ),
            SizedBox(height: 10),

// 显示密码规则提示
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: passwordErrors.map((rule) {
                return Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red, size: 18),
                    SizedBox(width: 5),
                    Text(rule, style: TextStyle(color: Colors.red, fontSize: 12)),
                  ],
                );
              }).toList(),
            ),
            // Confirm Password
            TextField(
              controller: confirmPasswordController,
              onChanged: _validateConfirmPassword,
              obscureText: true,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.fg_new_pw_again,
                prefixIcon: Icon(Icons.lock_outline),
                border: OutlineInputBorder(),
                errorText: confirmPasswordError.isNotEmpty ? confirmPasswordError : null, // 显示错误提示
              ),
            ),
            SizedBox(height: 20),

            // 验证码输入框和按钮
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    controller: verificationCodeController,
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

            // Submit Button
            // 底部按钮
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _submitForm, // 只有表单有效时才能点击
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
    );
  }
}
