import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musch/config/colors.dart';
import 'package:musch/pages/home/event_detail.dart';
import 'package:musch/widgets/text_widget.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

Widget eventWidget({bool isEvent = false}) {
  return InkWell(
    onTap: () {
      Get.to(EventView());
    },
    child: Container(
      decoration: isEvent
          ? BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(12))
          : BoxDecoration(),
      child: Padding(
        padding: EdgeInsets.all(isEvent ? 12.0 : 0),
        child: Row(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  "assets/images/ii1.png",
                  height: 8.5.h,
                  width: 10.h,
                  fit: BoxFit.cover,
                )),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  text_widget("Party With Friends",
                      fontSize: 16.sp, fontWeight: FontWeight.w600),
                  SizedBox(height: 0.5.h),
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/p2.png",
                        height: 1.4.h,
                      ),
                      SizedBox(width: 1.w),
                      Expanded(
                        child: text_widget("456 Park Avenue, New York",
                            fontSize: 12.8.sp, fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                  SizedBox(height: 0.8.h),
                  text_widget("Created by: Hammad Habib",
                      fontSize: 12.2.sp,
                      color: MyColors.primary,
                      fontWeight: FontWeight.w600)
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: MyColors.primary,
                borderRadius: BorderRadius.circular(50),
              ),
              child: text_widget("Join", color: Colors.white, fontSize: 14.sp),
            ),
          ],
        ),
      ),
    ),
  );
}
