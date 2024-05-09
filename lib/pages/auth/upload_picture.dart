import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musch/config/colors.dart';
import 'package:musch/pages/auth/allow_location.dart';
import 'package:musch/widgets/custom_button.dart';
import 'package:musch/widgets/text_widget.dart';

import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class UploadPicture extends StatelessWidget {
  const UploadPicture({super.key});

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
                    Row(
                      children: [
                        InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Icon(
                              Remix.arrow_left_s_line,
                              color: Colors.black,
                              size: 3.h,
                            ))
                      ],
                    ),
                    Center(
                        child: Image.asset(
                      "assets/images/logo.png",
                      height: 10.h,
                    )),
                    SizedBox(height: 4.h),
                    text_widget("Upload Picture",
                        fontSize: 21.sp, fontWeight: FontWeight.w600),
                    SizedBox(height: 0.4.h),
                    text_widget(
                        "Please Upload Your Profile picture to create an account.",
                        fontSize: 15.sp,
                        color: Color(0xff8C8C8C)),
                    SizedBox(height: 6.h),
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 8.h,
                            backgroundColor: MyColors.primary,
                            child: CircleAvatar(
                              radius: 7.8.h,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 7.5.h,
                                backgroundColor: Colors.deepPurpleAccent,
                                backgroundImage:
                                    AssetImage("assets/images/girl.png"),
                              ),
                            ),
                          ),
                          Positioned.fill(
                              child: Align(
                            alignment: Alignment.bottomRight,
                            child: CircleAvatar(
                              backgroundColor: MyColors.primary,
                              radius: 2.h,
                              child: Image.asset(
                                "assets/icons/cam.png",
                                height: 2.4.h,
                              ),
                            ),
                          ))
                        ],
                      ),
                    ),
                    SizedBox(height: 3.h),
                    SizedBox(height: 7.h),
                    gradientButton("Next", font: 17, txtColor: MyColors.white,
                        ontap: () {
                      Get.to(AllowLocation());
                      // _.loginUser();
                    },
                        width: 90,
                        height: 6.6,
                        isColor: true,
                        clr: MyColors.primary),
                    SizedBox(height: 3.h),
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
