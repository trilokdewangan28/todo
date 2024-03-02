import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

const Color bluishClr = Color.fromARGB(255, 11, 111, 245);
const Color yellowClr = Color(0xFFFFB746);
const Color pinkClr = Color(0xFFff4667);
const Color white = Colors.white;
const primaryColor = bluishClr;
const Color darkGreyClr = Color(0xFF121212);
const Color darkHeaderColor = Color(0xFF424242);


class Themes{
  
  static final light = ThemeData(
  primaryColor: primaryColor,
  backgroundColor: Colors.white,
  primaryColorLight: Colors.white,
  primaryColorDark: Colors.black,
  brightness: Brightness.light,
  useMaterial3: true,
  );

  static final dark =  ThemeData(
    backgroundColor: darkGreyClr,
  primaryColor: darkGreyClr,
  primaryColorLight: Colors.white,
  primaryColorDark: Colors.black,
  brightness: Brightness.dark,
  useMaterial3: true,
  );
  
}

TextStyle get subHeadingStyle{
  return GoogleFonts.lato(
      textStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Get.isDarkMode ? Colors.grey[400] : Colors.grey
      )
  );
}

TextStyle get headingStyle{
  return GoogleFonts.lato(
      textStyle: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
          color: Get.isDarkMode ? Colors.white : Colors.black
      )
  );
}

TextStyle get titleStyle{
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Get.isDarkMode ? Colors.white : Colors.black
      )
  );
}

TextStyle get subTitleStyle{
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Get.isDarkMode ? Colors.grey[100]: Colors.grey[600],
      )
  );
}