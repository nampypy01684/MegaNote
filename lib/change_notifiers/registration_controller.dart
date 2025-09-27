import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:note_app/core/dialogs.dart';
import 'package:note_app/services/auth_service.dart';

import '../core/constants.dart';

class RegistrationController extends ChangeNotifier {
  bool _isRegisterMode = true;

  bool get isRegisterMode => _isRegisterMode;

  set isRegisterMode(bool value) {
    _isRegisterMode = value;
    notifyListeners();
  }

  bool _isPasswordVisible = true;

  bool get isPasswordVisible => _isPasswordVisible;

  set isPasswordVisible(bool value) {
    _isPasswordVisible = value;
    notifyListeners();
  }

  String _fullName = '';

  set fullName(String value) {
    _fullName = value;
    notifyListeners();
  }

  String get fullName => _fullName.trim();

  String _email = '';

  set email(String value) {
    _email = value;
    notifyListeners();
  }

  String get email => _email.trim();

  String _password = '';

  set password(String value) {
    _password = value;
    notifyListeners();
  }

  String get password => _password;

  bool _isLoadings = false;

  bool get isLoadings => _isLoadings;

  set isLoadings(bool value) {
    _isLoadings = value;
    notifyListeners();
  }

  Future<void> authenticateWithEmailAndPassword({
    required BuildContext context,
  }) async {
    isLoadings = true;
    try {
      if (_isRegisterMode) {
        await AuthService.register(
          fullName: fullName,
          email: email,
          password: password,
        );

        if (!context.mounted) return;
        showMessageDialog(
          context: context,
          message:
              'Thư xác thực đã được gửi đến địa chỉ email của bạn. Hãy xác nhận để truy cập ứng dụng.',
        );
        while (!AuthService.isEmailVerified) {
          await Future.delayed(
            const Duration(seconds: 5),
            () => AuthService.user?.reload(),
          );
        }
      } else {
        // Dang nhap
        await AuthService.login(email: email, password: password);
      }
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) return;
      showMessageDialog(
        context: context,
        message: authExceptionMapper[e.code] ?? 'Lỗi không xác định',
      );
    } catch (e) {
      if (!context.mounted) return;
      showMessageDialog(context: context, message: 'Lỗi không xác định');
    } finally {
      isLoadings = false;
    }
  }

  Future<void> authenticateWithGoogle({required BuildContext context}) async {
    try {
      await AuthService.signInWithGoogle();
    } on NoGoogleAccountException {
      return;
    } catch (e) {
      if (!context.mounted) return;
      showMessageDialog(context: context, message: 'Lỗi không xác định');
    }
  }

  Future<void> resetPassword({
    required BuildContext context,
    required String email,
  }) async {
    isLoadings = true;
    try {
      await AuthService.resetPassword(email: email);
      if(!context.mounted) return;
      showMessageDialog(
        context: context,
        message:
            'Liên kết khôi phục mật khẩu đã được gửi.Vui lòng kiểm tra email $email. Nhấn mở liên kết để khôi phục mật khẩu của bạn',
      );
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) return;
      showMessageDialog(
        context: context,
        message: authExceptionMapper[e.code] ?? 'Lỗi không xác định',
      );
    } catch (e) {
      if (!context.mounted) return;
      showMessageDialog(context: context, message: 'Lỗi không xác định');
    } finally {
      isLoadings = false;
    }
  }
}

class NoGoogleAccountException implements Exception {
  const NoGoogleAccountException();
}