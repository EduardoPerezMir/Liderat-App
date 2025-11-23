import 'package:flutter/material.dart';

ThemeData buildTheme() => ThemeData(
  useMaterial3: true,
  colorSchemeSeed: const Color(0xFF2F6FED),
  scaffoldBackgroundColor: const Color(0xFFF7F9FC),
  textTheme: const TextTheme(
    titleLarge: TextStyle(fontWeight: FontWeight.w700),
    bodyMedium: TextStyle(height: 1.35),
  ),
);

