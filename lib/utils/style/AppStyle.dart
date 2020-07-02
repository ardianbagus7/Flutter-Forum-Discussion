import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

class AppStyle {
  //static Color colorMain = Color(0xFF0EBD58);
  //static Color colorMain = Color(0xFF003201);
  //static Color colorMain = Color(0xFF00290B); //ijo telkom
  static Color colorMain = Color(0xFF067B64); // 067B64
  static Color colorMain2 = Color(0xFFC9D869);
  static Color colorMain3 = Color(0xFFF4D20C);

  static Color colorWhite = Color(0xFFFFFFFF);
  static Color colorBg = Color(0xFFF6F7F9);

  static TextStyle textHeadlineWhite = GoogleFonts.poppins(
    textStyle: TextStyle(
      color: Colors.white,
    ),
    fontSize: 24,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
  );

  static TextStyle textHeadlineBlack = GoogleFonts.poppins(
    textStyle: TextStyle(
      color: Colors.black,
    ),
    fontSize: 20,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w600,
  );

  static TextStyle textHeadlineProfil = GoogleFonts.poppins(
    textStyle: TextStyle(
      color: Colors.black,
    ),
    fontSize: 22,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w600,
  );

  static TextStyle textHeadlineTipisBlack = GoogleFonts.poppins(
    textStyle: TextStyle(
      color: Colors.black,
    ),
    fontSize: 20,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w300,
  );

  static TextStyle textSubHeadlineBlack = GoogleFonts.poppins(
    textStyle: TextStyle(
      color: Colors.black,
    ),
    fontSize: 16,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
  );

  static TextStyle textSubHeadingAbu = GoogleFonts.poppins(
    textStyle: TextStyle(
      color: Colors.black.withOpacity(0.5),
    ),
    fontSize: 16,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
  );

  static TextStyle textSubHeadingPutih = GoogleFonts.poppins(
    textStyle: TextStyle(
      color: Colors.white,
    ),
    fontSize: 16,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
  );

  static TextStyle textSubHeading2Putih = GoogleFonts.poppins(
    textStyle: TextStyle(
      color: Colors.white,
    ),
    fontSize: 16,
    fontStyle: FontStyle.normal,
  );

  static TextStyle textSearchPutih = GoogleFonts.poppins(
    textStyle: TextStyle(
      color: Colors.grey,
    ),
    fontSize: 16,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w300,
  );

  static TextStyle textBody1 = GoogleFonts.poppins(
    textStyle: TextStyle(
      color: Color(0xFF4A4A4A),
    ),
    fontSize: 14,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
  );

  static TextStyle textRegular = GoogleFonts.poppins(
    textStyle: TextStyle(
      color: Colors.black,
    ),
    fontSize: 18,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
  );

  static TextStyle textList = GoogleFonts.poppins(
    textStyle: TextStyle(
      color: Colors.black,
    ),
    fontSize: 18,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
  );

  static TextStyle textName = GoogleFonts.poppins(
    textStyle: TextStyle(
      color: Colors.black87,
    ),
    fontSize: 18,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w600,
  );

  static TextStyle textName2 = GoogleFonts.poppins(
    textStyle: TextStyle(
      color: Colors.white,
    ),
    fontSize: 18,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w600,
  );

  static TextStyle textCaption = GoogleFonts.poppins(
    textStyle: TextStyle(
      color: Color(0xFF646464),
    ),
    fontSize: 12,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
  );

  static TextStyle textCaption2 = GoogleFonts.poppins(
    textStyle: TextStyle(
      color: Color(0xFF646464),
    ),
    fontSize: 15,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
  );

  static BoxDecoration decorationCard = BoxDecoration(
    color: AppStyle.colorWhite,
    borderRadius: BorderRadius.all(
      Radius.circular(20.0),
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.25),
        offset: Offset(0.0, 2),
        blurRadius: 15.0,
      )
    ],
  );
}
