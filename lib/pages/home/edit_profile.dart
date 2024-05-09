import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musch/config/colors.dart';
import 'package:musch/widgets/custom_button.dart';
import 'package:musch/widgets/text_field.dart';
import 'package:musch/widgets/text_widget.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class EditProfile extends StatefulWidget {
  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  List<bool> faqs = [false, false, false, false, false];
  bool status4 = false;
  int current = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      body: SingleChildScrollView(
        child: SafeArea(
            bottom: false,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 22.0, vertical: 14),
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
                            size: 3.8.h,
                          )),
                      SizedBox(width: 3.w),
                      text_widget(
                        "Edit Profile",
                        fontWeight: FontWeight.w600,
                        fontSize: 18.sp,
                        // color: Color(0xff1E1E1E)
                      ),
                    ],
                  ),
                  // SizedBox(height: 1.h),
                  SizedBox(height: 3.h),
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          backgroundColor: MyColors.primary,
                          radius: 5.7.h,
                          backgroundImage: AssetImage('assets/images/girl.png'),
                        ),
                        Positioned.fill(
                            child: Align(
                          alignment: Alignment.bottomRight,
                          child: Image.asset(
                            "assets/icons/cam1.png",
                            height: 3.h,
                          ),
                        ))
                      ],
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Center(
                    child: text_widget(
                      "Irene foks",
                      fontSize: 17.8.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  text_widget(
                    "Name",
                    fontSize: 15.6.sp,
                  ),
                  SizedBox(height: 1.h),

                  textFieldWithPrefixSuffuxIconAndHintText("Hammad Habbib",
                      // controller: _.password,
                      fillColor: Colors.white,
                      mainTxtColor: Colors.black,
                      radius: 12,
                      bColor: Colors.transparent,
                      isSuffix: true,
                      suffixIcon: "assets/icons/edit.png"),

                  SizedBox(height: 3.h),
                  text_widget(
                    "Email",
                    fontSize: 15.6.sp,
                  ),
                  SizedBox(height: 1.h),

                  textFieldWithPrefixSuffuxIconAndHintText("sddmnbhr@gmail.com",
                      // controller: _.password,
                      fillColor: Colors.white,
                      mainTxtColor: Colors.black,
                      radius: 12,
                      bColor: Colors.transparent,
                      isSuffix: true,
                      suffixIcon: "assets/icons/edit.png"),
                  SizedBox(height: 3.h),
                  text_widget(
                    "Password",
                    fontSize: 15.6.sp,
                  ),
                  SizedBox(height: 1.h),

                  textFieldWithPrefixSuffuxIconAndHintText("***********",
                      // controller: _.password,
                      obsecure: true,
                      fillColor: Colors.white,
                      mainTxtColor: Colors.black,
                      radius: 12,
                      bColor: Colors.transparent,
                      isSuffix: true,
                      suffixIcon: "assets/icons/edit.png"),

                  SizedBox(height: 3.h),
                  text_widget(
                    "Location",
                    fontSize: 15.6.sp,
                  ),
                  SizedBox(height: 1.h),

                  textFieldWithPrefixSuffuxIconAndHintText("New York",
                      // controller: _.password,
                      fillColor: Colors.white,
                      mainTxtColor: Colors.black,
                      radius: 12,
                      bColor: Colors.transparent,
                      isSuffix: true,
                      suffixIcon: "assets/icons/edit.png"),
                  SizedBox(height: 3.h),
                  text_widget(
                    "Interest",
                    fontSize: 15.6.sp,
                  ),
                  SizedBox(height: 1.h),

                  Container(
                    height: 6.h,
                    child: Row(
                      children: [
                        Expanded(
                            child: Container(
                          height: 6.h,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: [
                                text_widget("Traveling",
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15.5.sp),
                                Spacer(),
                                Image.asset(
                                  "assets/icons/edit.png",
                                  height: 2.3.h,
                                )
                              ],
                            ),
                          ),
                        )),
                        SizedBox(width: 2.5.w),
                        Expanded(
                            child: Container(
                          height: 6.h,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: [
                                text_widget("Shopping",
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15.5.sp),
                                Spacer(),
                                Image.asset(
                                  "assets/icons/edit.png",
                                  height: 2.3.h,
                                )
                              ],
                            ),
                          ),
                        ))
                      ],
                    ),
                  ),
                  SizedBox(height: 1.h),

                  Container(
                    height: 6.h,
                    child: Row(
                      children: [
                        Expanded(
                            child: Container(
                          height: 6.h,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: [
                                text_widget("Photography",
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15.5.sp),
                                Spacer(),
                                Image.asset(
                                  "assets/icons/edit.png",
                                  height: 2.3.h,
                                )
                              ],
                            ),
                          ),
                        )),
                        SizedBox(width: 2.5.w),
                        Expanded(
                            child: Container(
                          height: 6.h,
                        ))
                      ],
                    ),
                  ),
                  SizedBox(height: 4.h),
                  gradientButton("Save Change",
                      font: 17, txtColor: MyColors.white, ontap: () {
                    // _.loginUser();
                  },
                      width: 90,
                      height: 6.6,
                      isColor: true,
                      clr: MyColors.primary),
                  SizedBox(height: 10.h),
                ],
              ),
            )),
      ),
    );
  }
}
