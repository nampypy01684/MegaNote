import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../change_notifiers/registration_controller.dart';


class AuthService {
  AuthService._();
  static final _auth = FirebaseAuth.instance;

  static User? get user => _auth.currentUser;

  static Stream<User?> get userStream => _auth.authStateChanges();
  static bool get isEmailVerified => user?.emailVerified ?? false;

  static Future<void> register({
    required String fullName,
    required String email,
    required String password,
  }) async{
    try {
      final credential = await _auth
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      ).then((credential) {
        credential.user?.sendEmailVerification();
        credential.user?.updateDisplayName(fullName);
      } );
    }catch (e) {
      rethrow;
    }
  }
  static Future<void> login({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }


  static Future<UserCredential?> signInWithGoogle() async {
    // B1: Bật Google Sign In (hiển thị chọn tài khoản)
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      throw const NoGoogleAccountException();
    }

    // Nếu người dùng bấm hủy => googleUser == null
    if (googleUser == null) {
      return null; // hoặc throw Exception('User cancelled sign-in')
    }

    // B2: Lấy thông tin xác thực
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // B3: Tạo credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // B4: Đăng nhập Firebase
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }



  static Future<void> resetPassword({required String email}) =>
      _auth.sendPasswordResetEmail(email: email);

  static Future<void> logout() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
  }
}
