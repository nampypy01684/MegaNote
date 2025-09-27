class Validator {
  Validator._();

  static String? nameValidator(String? name) {
    final n = name?.trim() ?? '';
    return n.isEmpty ? 'Vui lòng nhập tên' : null;
  }


  static const String _emailPattern =
      r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$';


  static final RegExp _emailRegExp = RegExp(_emailPattern);

  static String? emailValidator(String? email) {
    final e = email?.trim() ?? '';
    if (e.isEmpty) return 'Vui lòng nhập email';
    if (!_emailRegExp.hasMatch(e)) return 'Email không hợp lệ!';
    return null;
  }

  static String? passwordValidator(String? password) {
    final p = password ?? '';

    String errorMessage = '';
    if (p.isEmpty) {
      errorMessage = 'Vui lòng nhập mật khẩu';
    } else {
      if (p.length < 6) {
        errorMessage = 'Mật khẩu phải có ít nhất 6 ký tự';
      }
      if (!p.contains(RegExp(r'[a-z]'))) {
        errorMessage = '$errorMessage\nMật khẩu phải có ít nhất 1 chữ cái thường';
      }
      if (!p.contains(RegExp(r'[A-Z]'))) {
        errorMessage = '$errorMessage\nMật khẩu phải có ít nhất 1 chữ cái in hoa';
      }
      if (!p.contains(RegExp(r'[0-9]'))) {
        errorMessage = '$errorMessage\nMật khẩu phải có ít nhất 1 số';
      }
      // return p.isEmpty ? 'Vui lòng nhập mật khẩu' : null;
    }
    return errorMessage.isNotEmpty ? errorMessage.trim() : null;
  }
}
