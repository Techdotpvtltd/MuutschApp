import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musch/config/colors.dart';
import 'package:musch/pages/home/home_drawer.dart';
import 'package:musch/widgets/custom_button.dart';
import 'package:musch/widgets/text_widget.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class InterestPage extends StatefulWidget {
  const InterestPage({super.key});

  @override
  State<InterestPage> createState() => _InterestPageState();
}

class _InterestPageState extends State<InterestPage> {
  List txt1 = [
    "True Love",
    "Luxury Lifestyle",
    "Active Lifestyle",
    "Flexible Schedule",
    "Emotional connection",
    "Emotional connection",
    "All Ethicalities",
    "Attentive",
    "Discretion",
    "Long term",
    "Fine Dining",
    "Investor",
    "Marriage minded",
  ];
  List current2 = [];
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
            child: Align(
          alignment: Alignment.bottomRight,
          child: Image.asset(
            "assets/images/shape.png",
            height: 25.h,
            fit: BoxFit.fill,
          ),
        )),
        Positioned.fill(
            child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12.0, horizontal: 22),
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
                              size: 3.h,
                            ))
                      ],
                    ),
                    Center(
                        child: Image.asset(
                      "assets/images/logo.png",
                      height: 10.h,
                    )),
                    SizedBox(height: 4.h),
                    text_widget("Your Interest",
                        fontSize: 21.sp, fontWeight: FontWeight.w600),
                    SizedBox(height: 0.4.h),
                    text_widget(
                        "Allow us to access your location while you’re using the app so we can help you find and meet members.",
                        fontSize: 15.sp,
                        color: Color(0xff8C8C8C)),
                    SizedBox(height: 4.h),
                    Wrap(
                      children: [
                        ...List.generate(
                            txt1.length,
                            (index) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0, vertical: 4),
                                  child: InkWell(
                                    onTap: () {
                                      if (current2.contains(index)) {
                                        setState(() {
                                          current2.remove(index);
                                        });
                                      } else {
                                        setState(() {
                                          current2.add(index);
                                        });
                                      }
                                    },
                                    child: Chip(
                                      backgroundColor: current2.contains(index)
                                          ? MyColors.primary
                                          : Colors.transparent,

                                      label: text_widget(txt1[index],
                                          fontSize: 14.sp,
                                          color: current2.contains(index)
                                              ? Colors.white
                                              : MyColors.primary,
                                          fontWeight: FontWeight.w500),

                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(14)),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 18, vertical: 5),
                                      //  backgroundColor: ,
                                      side:
                                          BorderSide(color: Colors.transparent),
                                    ),
                                  ),
                                ))
                      ],
                    ),
                    SizedBox(height: 5.h),
                    gradientButton("Next", font: 16, txtColor: MyColors.white,
                        ontap: () {
                      Get.to(HomeDrawer());
                    },
                        width: 90,
                        height: 6.6,
                        isColor: true,
                        clr: MyColors.primary),
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
