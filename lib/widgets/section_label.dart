import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class SectionLabel extends StatelessWidget {
  final String label;
  const SectionLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 30,
          height: 2,
          decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        ),
        const SizedBox(width: 12),
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: AppColors.primaryPurple,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 3,
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 30,
          height: 2,
          decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        ),
      ],
    );
  }
}

class SectionLabelLeft extends StatelessWidget {
  final String label;
  const SectionLabelLeft({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 2,
          decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        ),
        const SizedBox(width: 12),
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: AppColors.primaryPurple,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 3,
          ),
        ),
      ],
    );
  }
}
