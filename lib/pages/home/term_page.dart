import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musch/config/colors.dart';
import 'package:musch/controller/drawer_controller.dart';
import 'package:musch/pages/home/home_drawer.dart';
import 'package:musch/widgets/text_widget.dart';

import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class TermPage extends StatefulWidget {
  final bool isDrawer;
  const TermPage({super.key, required this.isDrawer});

  @override
  State<TermPage> createState() => _TermPageState();
}

class _TermPageState extends State<TermPage> {
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
                        text_widget("Terms and condition",
                            color: Colors.black, fontSize: 18.sp),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    text_widget(
                        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries",
                        color: Color(0xff000000).withOpacity(0.46),
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400),
                    SizedBox(height: 2.h),
                    text_widget(
                        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries",
                        color: Color(0xff000000).withOpacity(0.46),
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400),
                    SizedBox(height: 3.h),
                    Row(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 0.5.h,
                          backgroundColor: MyColors.primary,
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: text_widget(
                              "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                              color: Color(0xff000000).withOpacity(0.46),
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 0.5.h,
                          backgroundColor: MyColors.primary,
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: text_widget(
                              "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                              color: Color(0xff000000).withOpacity(0.46),
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 0.5.h,
                          backgroundColor: MyColors.primary,
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: text_widget(
                              "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                              color: Color(0xff000000).withOpacity(0.46),
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 0.5.h,
                          backgroundColor: MyColors.primary,
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: text_widget(
                              "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                              color: Color(0xff000000).withOpacity(0.46),
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 0.5.h,
                          backgroundColor: MyColors.primary,
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: text_widget(
                              "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                              color: Color(0xff000000).withOpacity(0.46),
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 0.5.h,
                          backgroundColor: MyColors.primary,
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: text_widget(
                              "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                              color: Color(0xff000000).withOpacity(0.46),
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
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
