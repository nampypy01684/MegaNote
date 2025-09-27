import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart' show TapGestureRecognizer;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:note_app/core/constants.dart';
import 'package:note_app/core/validator.dart';
import 'package:note_app/pages/recover_password_page.dart';
import 'package:note_app/widgets/note_button.dart';
import 'package:note_app/widgets/note_form_field.dart';

// import 'package:note_app/widgets/note_icon_button.dart';
import 'package:note_app/widgets/note_icon_button_outlined.dart';
import 'package:provider/provider.dart';

import '../change_notifiers/registration_controller.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  // Sửa lỗi: Bỏ late final và khởi tạo trực tiếp
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // late final RegistrationController registrationController;

  // @override
  // void initState() {
  //   registrationController = context.read();
  //   super.initState();
  // }
  @override
  void dispose() {
    // Dispose controllers để tránh memory leak
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();

    // registrationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final registrationController = context.watch<RegistrationController>();
    // late final RegistrationController registrationController;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: SingleChildScrollView(
              child: Selector<RegistrationController, bool>(
                selector: (_, controller) => controller.isRegisterMode,
                builder:
                    (_, isRegisterMode, __) => Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            isRegisterMode ? 'Đăng ký' : 'Đăng nhập',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 48,
                              fontFamily: 'Times New Roman',
                              fontWeight: FontWeight.w600,
                              color: primary,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Để đồng bộ ghi chú của bạn lên đám mây, bạn phải đăng ký/đăng nhập vào ứng dụng',
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 48),
                          if (isRegisterMode) ...[
                            NoteFormField(
                              controller: nameController,
                              labelText: "Họ và tên",
                              fillColor: white,
                              filled: true,
                              textCapitalization: TextCapitalization.sentences,
                              textInputAction: TextInputAction.next,
                              validator: Validator.nameValidator,
                              onChanged: (newValue) {
                                registrationController.fullName = newValue;
                              },
                            ),
                            SizedBox(height: 8),
                          ],
                          NoteFormField(
                            controller: emailController,
                            labelText: "Email",
                            fillColor: white,
                            filled: true,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            validator: Validator.emailValidator,
                            onChanged: (newValue) {
                              registrationController.email = newValue;
                            },
                          ),
                          SizedBox(height: 8),
                          Selector<RegistrationController, bool>(
                            selector:
                                (_, controller) => controller.isPasswordVisible,
                            builder:
                                (_, isPasswordVisible, __) => NoteFormField(
                                  controller: passwordController,
                                  labelText: "Mật khẩu",
                                  fillColor: white,
                                  filled: true,
                                  obscureText: isPasswordVisible,
                                  textInputAction: TextInputAction.done,
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      context
                                              .read<RegistrationController>()
                                              .isPasswordVisible =
                                          !isPasswordVisible;
                                    },
                                    child: Icon(
                                      isPasswordVisible
                                          ? FontAwesomeIcons.eye
                                          : FontAwesomeIcons.eyeSlash,
                                    ),
                                  ),
                                  validator: Validator.passwordValidator,
                                  onChanged: (newValue) {
                                    registrationController.password = newValue;
                                  },
                                ),
                          ),
                          SizedBox(height: 12),
                          if (!isRegisterMode) ...[
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => RecoverPasswordPage(),
                                  ),
                                );
                              },
                              child: Text(
                                'Quên mật khẩu?',
                                style: TextStyle(
                                  color: primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 24),
                          ],
                          SizedBox(
                            height: 48,
                            child: Selector<RegistrationController, bool>(
                              selector:
                                  (_, controller) => controller.isLoadings,
                              builder:
                                  (_, isLoadings, __) => NoteButton(
                                    onPressed:
                                        isLoadings
                                            ? null
                                            : () {
                                              if (formKey.currentState
                                                      ?.validate() ??
                                                  false) {
                                                registrationController
                                                    .authenticateWithEmailAndPassword(
                                                      context: context,
                                                    );
                                              }
                                              if (isRegisterMode) {
                                                // Register logic
                                                print(
                                                  'Name: ${nameController.text}',
                                                );
                                                print(
                                                  'Email: ${emailController.text}',
                                                );
                                                print(
                                                  'Password: ${passwordController.text}',
                                                );
                                              } else {
                                                // Login logic
                                                print(
                                                  'Email: ${emailController.text}',
                                                );
                                                print(
                                                  'Password: ${passwordController.text}',
                                                );
                                              }
                                            },
                                    child:
                                        isLoadings
                                            ? SizedBox(
                                              width: 24,
                                              height: 24,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                              ),
                                            )
                                            : Text(
                                              isRegisterMode
                                                  ? 'Đăng ký'
                                                  : 'Đăng nhập',
                                            ),
                                  ),
                            ),
                          ),
                          SizedBox(height: 32),
                          Row(
                            children: [
                              Expanded(child: Divider()),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                ),
                                child: Text(
                                  isRegisterMode
                                      ? 'Hoặc đăng ký với'
                                      : 'Hoặc đăng nhập với',
                                ),
                              ),
                              Expanded(child: Divider()),
                            ],
                          ),
                          SizedBox(height: 32),
                          Row(
                            children: [
                              Expanded(
                                child: NoteIconButtonOutlined(
                                  icon: FontAwesomeIcons.google,
                                  onPressed: () {
                                    registrationController
                                        .authenticateWithGoogle(
                                      context: context,
                                    );
                                  },
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: NoteIconButtonOutlined(
                                  icon: FontAwesomeIcons.facebook,
                                  onPressed: () {
                                    // TODO: Implement Facebook sign in
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 32),
                          Text.rich(
                            TextSpan(
                              text:
                                  isRegisterMode
                                      ? 'Đã có tài khoản? '
                                      : 'Chưa có tài khoản? ',
                              style: TextStyle(color: gray700),
                              children: [
                                TextSpan(
                                  text:
                                      isRegisterMode ? 'Đăng nhập' : 'Đăng ký',
                                  style: TextStyle(
                                    color: primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  recognizer:
                                      TapGestureRecognizer()
                                        ..onTap = () {
                                          context
                                              .read<RegistrationController>()
                                              .isRegisterMode = !isRegisterMode;
                                        },
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
