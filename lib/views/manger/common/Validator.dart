class Validator {
  /// 验证邮箱格式
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return "邮箱不能为空";
    }
    // 正则表达式验证邮箱格式
    const emailPattern =
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    final regex = RegExp(emailPattern);
    if (!regex.hasMatch(email)) {
      return "请输入有效的邮箱地址";
    }
    return null;
  }

  /// 验证手机号格式
  static String? validatePhone(String? phone) {
    if (phone == null || phone.isEmpty) {
      return "手机号不能为空";
    }
    // 正则表达式验证手机号格式（中国手机号码示例）
    const phonePattern = r'^[1][3-9][0-9]{9}$';
    final regex = RegExp(phonePattern);
    if (!regex.hasMatch(phone)) {
      return "请输入有效的手机号码";
    }
    return null;
  }
  /// 验证登录 ID（Email 或 Phone）
  static String? validateLoginID(String? loginID, String loginType) {
    if (loginID == null || loginID.isEmpty) {
      return "不能为空";
    }
    if (loginType == "email") {
      const emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
      final regex = RegExp(emailPattern);
      if (!regex.hasMatch(loginID)) {
        return "请输入有效的邮箱地址";
      }
    } else if (loginType == "phone") {
      const phonePattern = r'^[1][3-9][0-9]{9}$'; // 中国手机号示例
      final regex = RegExp(phonePattern);
      if (!regex.hasMatch(loginID)) {
        return "请输入有效的手机号码";
      }
    }
    return null;
  }

  /// 验证密码强度（长度、至少一个大写字母和一个数字）
  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return "密码不能为空";
    }
    if (password.length < 8) {
      return "密码长度不能少于8位";
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return "密码必须包含至少一个大写字母";
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      return "密码必须包含至少一个数字";
    }
    return null;
  }

  /// 验证确认密码
  static String? validateConfirmPassword(String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return "确认密码不能为空";
    }
    if (confirmPassword != password) {
      return "两次输入的密码不一致";
    }
    return null;
  }

  /// 验证必填字段
  static String? validateRequiredField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return "$fieldName 不能为空";
    }
    return null;
  }
  static List<String> checkPasswordStrength(String password) {
    List<String> rules = [];
    if (password.isEmpty) {
      rules.add("密码不能为空");
    }
    if (password.length < 8) {
      rules.add("密码长度至少8个字符");
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      rules.add("密码必须包含至少1个大写字母");
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      rules.add("密码必须包含至少1个数字");
    }
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      rules.add("密码必须包含至少1个特殊字符");
    }

    return rules;
  }

  // 验证单个字段方法
  String? validateField(String value, String fieldName, {bool isNotEmpty = false, String? Function(String?)? validateFunction}) {
    if (isNotEmpty && value.isEmpty) {
      return "$fieldName不能为空";
    }
    if (validateFunction != null) {
      return validateFunction(value);
    }
    return null;
  }

}
