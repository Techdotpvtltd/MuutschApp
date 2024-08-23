import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

Widget textFieldWithPrefixSuffuxIconAndHintText(
  String hintText, {
  suffixIcon,
  prefixIcon,
  TextEditingController? controller,
  int line = 1,
  bool isSuffix = false,
  bool enable = true,
  double? radius,
  fillColor,
  bColor,
  mainTxtColor,
  hintColor,
  bool isPrefix = false,
  color,
  iconColor,
  bool obsecure = false,
  TextInputAction? textInputAction,
  void Function(String)? onSubmitted,
  void Function(String)? onChanged,
}) {
  return StatefulBuilder(
    builder: (BuildContext context, setState) {
      return TextField(
        maxLines: line,
        enabled: enable,
        obscureText: obsecure,
        controller: controller,
        onChanged: (value) {
          if (onChanged != null) {
            onChanged(value);
          }
        },
        onSubmitted: onSubmitted,
        style: GoogleFonts.poppins(
            color: mainTxtColor ?? Colors.black, fontSize: 15.sp),
        textInputAction: textInputAction,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: hintColor ?? Color(0xffBCBCBC)),
          contentPadding: const EdgeInsets.symmetric(vertical: 20),
          suffixIconConstraints: BoxConstraints(),
          suffixIcon: isSuffix
              ? Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: InkWell(
                      onTap: () {
                        setState(() {
                          obsecure = !obsecure;
                        });
                      },
                      child: Image.asset(
                        suffixIcon ?? "assets/icons/eye.png",
                        height: 2.6.h,
                      )),
                )
              : const SizedBox(),
          prefixIconConstraints: BoxConstraints(minWidth: 8.w),
          prefixIcon: isPrefix
              ? InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Image.asset(
                      prefixIcon,
                      height: 2.4.h,
                    ),
                  ),
                )
              : const SizedBox(),
          filled: true,
          fillColor: fillColor ?? Color(0xffF7F7F7),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius ?? 35),
            borderSide:
                BorderSide(color: bColor ?? Color(0xffD3DEF3), width: 1),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius ?? 35),
            borderSide:
                BorderSide(color: bColor ?? Color(0xffE6DCCD), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius ?? 35),
            borderSide: BorderSide(color: Color(0xffE6DCCD), width: 1),
          ),
        ),
      );
    },
  );
}
