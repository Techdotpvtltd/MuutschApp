import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musch/config/colors.dart';
import 'package:musch/controller/drawer_controller.dart';
import 'package:musch/pages/home/home_drawer.dart';
import 'package:musch/widgets/custom_button.dart';
import 'package:musch/widgets/text_field.dart';
import 'package:musch/widgets/text_widget.dart';

import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ChangePassword extends StatefulWidget {
  final bool isDrawer;
  const ChangePassword({super.key, required this.isDrawer});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
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
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        InkWell(
                            onTap: () {
                              Get.find<MyDrawerController>().closeDrawer();
                              Get.to(HomeDrawer());
                            },
                            child: Icon(Remix.arrow_left_s_line,
                                color: Colors.black, size: 4.h)),
                        SizedBox(width: 2.w),
                        textWidget("Change Password",
                            color: Colors.black, fontSize: 18.sp),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Center(
                        child: Image.asset(
                      "assets/images/reset.png",
                      height: 14.h,
                    )),
                    SizedBox(height: 4.h),
                    Center(
                      child: textWidget("Reset Your Password",
                          fontSize: 21.sp, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 0.4.h),
                    textWidget(
                        "Please check your inbox and follow the instructions to reset your password.",
                        fontSize: 15.sp,
                        color: Color(0xff8C8C8C),
                        textAlign: TextAlign.center),
                    SizedBox(height: 4.h),
                    textFieldWithPrefixSuffuxIconAndHintText(
                      "Enter Password",
                      // controller: _.password,
                      fillColor: Colors.white,
                      mainTxtColor: Colors.black,
                      radius: 12,
                      bColor: Colors.transparent,
                      prefixIcon: "assets/icons/lock.png",
                      isPrefix: true,
                    ),
                    SizedBox(height: 2.h),
                    textFieldWithPrefixSuffuxIconAndHintText(
                      "Confirm Password",
                      // controller: _.password,
                      fillColor: Colors.white,
                      mainTxtColor: Colors.black,
                      radius: 12,
                      bColor: Colors.transparent,
                      prefixIcon: "assets/icons/lock.png",
                      isPrefix: true,
                    ),
                    SizedBox(height: 9.h),
                    gradientButton("Change Password",
                        font: 16, txtColor: MyColors.white, ontap: () {
                      // Get.to(ResetDone());
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
