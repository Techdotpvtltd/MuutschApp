import 'package:flutter/material.dart';
import 'package:musch/config/colors.dart';
import 'package:musch/widgets/custom_button.dart';
import 'package:musch/widgets/text_widget.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

class ResetDone extends StatefulWidget {
  const ResetDone({super.key});

  @override
  State<ResetDone> createState() => _ResetDoneState();
}

class _ResetDoneState extends State<ResetDone> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            color: Color(0xffF2F2F2),
          ),
        ),
        Positioned.fill(
            child: Align(
          alignment: Alignment.bottomRight,
          child: Image.asset(
            "assets/images/shape.png",
            height: 25.h,
            fit: BoxFit.fill,
          ),
        )),
        Positioned.fill(
            child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12.0, horizontal: 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8.h),
                    Center(
                        child: Image.asset(
                      "assets/images/reset.png",
                      height: 14.h,
                    )),
                    SizedBox(height: 4.h),
                    Center(
                      child: textWidget("Email has been sent!",
                          fontSize: 21.sp, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 0.4.h),
                    textWidget(
                        "Please check your inbox and follow the instructions to reset your password.",
                        fontSize: 15.sp,
                        color: Color(0xff8C8C8C),
                        textAlign: TextAlign.center),
                    SizedBox(height: 9.h),
                    gradientButton("Sign In",
                        font: 16,
                        txtColor: MyColors.white,
                        ontap: () {},
                        width: 90,
                        height: 6.6,
                        isColor: true,
                        clr: MyColors.primary),
                    SizedBox(height: 2.h),
                    Center(
                      child: textWidget("Didn’t receive the link?",
                          fontSize: 15.sp,
                          color: MyColors.primary,
                          textAlign: TextAlign.center),
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      children: [
                        Spacer(),
                        Image.asset(
                          "assets/icons/reset.png",
                          height: 1.7.h,
                        ),
                        SizedBox(width: 2.w),
                        textWidget("Reset",
                            fontSize: 15.sp,
                            color: MyColors.primary,
                            textAlign: TextAlign.center),
                        Spacer(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ))
      ],
    );
  }
}
