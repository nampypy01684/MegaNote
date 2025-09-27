import 'dart:ui';
import 'package:flutter/material.dart';

const Color primary = Color(0xFF1887C3);
const Color gray900 = Color(0xFF3E3E3E);
const Color gray700 = Color(0xFF626262);
const Color gray500 = Color(0xFF8E8E8E);
const Color gray300 = Color(0xFFBEBEBE);
const Color gray100 = Color(0xFFE9E9E9);
const Color background = Color(0xFFF1F2F6);
const Color black = Color(0xFF000000);
const Color white = Color(0xFFFFFFFF);

const Map<String, String> authExceptionMapper = {
  'email-already-in-use': 'Email này đã được sử dụng. Vui lòng dùng email khác hoặc đăng nhập!',
  'invalid-email': 'Địa chỉ email không hợp lệ!',
  'weak-password': 'Mật khẩu quá yếu. Hãy thử mật khẩu mạnh hơn!',
  'user-disabled': 'Tài khoản với email này đã bị vô hiệu hóa!',
  'user-not-found': 'Không tìm thấy tài khoản với email này!',
  'wrong-password': 'Mật khẩu không chính xác!',
  'INVALID_LOGIN_CREDENTIALS': 'Email hoặc mật khẩu không đúng!',
  'too-many-requests': 'Bạn đã thử quá nhiều lần. Vui lòng thử lại sau!',
  'network-request-failed': 'Không thể kết nối. Vui lòng kiểm tra mạng!',
  'user-mismatch': 'Thông tin đăng nhập không khớp!',
  'invalid-credential': 'Thông tin xác thực không hợp lệ!',
};
