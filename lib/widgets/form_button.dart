import 'package:flutter/material.dart';
import 'package:noting/constants/colors.dart';

class FormButton extends StatelessWidget {
  final String text;
  final bool isSecondary;
  final VoidCallback? onPressed;

  const FormButton({
    Key? key,
    required this.text,
    required this.isSecondary,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color foregroundColor = isSecondary ? AppColors.secondaryText : AppColors.primaryText;
    Color backgroundColor = isSecondary ? AppColors.secondary : AppColors.primary;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: foregroundColor,
        backgroundColor: backgroundColor,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: foregroundColor,
        ),
      ),
    );
  }
}
