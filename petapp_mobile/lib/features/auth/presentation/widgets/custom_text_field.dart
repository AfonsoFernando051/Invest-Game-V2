import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_color_tokens.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final bool obscure;
  final TextEditingController? controller;

  /// Shown below the field in [AppColorTokens.error] and turns the field's
  /// own border/glow red — `null` (the default) leaves the field exactly as
  /// before for every call site that doesn't opt in.
  final String? errorText;

  const CustomTextField({
    super.key,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.controller,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.colors;
    final hasError = errorText != null;
    final accentColor = hasError ? tokens.error : AppColors.neonCyan;
    return Container(
      decoration: BoxDecoration(
        color: tokens.surface.withValues(alpha: context.isDarkMode ? 0.05 : 0.9),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: accentColor.withValues(alpha: hasError ? 0.8 : 0.4), width: 1.0),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.1),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: TextStyle(color: tokens.textPrimary),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: accentColor),
          hintText: hint,
          hintStyle: TextStyle(color: tokens.textTertiary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          errorText: errorText,
          errorStyle: TextStyle(color: tokens.error, fontSize: 12),
          errorMaxLines: 2,
        ),
      ),
    );
  }
}
