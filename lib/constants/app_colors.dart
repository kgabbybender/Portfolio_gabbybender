import 'package:flutter/material.dart';

class AppColors {
  // Primary Purple Palette
  static const Color primaryPurple = Color(0xFF6C63FF);
  static const Color deepPurple = Color(0xFF4A00E0);
  static const Color lightPurple = Color(0xFF9D8FFF);
  static const Color neonPurple = Color(0xFFBB86FC);
  static const Color softPurple = Color(0xFF7B68EE);

  // Background Colors
  static const Color darkBackground = Color(0xFF0A0A0F);
  static const Color darkSurface = Color(0xFF0F0E17);
  static const Color surface = Color(0xFF1A1828);
  static const Color cardSurface = Color(0xFF1E1C2E);
  static const Color glassCard = Color(0xFF252338);

  // Text Colors
  static const Color textMain = Color(0xFFFFFFFE);
  static const Color textSecondary = Color(0xFFA7A9BE);
  static const Color textMuted = Color(0xFF6B6B8A);

  // Accent Colors
  static const Color accent = Color(0xFFFF8906);
  static const Color accentCyan = Color(0xFF00D4FF);
  static const Color accentPink = Color(0xFFFF6B9D);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFF4A00E0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF0A0A0F), Color(0xFF1A0A2E), Color(0xFF0A0A0F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF1E1C2E), Color(0xFF252338)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient purpleGlow = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFFBB86FC), Color(0xFF6C63FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
