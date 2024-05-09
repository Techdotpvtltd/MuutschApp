import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musch/config/colors.dart';
import 'package:musch/pages/auth/reset_password.dart';
import 'package:musch/pages/auth/signup_page.dart';
import 'package:musch/pages/home/home_drawer.dart';
import 'package:musch/widgets/custom_button.dart';
import 'package:musch/widgets/text_field.dart';
import 'package:musch/widgets/text_widget.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
                    Center(
                        child: Image.asset(
                      "assets/images/logo.png",
                      height: 10.h,
                    )),
                    SizedBox(height: 4.h),
                    text_widget("Login for Business",
                        fontSize: 21.sp, fontWeight: FontWeight.w600),
                    SizedBox(height: 0.4.h),
                    text_widget("Enter your credentials  to log in",
                        fontSize: 15.sp, color: Color(0xff8C8C8C)),
                    SizedBox(height: 6.h),
                    textFieldWithPrefixSuffuxIconAndHintText(
                      "Enter Phone Number",
                      // controller: _.password,
                      fillColor: Colors.white,
                      mainTxtColor: Colors.black,
                      radius: 12,
                      bColor: Colors.transparent,
                      prefixIcon: "assets/icons/phone.png",
                      isPrefix: true,
                    ),
                    SizedBox(height: 2.h),
                    textFieldWithPrefixSuffuxIconAndHintText(
                      "Enter Phone Number",
                      // controller: _.password,
                      fillColor: Colors.white,
                      mainTxtColor: Colors.black,
                      radius: 12,
                      bColor: Colors.transparent,
                      prefixIcon: "assets/icons/lock.png",
                      isPrefix: true,
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      children: [
                        Spacer(),
                        InkWell(
                          onTap: () {
                            Get.to(ResetPassword());
                          },
                          child: text_widget("Forgot Password?",
                              fontSize: 13.5.sp, color: Color(0xff262626)),
                        ),
                      ],
                    ),
                    SizedBox(height: 7.h),
                    gradientButton("Log In", font: 17, txtColor: MyColors.white,
                        ontap: () {
                      Get.to(HomeDrawer());
                      // _.loginUser();
                    },
                        width: 90,
                        height: 6.6,
                        isColor: true,
                        clr: MyColors.primary),
                    SizedBox(height: 3.h),
                    Center(
                      child: InkWell(
                        onTap: () {
                          Get.to(SignupPage());
                        },
                        child: RichText(
                          text: TextSpan(
                            style: GoogleFonts.poppins(
                              color: MyColors.black,
                              fontSize: 15.3.sp,
                            ),
                            children: <TextSpan>[
                              TextSpan(text: 'Don’t have an account ?\t'),
                              TextSpan(
                                text: 'Signup',
                                style: GoogleFonts.poppins(
                                    shadows: [
                                      Shadow(
                                          color: MyColors.black,
                                          offset: Offset(0, -2))
                                    ],
                                    fontWeight: FontWeight.bold,
                                    color: Colors.transparent,
                                    fontSize: 15.3.sp,
                                    decoration: TextDecoration.underline,
                                    decorationColor: MyColors.primary,
                                    decorationThickness: 1.4),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Expanded(
                            child: Divider(
                          color: MyColors.primary,
                          thickness: 1,
                        )),
                        text_widget(" OR ", color: MyColors.primary),
                        Expanded(
                            child: Divider(
                          color: MyColors.primary,
                          thickness: 1,
                        )),
                      ],
                    ),
                    SizedBox(height: 3.h),
                    Row(
                      children: [
                        Spacer(),
                        Image.asset("assets/nav/apple.png", height: 6.h),
                        SizedBox(width: 4.w),
                        Image.asset("assets/nav/google.png", height: 6.h),
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
