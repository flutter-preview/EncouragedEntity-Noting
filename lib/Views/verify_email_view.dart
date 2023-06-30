import 'package:flutter/material.dart';
import 'package:noting/services/auth/auth_exception.dart';
import 'package:noting/services/auth/auth_service.dart';

import '../constants/routes.dart';
import '../widgets/form_button.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Email verification')),
      body: Center(
        child: Column(
          children: [
            const Text("We've sent you verification letter on your email."),
            const Text(
                "\t\tIf you haven't recieved your verification letter, please press the button below"),
            FormButton(
              text: 'Verify',
              isSecondary: false,
              onPressed: () async {
                try {
                  await AuthService.firebase().sendEmailVerification();
                } on UserNotFoundException {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoutes.login,
                      (route) => false,
                    );
                }
              },
            ),
            TextButton(
              child: const Text('Restart'),
              onPressed: () async {
                await AuthService.firebase().logOut();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.register,
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
