import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../config/colors.dart';
import '../utils/constants/constants.dart';

Widget gradientButton(
  String title, {
  bool isColor = false,
  Color clr = Colors.white,
  Function? ontap,
  Color txtColor = Colors.white,
  bColor,
  bWidth,
  double font = 0,
  double height = 0,
  double width = 0,
  bool isLoading = false,
}) {
  return InkWell(
    onTap: () {
      if (ontap != null && !isLoading) {
        ontap();
      }
    },
    child: Container(
      width: width.w,
      height: height == 0 ? 6.3.h : height.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isColor ? clr : Colors.transparent,
        border: isColor
            ? null
            : Border.all(color: bColor ?? MyColors.primary, width: bWidth ?? 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isLoading) CircularProgressIndicator(color: Colors.white),
          if (isLoading) gapW10,
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: font == 0 ? 17.sp : font.sp,
              fontWeight: FontWeight.w500,
              color: txtColor,
            ),
          ),
        ],
      ),
    ),
  );
}
