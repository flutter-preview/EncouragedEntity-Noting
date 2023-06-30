// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:noting/constants/routes.dart';
import 'package:noting/services/auth/auth_exception.dart';
import 'package:noting/widgets/all_widgets.dart';
import '../constants/colors.dart';
import '../services/auth/auth_service.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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

  void handleRegister() async {
    final authService = AuthService.firebase();
    final email = _emailController.text;
    final password = _passwordController.text;
    try {
      await authService.createUser(
        email: email,
        password: password,
      );
      authService.sendEmailVerification();
      Navigator.of(context).pushNamed(
        AppRoutes.mailVerify,
      );
    } on WeakPasswordException {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Password is too weak"),
          ),
        );
    } on EmailIsUsedException
    {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Email is already in use"),
          ),
        );
    } on InvalidMailException
    {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Invalid email format"),
          ),
        );
    } on NotAllowedOperationException
    {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Sign up operation is not allowed"),
          ),
        );
    } on GenericException
    {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Registration error"),
          ),
        );
    }

    _emailController.text = "";
    _passwordController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
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
                text: "Register",
                isSecondary: false,
                onPressed: handleRegister,
              ),
              const SizedBox(height: 8),
              FormButton(
                isSecondary: true,
                text: "Already have an account?",
                onPressed: () async {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutes.login,
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
