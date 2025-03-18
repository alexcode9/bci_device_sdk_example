class ValidateUtil {
  /// Cannot contain Chinese characters or commas
  /// [value]: The string to validate
  /// Returns true if the string is valid
  static bool validateString(String value) {
    if (value.isEmpty) return false;

    final regExp = RegExp(r'([^\x00-\xff]|,)'); // Double-byte characters
    return !regExp.hasMatch(value);
  }

  /// 不能包含中文，逗号
  static bool validateWifiPwd(String text) {
    if (text.isEmpty) return false;

    /// \u4e00-\u9fa5
    final regExp = RegExp(r'([^\x00-\xff]|,)'); //双字节字符
    return !regExp.hasMatch(text);
  }
}
