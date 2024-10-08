import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musch/config/colors.dart';
import 'package:musch/pages/home/friend_view.dart';
import 'package:musch/widgets/text_widget.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

import '../models/friend_model.dart';

Widget requestWidget({required user, required FriendModel friend}) {
  return InkWell(
    onTap: () {
      Get.to(
        FriendView(
          friend: friend,
          userId: user.uid,
        ),
      );
    },
    child: Container(
      height: 30.h,
      width: 46.w,
      decoration: BoxDecoration(
        image: DecorationImage(
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.07),
            BlendMode.srcOver,
          ),
          image: NetworkImage(user.avatar),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(16),
        color: MyColors.primary3,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Spacer(),
            textWidget(
              user.name,
              color: Colors.white,
              fontSize: 15.7.sp,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: 0.5.h),
            Row(
              children: [
                Image.asset("assets/icons/p1.png", height: 1.6.h),
                SizedBox(width: 1.w),
                textWidget(
                  user.location?.city ?? user.location?.country ?? "---",
                  fontSize: 14.sp,
                  color: Colors.white,
                )
              ],
            ),
            SizedBox(height: 1.h),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (int i = 0;
                      i < (user.interests?.take(3) ?? []).length;
                      i++)
                    Row(
                      children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                          decoration: BoxDecoration(
                            color: MyColors.white,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: textWidget(
                            user.interests?[i] ?? "",
                            color: MyColors.primary,
                            fontSize: 12.5.sp,
                          ),
                        ),
                        SizedBox(width: 1.3.w),
                      ],
                    ),
                ],
              ),
            ),
            SizedBox(height: 1.h),
          ],
        ),
      ),
    ),
  );
}
