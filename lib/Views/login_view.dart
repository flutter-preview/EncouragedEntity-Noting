// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:noting/constants/routes.dart';
import 'package:noting/widgets/all_widgets.dart';
import '../constants/colors.dart';
import '../main.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void handleLogin() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    try {
      if (email.isEmpty) {
        throw FirebaseAuthException(
          code: 'empty-email',
          message: 'Email cannot be empty',
        );
      }

      if (password.isEmpty) {
        throw FirebaseAuthException(
          code: 'empty-password',
          message: 'Password cannot be empty',
        );
      }

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoutes.notes,
                      (route) => false,
                    );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'empty-email') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Email cannot be empty"),
          ),
        );
      } else if (e.code == 'empty-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Password cannot be empty"),
          ),
        );
      } else if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text("There is no user with that email. Try to create one"),
          ),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Wrong password. Try again."),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Container(
        color: AppColors.background,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: ListView(
            children: [
              const SizedBox(height: 24),
              TextFormField(
                controller: _emailController,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.visiblePassword,
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              FormButton(
                  text: "Login", isSecondary: false, onPressed: handleLogin),
              const SizedBox(height: 8),
              FormButton(
                isSecondary: true,
                text: "Create new account",
                onPressed: () async {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutes.register,
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
