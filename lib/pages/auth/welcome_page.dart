import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musch/pages/auth/login_page.dart';
import 'package:musch/widgets/onTap.dart';
import 'package:musch/widgets/text_widget.dart';

import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  PageController pageController = PageController();
  int selectPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: PageView.builder(
              itemBuilder: (context, index) => Stack(
                children: [
                  Positioned.fill(
                      child: Image.asset(
                    "assets/images/w1.png",
                    fit: BoxFit.fill,
                    height: Get.height,
                    width: Get.width,
                  )),
                  Positioned.fill(
                      child: Image.asset(
                    "assets/images/w2.png",
                    fit: BoxFit.fill,
                    height: Get.height,
                    width: Get.width,
                  )),
                  Align(
                    child: SafeArea(
                      child: Column(
                        children: [
                          Spacer(),
                          SafeArea(
                            child: Container(
                              width: 90.w,
                              // height: 15.h,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    Color(0xffABA159).withOpacity(0.3),
                                    Color(0xff9C8D6E),
                                  ]),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(height: 1.h),
                                    text_widget(
                                        "Explore More About\nEvents And People",
                                        fontSize: 19.sp,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        textAlign: TextAlign.center),
                                    SizedBox(height: 1.h),
                                    text_widget(
                                        "We can increase your sales traffic in one click and get lots of promos that you can get for new members. We can increase your sales traffic in one click.",
                                        fontSize: 13.sp,
                                        color: Colors.white,
                                        textAlign: TextAlign.center),
                                    SizedBox(height: 1.h),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              itemCount: 4,
              onPageChanged: (page) {
                setState(() {
                  selectPage = page;
                });
              },
              controller: pageController,
            ),
          ),
          Positioned.fill(
              child: Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Row(
                children: [
                  text_widget(
                    "Next",
                    color: Colors.transparent,
                  ),
                  SizedBox(width: 2.w),
                  Icon(
                    Remix.arrow_right_line,
                    color: Colors.transparent,
                  ),
                  SizedBox(width: 5.w),
                  Spacer(),
                  SmoothPageIndicator(
                    controller: pageController,
                    count: 4,
                    axisDirection: Axis.horizontal,
                    effect: WormEffect(
                        dotHeight: 1.h,
                        dotWidth: 1.h,
                        dotColor: Colors.white.withOpacity(0.4),
                        activeDotColor: Colors.white),
                  ),
                  Spacer(),
                  onPress(
                    ontap: () {
                      if (selectPage == 3) {
                        Get.to(LoginPage());
                      } else {
                        setState(() {
                          selectPage++;
                        });
                        pageController.animateToPage(selectPage,
                            curve: Curves.linear,
                            duration: Duration(milliseconds: 300));

                        log(selectPage.toString());
                      }
                    },
                    child: Row(
                      children: [
                        text_widget(
                          "Next",
                          color: Colors.white,
                        ),
                        SizedBox(width: 2.w),
                        Icon(
                          Remix.arrow_right_line,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 5.w),
                ],
              ),
            ),
          )),
          Positioned.fill(
              child: SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: selectPage != 3
                  ? InkWell(
                      onTap: () {
                        Get.to(LoginPage());
                      },
                      child: Row(
                        children: [
                          Spacer(),
                          text_widget(
                            "Skip",
                            color: Colors.white,
                          ),
                          SizedBox(width: 2.w),
                          Icon(
                            Remix.arrow_right_line,
                            color: Colors.white,
                          ),
                          SizedBox(width: 3.w),
                        ],
                      ),
                    )
                  : SizedBox(),
            ),
          ))
        ],
      ),
    );
  }
}
