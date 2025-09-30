import 'package:flutter/material.dart';
import 'screens/search_screen.dart';


const Color midnightblack = Color(0xFF121212);
const Color surfaceblack = Color(0xFF1E1E1E);
const Color accentAmber = Color(0xFFFFC107);


void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
Widget build(BuildContext context) {
  return MaterialApp(
  title: 'Platform Timer',
  themeMode: ThemeMode.dark, // We are forcing dark mode
  debugShowCheckedModeBanner: false,
  // --- LIGHT THEME (DAY UNIFORM) ---
  // We'll update this to use amber too, for consistency.
  theme: ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: accentAmber, // <-- Use accentAmber here
    ),
  ),

  // --- DARK THEME (NIGHT UNIFORM) ---
  // This is the one we are actively using.
  darkTheme: ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: midnightblack,
    colorScheme: ColorScheme.fromSeed(
      seedColor: accentAmber, // <-- And also use accentAmber here
      brightness: Brightness.dark,
      background: midnightblack,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceblack,
      hintStyle: TextStyle(color: Colors.grey.shade600),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: accentAmber, width: 2),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accentAmber,
        foregroundColor: Colors.black,
        elevation: 5,
      ),
    ),
  ),
  
  home: const SearchScreen(),
);
}
}
