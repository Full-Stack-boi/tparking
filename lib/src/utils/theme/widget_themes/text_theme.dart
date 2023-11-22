import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TTextTheme{
  static TextTheme lightTextTheme = TextTheme(
    headlineLarge : GoogleFonts.tiltNeon(
      color: Colors.black87,
    ),
    headlineMedium : GoogleFonts.tiltNeon(
      color: Colors.black87,
    ),
    titleLarge: GoogleFonts.tiltNeon(
      color: Colors.black54,
      fontSize: 24,
    ),
    titleSmall: GoogleFonts.tiltNeon(
      color: Colors.black54,
      fontSize: 24,
    ),
    displayLarge : GoogleFonts.tiltNeon(
      color: Colors.black54,
      fontSize: 24, 
    ), 
    displayMedium : GoogleFonts.tiltNeon(
      color: Colors.black54,
    ),
    displaySmall : GoogleFonts.tiltNeon(
      color: Colors.black54,
    ),  
  );

  

 static TextTheme darkTextTheme = TextTheme(
   headlineLarge : GoogleFonts.tiltNeon(
      color: Colors.white70,
    ),
    headlineMedium : GoogleFonts.tiltNeon(
      color: Colors.white70,
    ),
    titleLarge: GoogleFonts.tiltNeon(
      color: Colors.white60,
      fontSize: 24,
    ),
    titleSmall: GoogleFonts.tiltNeon(
      color: Colors.white60,
      fontSize: 24,
    ),
    displayLarge : GoogleFonts.tiltNeon(
      color: Colors.white70,
      fontSize: 24,
    ), 
    displayMedium : GoogleFonts.tiltNeon(
      color: Colors.white70,
    ),
    displaySmall : GoogleFonts.tiltNeon(
      color: Colors.white70,
    ),  
  );
}