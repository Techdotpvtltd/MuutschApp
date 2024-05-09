import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musch/config/colors.dart';
import 'package:musch/controller/drawer_controller.dart';
import 'package:musch/pages/home/home_drawer.dart';
import 'package:musch/widgets/text_field.dart';
import 'package:musch/widgets/text_widget.dart';

import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FaqScreen extends StatefulWidget {
  final bool isDrawer;
  const FaqScreen({super.key, required this.isDrawer});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  List<bool> faqs = [false, false, false, false, false];
  bool status4 = false;
  int current = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      body: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 14),
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
                        child: Icon(
                          Remix.arrow_left_s_line,
                          color: Colors.black,
                          size: 4.h,
                        )),
                    SizedBox(width: 3.w),
                    text_widget("FAQ’S",
                        fontWeight: FontWeight.w600, fontSize: 20.sp),
                  ],
                ),
                // SizedBox(height: 1.h),
                SizedBox(height: 2.h),
                text_widget(
                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown",
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff868686),
                ),
                SizedBox(height: 2.h),
                textFieldWithPrefixSuffuxIconAndHintText(
                  "Search  Event",
                  // controller: _.password,
                  fillColor: Colors.white,
                  mainTxtColor: Colors.black,
                  radius: 12,
                  bColor: Colors.transparent,
                  prefixIcon: "assets/nav/s1.png",
                  isPrefix: true,
                ),
                SizedBox(height: 2.h),

                Expanded(
                    child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...List.generate(5, (index) => faqWidget(index))
                    ],
                  ),
                ))
              ],
            ),
          )),
    );
  }

  Widget faqWidget(index) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Container(
          decoration: BoxDecoration(
              color: faqs[index] ? MyColors.primary : Colors.white,
              borderRadius: BorderRadius.circular(12)),
          child: Theme(
            data: ThemeData().copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
                childrenPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                // backgroundColor: MyColors.primary,
                // collapsedBackgroundColor: Colors.white,
                tilePadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                // shape: RoundedRectangleBorder(
                //     borderRadius:
                //         BorderRadius.circular(12)),
                // collapsedShape: RoundedRectangleBorder(
                //     borderRadius:
                //         BorderRadius.circular(12)),
                onExpansionChanged: (value) {
                  setState(() {
                    faqs[index] = value;
                  });
                },
                title: text_widget("Lorem Ipsum is simply dummy text",
                    fontWeight: FontWeight.w500,
                    color: faqs[index] == true ? Colors.white : MyColors.black,
                    fontSize: 15.5.sp),
                trailing: faqs[index] == true
                    ? Icon(Remix.arrow_up_s_line, color: MyColors.white)
                    : Icon(Remix.arrow_down_s_line, color: MyColors.black),
                children: [
                  text_widget(
                      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled ",
                      color: MyColors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w400,
                      fontSize: 15.sp),
                  SizedBox(height: 2.h),
                ]),
          ),
        ));
  }
}
