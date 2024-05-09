import 'package:flutter/material.dart';
import 'package:musch/config/colors.dart';
import 'package:musch/widgets/custom_button.dart';
import 'package:musch/widgets/text_widget.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

Widget requestCard({bool isAccept = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12.0),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 3.h,
                  backgroundColor: MyColors.primary,
                  backgroundImage: AssetImage("assets/images/girl.png"),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          text_widget(
                            "Ronaldo Seemd",
                            fontSize: 15.8.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          Spacer(),
                          text_widget("2 day ago",
                              fontSize: 13.4.sp,
                              color: Color(0xff525252),
                              fontWeight: FontWeight.w400),
                        ],
                      ),
                      SizedBox(height: 0.3.h),
                      Row(
                        children: [
                          text_widget("Traveling",
                              fontSize: 13.4.sp,
                              color: Color(0xff525252),
                              fontWeight: FontWeight.w400),
                          SizedBox(width: 2.w),
                          text_widget("Photography",
                              fontSize: 13.4.sp,
                              color: Color(0xff525252),
                              fontWeight: FontWeight.w400),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.5.h),
            Row(
              children: [
                isAccept
                    ? SizedBox()
                    : Expanded(
                        child: gradientButton("Decline Request",
                            font: 14.5, txtColor: MyColors.primary, ontap: () {
                          // _.loginUser();
                        },
                            width: 90,
                            height: 4.8,
                            isColor: false,
                            clr: MyColors.primary),
                      ),
                isAccept ? SizedBox() : SizedBox(width: 2.w),
                Expanded(
                  child: gradientButton(
                      isAccept ? "Cancel Request" : "Accept Request",
                      font: 14.5,
                      txtColor: MyColors.white, ontap: () {
                    // _.loginUser();
                  },
                      width: 90,
                      height: 4.8,
                      isColor: true,
                      clr: MyColors.primary),
                ),
              ],
            ),
            SizedBox(height: 1.h),
          ],
        ),
      ),
    ),
  );
}
