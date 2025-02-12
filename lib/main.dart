// ignore_for_file: prefer_const_constructors, avoid_printRegisterView
import 'package:flutter/material.dart';
import 'package:noting/constants/colors.dart';
import 'package:noting/services/auth/auth_service.dart';
import 'package:noting/widgets/all_widgets.dart';
import 'Views/all_views.dart';
import 'constants/routes.dart';
// ignore: unused_import
import 'dart:developer' as devtools show log;

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
    routes: {
      AppRoutes.login: (context) => const LoginView(),
      AppRoutes.register: (context) => const RegisterView(),
      AppRoutes.notes: (context) => const NotesView(),
      AppRoutes.mailVerify: (context) => const VerifyEmailView(),
    },
  ));
} 

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    final authService = AuthService.firebase();

    return FutureBuilder(
      future: authService.initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = authService.currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return const NotesView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
          default:
            return SplashScreen();
        }
      },
    );
  }
}
