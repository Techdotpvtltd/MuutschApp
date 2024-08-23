// ignore: dangling_library_doc_comments
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

/// Project: 	   waste_admin
/// File:    	   style_guide
/// Path:    	   lib/utils/style_guide.dart
/// Author:       Ali Akbar
/// Date:        25-03-24 14:18:14 -- Monday
/// Description:

class StyleGuide {
  /// Theme
  static const primaryColor = Color(0xFFBDFE30);
  static const primaryColor2 = Color.fromARGB(255, 109, 156, 7);
  static const widgetColor = Color(0xFF1E1E1E);
  static const widgetFGColor = Colors.white;
  static const backgroundColor = Colors.white;

  /// Menu Theme
  static const menuBackgroundColor = Color.fromARGB(255, 140, 195, 23);
  static const mMenuSelectedItemColor = Colors.white;
  static const mMenuUnSelectedItemColor = Colors.white60;
  static const mMenuBGSelectionColor = Color.fromARGB(255, 109, 156, 7);

  /// Sub Menu Theme
  static const sMenuBackgroundColor = Color.fromARGB(255, 109, 156, 7);
  static const sMenuSelectedItemColor = Colors.white;
  static const sMenuUnSelectedItemColor = Colors.white54;
  static const sMenuBGSelectionColor = Color.fromARGB(255, 102, 142, 16);

  /// Gray Color
  static const lightGrayColor1 = Color(0xFFF6F7FB);
  static const grayColor = Color.fromARGB(255, 182, 181, 181);

  /// Home Navigation Colors
  static const navUnSelectedItemColor = Colors.white70;
  static const navSelectedItemColor = Colors.black;

  // Primary Button
  static const primaryButtonFGColor = Colors.black;

  // Secondary Button
  static const secondaryButtonBGColor = Color(0xFF2E2E2E);
  static const secondaryButtonFGColor = Colors.white;

  // DataTable Colors
  static const dataTableBGColor = Color(0xFF1E1E1E);
  static const dataTableRowBGColor = Color(0xFF2E2E2E);
  static const dataTableSecondDataRowColor = Color.fromARGB(255, 45, 45, 50);
  static const dataTableTextColor = Colors.white;

  // TextFieldTheme
  static const textFiledBackgroundColor = Color(0xFF303030);
  static const textFiledForgroundColor = Colors.white;
  static const textFiledFocusIconColor = Colors.white;
  static const textFiledPlaceholderColor = Color(0xFF91929F);

  // Dialog Theme
  static const dialogBGColor = widgetColor;
  static const dialogIconBGColor = backgroundColor;
  static const dialogDescriTextColor = Color(0xFF868686);

  static final TextStyle mediumTitle = GoogleFonts.plusJakartaSans(
    color: Colors.white,
    fontSize: 16.sp,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle placeHolderTS = GoogleFonts.plusJakartaSans(
    color: textFiledPlaceholderColor,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static final TextStyle subtitleTS = GoogleFonts.plusJakartaSans(
    color: Colors.white,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
}
