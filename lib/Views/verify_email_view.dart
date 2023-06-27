import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
            const Text('We\'ve sent you verification letter on your email.'),
            const Text('If you haven\'t recieved your verification letter, please press the button below'),
            FormButton(
              text: 'Verify',
              isSecondary: false,
              onPressed: () async {
                final currentUser = FirebaseAuth.instance.currentUser;
                try {
                  await currentUser?.sendEmailVerification();
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoutes.login,
                      (route) => false,
                    );
                  }
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
