import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musch/config/colors.dart';
import 'package:musch/pages/home/payment_sucess.dart';
import 'package:musch/widgets/custom_button.dart';
import 'package:musch/widgets/text_widget.dart';

import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SubscriptionPlan extends StatefulWidget {
  const SubscriptionPlan({super.key});

  @override
  State<SubscriptionPlan> createState() => _SubscriptionPlanState();
}

int currentPage = 0;

class _SubscriptionPlanState extends State<SubscriptionPlan> {
  List<Widget> cards = [
    CardFb1(
        text: "One time Payment",
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/flutterbricks-public.appspot.com/o/illustrations%2Fundraw_Working_late_re_0c3y%201.png?alt=media&token=7b880917-2390-4043-88e5-5d58a9d70555",
        subtitle: "Lorem Ipsum is simply",
        onPressed: () {}),
    CardFb1(
        text: "Digital Spotlight",
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/flutterbricks-public.appspot.com/o/illustrations%2Fundraw_Designer_re_5v95%201.png?alt=media&token=5d053bd8-d0ea-4635-abb6-52d87539b7ec",
        subtitle: "One Day Boost Packages",
        onPressed: () {}),
  ];

  final double carouselItemMargin = 4;

  int _position = 0;
  late PageController _pageController;

  Widget imageSlider(int position) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (BuildContext context, widget) {
        return Container(
          margin: EdgeInsets.all(carouselItemMargin),
          child: Center(child: widget),
        );
      },
      child: Container(
        child: cards[position],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0, viewportFraction: 0.94);
  }

  List<bool> faqs = [false, false, false, false, false];
  bool status4 = false;
  int current = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
            child: Image.asset(
          "assets/icons/sub.png",
          fit: BoxFit.fill,
        )),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
              bottom: false,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 22.0, vertical: 14),
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
                              color: Colors.white,
                              size: 4.h,
                            )),
                        SizedBox(width: 3.w),
                        text_widget("Subscription Plan",
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 20.sp),
                      ],
                    ),
                    // SizedBox(height: 1.h),
                    SizedBox(height: 6.h),
                    Expanded(
                        child: PageView.builder(
                            controller: _pageController,
                            itemCount: cards.length,
                            onPageChanged: (int position) {
                              setState(() {
                                _position = position;
                                currentPage = position;
                              });
                              setState(() {});
                            },
                            itemBuilder: (BuildContext context, int position) {
                              return imageSlider(position);
                            })),
                    SizedBox(height: 2.h),
                    Center(
                      child: SmoothPageIndicator(
                        controller: _pageController,
                        count: 2,
                        axisDirection: Axis.horizontal,
                        effect: WormEffect(
                            dotHeight: 1.5.h,
                            dotWidth: 1.5.h,
                            dotColor: Color(0xffFFAD85).withOpacity(0.4),
                            activeDotColor: Color(0xff9B8E6D)),
                      ),
                    ),
                    SizedBox(height: 12.h),
                  ],
                ),
              )),
        ),
      ],
    );
  }
}

class CardFb1 extends StatelessWidget {
  final String text;
  final String imageUrl;
  final String subtitle;
  final Function() onPressed;

  const CardFb1(
      {required this.text,
      required this.imageUrl,
      required this.subtitle,
      required this.onPressed,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        // width: 250,
        width: 100.w,
        // height: 230,
        padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
                offset: const Offset(10, 20),
                blurRadius: 10,
                spreadRadius: 0,
                color: Colors.grey.withOpacity(.05)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            text_widget(
              text,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(height: 0.5.h),
            text_widget(subtitle, color: Color(0xff979797), fontSize: 15.sp),
            SizedBox(height: 2.5.h),
            Row(
              // crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                text_widget(
                  "\$4.45",
                  fontSize: 21.sp,
                  fontWeight: FontWeight.bold,
                  color: MyColors.primary,
                ),
                text_widget(
                  "/Package",
                  fontSize: 15.sp,
                  color: Color(0xffB9B9B9),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Divider(
              color: Color(0xff1E1E1E).withOpacity(0.27),
            ),
            SizedBox(height: 3.h),
            ...List.generate(
              txts.length,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 14.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 0.4.h,
                      backgroundColor: Color(0xff8A8A8A),
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: text_widget(txts[index],
                          color: Color(0xff8A8A8A),
                          fontSize: 14.5.sp,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Center(
              child: gradientButton("Choose Plan", ontap: () async {
                Get.to(DonePayment());
              },
                  height: 4.8,
                  font: 13.5,
                  width: 60,
                  isColor: true,
                  clr: MyColors.primary),
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}

List txts = [
  "Lorem Ipsum is simply",
  "Lorem Ipsum is simply",
  "24-Hour Visibility",
  "Instant Visibility",
  "Short-Term Impact",
  "Memorable Impression",
];
