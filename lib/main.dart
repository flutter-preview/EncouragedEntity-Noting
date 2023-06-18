// ignore_for_file: prefer_const_constructors, avoid_printRegisterView
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:noting/constants/colors.dart';
import 'package:noting/widgets/form_button.dart';
import 'Views/all_views.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Color primaryColor = AppColors.primary;
  MaterialColor customPrimarySwatch = MaterialColor(
    primaryColor.value,
    <int, Color>{
      50: primaryColor.withOpacity(0.1),
      100: primaryColor.withOpacity(0.2),
      200: primaryColor.withOpacity(0.3),
      300: primaryColor.withOpacity(0.4),
      400: primaryColor.withOpacity(0.5),
      500: primaryColor.withOpacity(0.6),
      600: primaryColor.withOpacity(0.7),
      700: primaryColor.withOpacity(0.8),
      800: primaryColor.withOpacity(0.9),
      900: primaryColor.withOpacity(1.0),
    },
  );

  runApp(MaterialApp(
    title: 'Noting',
    theme: ThemeData(
      primarySwatch: customPrimarySwatch,
    ),
    home: const HomePage(),
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              // final currentUser = FirebaseAuth.instance.currentUser;
              // final emailVerified = currentUser?.emailVerified ?? false;
              // if (emailVerified) {
              //   return const Text('Connected');
              // } else {
              //    return const VerifyEmailView();
              // }
              return const LoginView();
            default:
              return const Text('Not connected');
          }
        },
      ),
    );
  }
}

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Text('Please, verify your email!'),
          FormButton(
            text: 'Verify',
            isSecondary: false,
            onPressed: () async {
              final currentUser = FirebaseAuth.instance.currentUser;
              await currentUser?.sendEmailVerification();
            },
          )
        ],
      );
  }
}
