import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musch/config/colors.dart';
import 'package:musch/pages/home/friend_view.dart';
import 'package:musch/widgets/text_widget.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

Widget requestWidget() {
  return InkWell(
    onTap: () {
      Get.to(FriendView(
        isFriend: true,
        isChat: false,
      ));
    },
    child: Container(
      height: 30.h,
      // width: 46.w,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/im1.png"), fit: BoxFit.cover),
          borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Spacer(),
            text_widget("Hassan Ahmad",
                color: Colors.white,
                fontSize: 15.7.sp,
                fontWeight: FontWeight.bold),
            SizedBox(height: 0.5.h),
            Row(
              children: [
                Image.asset("assets/icons/p1.png", height: 1.6.h),
                SizedBox(width: 1.w),
                text_widget("Canada", fontSize: 14.sp, color: Colors.white)
              ],
            ),
            SizedBox(height: 1.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                  decoration: BoxDecoration(
                    color: MyColors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: text_widget("Yoga",
                      color: MyColors.primary, fontSize: 12.5.sp),
                ),
                SizedBox(width: 1.3.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                  decoration: BoxDecoration(
                    color: MyColors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: text_widget("Art",
                      color: MyColors.primary, fontSize: 12.5.sp),
                ),
                SizedBox(width: 1.3.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                  decoration: BoxDecoration(
                    color: MyColors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: text_widget("Music",
                      color: MyColors.primary, fontSize: 12.5.sp),
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
