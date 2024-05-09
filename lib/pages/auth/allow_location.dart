import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musch/config/colors.dart';
import 'package:musch/pages/auth/interest_page.dart';
import 'package:musch/widgets/custom_button.dart';
import 'package:musch/widgets/text_widget.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AllowLocation extends StatelessWidget {
  const AllowLocation({super.key});

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
                    text_widget("Help them find you!",
                        fontSize: 21.sp, fontWeight: FontWeight.w600),
                    SizedBox(height: 0.4.h),
                    text_widget(
                        "Allow us to access your location while you’re using the app so we can help you find and meet members.",
                        fontSize: 15.sp,
                        color: Color(0xff8C8C8C)),
                    SizedBox(height: 4.h),
                    Center(
                        child: Image.asset(
                      "assets/icons/pin.png",
                      height: 20.h,
                    )),
                    SizedBox(height: 6.h),
                    gradientButton("Allow Location",
                        font: 16, txtColor: MyColors.white, ontap: () {
                      Get.to(InterestPage());
                      // _.loginUser();
                    },
                        width: 90,
                        height: 6.6,
                        isColor: true,
                        clr: MyColors.primary),
                    SizedBox(height: 3.h),
                    gradientButton("Enter Location Manually",
                        font: 16, txtColor: MyColors.primary, ontap: () {
                      // _.loginUser();
                    },
                        width: 90,
                        height: 6.6,
                        isColor: false,
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
