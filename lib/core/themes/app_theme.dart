import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ClsAppTheme {
  static ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.green,
    scaffoldBackgroundColor: Color(0xFFEFF3F8),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      toolbarHeight: 80,
      backgroundColor: Color(0xFFEFF3F8),
      elevation: 0,
    ),

    popupMenuTheme: PopupMenuThemeData(
      color: Color.fromARGB(255, 164, 164, 211),
    ),
    cardColor: Colors.grey[200],
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color(0xFFEFF3F8),
      selectedItemColor: Colors.green[700],
      unselectedItemColor: Colors.grey[600],
      showUnselectedLabels: true,
      selectedIconTheme: IconThemeData(size: 30, color: Colors.black),
      unselectedIconTheme: IconThemeData(size: 25, color: Colors.grey),
    ),
    drawerTheme: DrawerThemeData(backgroundColor: Color(0xFFEFF3F8)),

    textTheme: GoogleFonts.cairoTextTheme(
      TextTheme(
        bodyMedium: TextStyle(color: Colors.black, fontSize: 16),
        titleMedium: TextStyle(
          color: Colors.black,
          fontSize: 20,
          // fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(color: Colors.black, fontSize: 24),
        bodySmall: TextStyle(
          color: Colors.black,
          fontSize: 14,
          // fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Color(0xFF1A1A2E),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      toolbarHeight: 80,
      backgroundColor: Color(0xFF1A1A2E),
      elevation: 0,
    ),

    cardColor: Color(0xFF2A2A3E),

    popupMenuTheme: PopupMenuThemeData(color: Color.fromARGB(255, 94, 94, 137)),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color.fromARGB(255, 49, 49, 92),
      selectedItemColor: Colors.green[400],
      unselectedItemColor: Colors.grey[500],
      showUnselectedLabels: true,
      selectedIconTheme: IconThemeData(color: Colors.green),
    ),
    drawerTheme: DrawerThemeData(backgroundColor: Color(0xFF1A1A2E)),
    textTheme: GoogleFonts.cairoTextTheme(
      TextTheme(
        bodyMedium: TextStyle(color: Colors.white, fontSize: 15),
        titleMedium: TextStyle(color: Colors.white, fontSize: 19),
        titleLarge: TextStyle(color: Colors.white, fontSize: 23),
        bodySmall: TextStyle(color: Colors.white, fontSize: 13),
      ),
    ),
  );
}
