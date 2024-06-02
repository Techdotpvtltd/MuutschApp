import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musch/pages/home/home_drawer.dart';
import 'package:musch/widgets/text_widget.dart';

import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../controller/drawer_controller.dart';

class PrivacyPolicyPage extends StatefulWidget {
  final bool isDrawer;
  const PrivacyPolicyPage({super.key, required this.isDrawer});

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
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
                        textWidget("Privacy Policy",
                            color: Colors.black, fontSize: 18.sp),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    textWidget(
                        "A dwarf who brings a standard along with him to measure his own size, take my word,",
                        color: Color(0xff000000).withOpacity(0.46),
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400),
                    SizedBox(height: 2.h),
                    textWidget(
                        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. ",
                        color: Color(0xff000000).withOpacity(0.46),
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400),
                    SizedBox(height: 2.h),
                    textWidget(
                        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type.",
                        color: Color(0xff000000).withOpacity(0.46),
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400),
                    SizedBox(height: 2.h),
                    textWidget(
                        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. ",
                        color: Color(0xff000000).withOpacity(0.46),
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400)
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
