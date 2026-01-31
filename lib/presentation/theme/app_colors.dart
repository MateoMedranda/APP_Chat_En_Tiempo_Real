import 'package:flutter/material.dart';

class AppColors {
  // Colores primarios - Azul profesional sobrio
  static const Color primary = Color(0xFF1F3A93);
  static const Color primaryDark = Color(0xFF152C6F);
  static const Color primaryLight = Color(0xFF2E5CB8);

  // Colores secundarios - Gris neutro
  static const Color secondary = Color(0xFF5A6C7D);
  static const Color secondaryDark = Color(0xFF3F4A57);

  // Colores neutros
  static const Color background = Color(0xFFFAFBFC);
  static const Color surface = Colors.white;
  static const Color inputBackground = Color(0xFFF0F2F5);

  // Colores de texto
  static const Color textPrimary = Color(0xFF0F1419);
  static const Color textSecondary = Color(0xFF65676B);
  static const Color textHint = Color(0xFF8A8D91);

  // Colores de mensajes - Profesional
  static const Color messageMine = Color(0xFFE8EEF7);
  static const Color messageMineText = Color(0xFF1F3A93);
  static const Color messageOther = Color(0xFFF0F2F5);
  static const Color messageOtherText = Color(0xFF0F1419);

  // Colores de estado
  static const Color success = Color(0xFF2E7D32);
  static const Color error = Color(0xFFC62828);
  static const Color warning = Color(0xFFF57F17);
  static const Color info = Color(0xFF1976D2);

  // Gradientes profesionales
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
