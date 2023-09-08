import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const seedColor = Color.fromRGBO(47, 49, 143, 1);

class AppTheme {
  ThemeData getTheme() => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.light,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
          textStyle: MaterialStateProperty.all<TextStyle>(GoogleFonts.roboto()),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          backgroundColor: MaterialStateProperty.all<Color>(seedColor),
        )),
        textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
          textStyle: MaterialStateProperty.all<TextStyle>(GoogleFonts.roboto(
              fontSize: 17, fontWeight: FontWeight.bold, color: seedColor)),
        )),
        inputDecorationTheme: InputDecorationTheme(
            hintStyle: GoogleFonts.roboto(
                fontSize: 15, fontStyle: FontStyle.italic, color: seedColor),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(50.0)),
              borderSide: BorderSide(color: seedColor, width: 30.0),
            )),
        listTileTheme: const ListTileThemeData(
          iconColor: seedColor,
        ),
        textTheme: TextTheme(
          displayLarge: GoogleFonts.roboto(
            fontSize: 72,
            fontWeight: FontWeight.bold,
          ),
          // ···
          titleLarge: GoogleFonts.roboto(
            fontSize: 30,
            fontStyle: FontStyle.italic,
          ),
          bodyMedium: GoogleFonts.roboto(),
          displaySmall: GoogleFonts.roboto(),
        ),
      );

  Color getColor() => seedColor;
}
