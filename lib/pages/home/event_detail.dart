import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musch/config/colors.dart';
import 'package:musch/widgets/custom_button.dart';
import 'package:musch/widgets/map_sample.dart';
import 'package:musch/widgets/text_widget.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class EventView extends StatelessWidget {
  const EventView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F2F2),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 22.0, vertical: 0),
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
                            size: 4.h,
                          )),
                      SizedBox(width: 3.w),
                      text_widget(
                        "Events Detail",
                        fontSize: 19.sp,
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(
                      "assets/images/eimg.png",
                      height: 38.h,
                      width: 100.w,
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      text_widget(
                        "Business meetup",
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      Spacer(),
                      text_widget("Joined: 23/40",
                          fontSize: 13.6.sp, fontWeight: FontWeight.w300),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      Image.asset("assets/icons/d2.png", height: 1.8.h),
                      SizedBox(width: 2.w),
                      text_widget("10th July, 2024",
                          fontSize: 14.sp, fontWeight: FontWeight.w300),
                      SizedBox(width: 6.w),
                      Image.asset("assets/icons/cl.png", height: 1.8.h),
                      SizedBox(width: 2.w),
                      text_widget("6:30PM",
                          fontSize: 14.sp, fontWeight: FontWeight.w300),
                    ],
                  ),
                  SizedBox(height: 3.h),
                  text_widget("Description",
                      fontSize: 16.sp, fontWeight: FontWeight.w600),
                  SizedBox(height: 0.5.h),
                  text_widget(
                    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled.",
                    fontSize: 14.6.sp,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff8A8A8A),
                  ),
                  SizedBox(height: 3.h),
                  Row(
                    children: [
                      text_widget("Location",
                          fontSize: 16.sp, fontWeight: FontWeight.w600),
                    ],
                  ),
                  SizedBox(height: 0.5.h),
                  Row(
                    children: [
                      Image.asset(
                        "assets/icons/p4.png",
                        height: 1.7.h,
                      ),
                      SizedBox(width: 2.w),
                      text_widget("Chicago, IL United States",
                          fontSize: 15.6.sp, fontWeight: FontWeight.w300),
                    ],
                  ),
                  SizedBox(height: 3.h),
                  Card(
                    elevation: 3,
                    child: SizedBox(
                      height: 25.h,
                      child: MapCard(isPin: true),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  gradientButton("Join Event",
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
            ),
          ],
        )),
      ),
    );
  }
}
