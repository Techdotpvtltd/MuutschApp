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

class ContactUsPage extends StatefulWidget {
  final bool isDrawer;
  const ContactUsPage({super.key, required this.isDrawer});

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
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
                        text_widget("Contact us",
                            color: Colors.black, fontSize: 18.sp),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Center(
                        child: Image.asset(
                      "assets/icons/us.png",
                      height: 24.h,
                    )),
                    SizedBox(height: 1.h),
                    text_widget(
                      "Name",
                      fontSize: 15.6.sp,
                    ),
                    SizedBox(height: 1.h),
                    textFieldWithPrefixSuffuxIconAndHintText(
                      "Write Here",
                      // controller: _.password,
                      fillColor: Colors.white,
                      mainTxtColor: Colors.black,
                      radius: 12,
                      bColor: Colors.transparent,
                      prefixIcon: "assets/icons/lock.png",
                      isPrefix: false,
                    ),
                    SizedBox(height: 2.h),
                    text_widget(
                      "Email",
                      fontSize: 15.6.sp,
                    ),
                    SizedBox(height: 1.h),
                    textFieldWithPrefixSuffuxIconAndHintText(
                      "Write Here",
                      // controller: _.password,
                      fillColor: Colors.white,
                      mainTxtColor: Colors.black,
                      radius: 12,
                      bColor: Colors.transparent,
                      prefixIcon: "assets/icons/lock.png",
                      isPrefix: false,
                    ),
                    SizedBox(height: 2.h),
                    text_widget(
                      "Phone",
                      fontSize: 15.6.sp,
                    ),
                    SizedBox(height: 1.h),
                    textFieldWithPrefixSuffuxIconAndHintText(
                      "Write Here",
                      // controller: _.password,
                      fillColor: Colors.white,
                      mainTxtColor: Colors.black,
                      radius: 12,
                      bColor: Colors.transparent,
                      prefixIcon: "assets/icons/lock.png",
                      isPrefix: false,
                    ),
                    SizedBox(height: 2.h),
                    text_widget(
                      "Message",
                      fontSize: 15.6.sp,
                    ),
                    SizedBox(height: 1.h),
                    textFieldWithPrefixSuffuxIconAndHintText(
                      "Write Here",
                      line: 5,
                      // controller: _.password,
                      fillColor: Colors.white,
                      mainTxtColor: Colors.black,
                      radius: 12,
                      bColor: Colors.transparent,
                      prefixIcon: "assets/icons/lock.png",
                      isPrefix: false,
                    ),
                    SizedBox(height: 4.h),
                    gradientButton("Submit", font: 16, txtColor: MyColors.white,
                        ontap: () {
                      // Get.to(ResetDone());
                    },
                        width: 90,
                        height: 6.6,
                        isColor: true,
                        clr: MyColors.primary),
                    SizedBox(height: 14.h),
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
