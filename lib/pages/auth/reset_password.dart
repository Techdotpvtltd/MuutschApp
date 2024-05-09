import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musch/config/colors.dart';
import 'package:musch/pages/auth/reset_done.dart';
import 'package:musch/widgets/custom_button.dart';
import 'package:musch/widgets/text_field.dart';
import 'package:musch/widgets/text_widget.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
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
                      child: text_widget("Reset Your Password",
                          fontSize: 21.sp, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 0.4.h),
                    text_widget(
                        "Please check your inbox and follow the instructions to reset your password.",
                        fontSize: 15.sp,
                        color: Color(0xff8C8C8C),
                        textAlign: TextAlign.center),
                    SizedBox(height: 4.h),
                    textFieldWithPrefixSuffuxIconAndHintText(
                      "Email",
                      // controller: _.password,
                      fillColor: Colors.white,
                      mainTxtColor: Colors.black,
                      radius: 12,
                      bColor: Colors.transparent,
                      prefixIcon: "assets/icons/mail.png",
                      isPrefix: true,
                    ),
                    SizedBox(height: 9.h),
                    gradientButton("Send Code",
                        font: 16, txtColor: MyColors.white, ontap: () {
                      Get.to(ResetDone());
                    },
                        width: 90,
                        height: 6.6,
                        isColor: true,
                        clr: MyColors.primary),
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
