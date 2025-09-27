import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/widgets/note_back_button.dart';
import 'package:note_app/widgets/note_button.dart';
import 'package:note_app/widgets/note_form_field.dart';
import 'package:provider/provider.dart';

import '../change_notifiers/registration_controller.dart';
import '../core/validator.dart';

class RecoverPasswordPage extends StatefulWidget {
  const RecoverPasswordPage({super.key});

  @override
  State<RecoverPasswordPage> createState() => _RecoverPasswordPageState();
}

class _RecoverPasswordPageState extends State<RecoverPasswordPage> {
  late final TextEditingController emailController;

  GlobalKey<FormFieldState> emailKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: NoteBackButton(), title: Text('Quên mật khẩu')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Đừng quên mật khẩu nữa nhé <3',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              NoteFormField(
                controller: emailController,
                key: emailKey,
                fillColor: Colors.white,
                filled: true,
                labelText: 'Email',
                validator: Validator.emailValidator,
              ),
              SizedBox(height: 24),
              SizedBox(
                height: 48,
                child: Selector<RegistrationController, bool>(
                  selector: (_, controller) => controller.isLoadings,
                  builder:
                      (_, isLoadings, __) => NoteButton(
                        onPressed: isLoadings ? null :() {
                          if (emailKey.currentState?.validate() ?? false) {
                            context
                                .read<RegistrationController>()
                                .resetPassword(
                                  context: context,
                                  email: emailController.text.trim(),
                                );
                          }
                        },
                        child:
                            isLoadings
                                ? SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(color: Colors.white,))
                                : Text('Gửi liên kết quên mật khẩu!'),
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
