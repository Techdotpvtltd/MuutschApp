import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musch/config/colors.dart';
import 'package:musch/widgets/text_widget.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class DonePayment extends StatefulWidget {
  const DonePayment({super.key});

  @override
  State<DonePayment> createState() => _DonePaymentState();
}

int currentPage = 0;

class _DonePaymentState extends State<DonePayment> {
  List<bool> faqs = [false, false, false, false, false];
  bool status4 = false;
  int current = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
            child: Image.asset(
          "assets/images/done.png",
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
                        text_widget("Payment Success",
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 20.sp),
                      ],
                    ),
                    // SizedBox(height: 1.h),
                    SizedBox(height: 16.h),
                    Stack(
                      children: [
                        Center(
                          child: Container(
                            width: 85.w,
                            margin: EdgeInsets.only(
                              top: 3.6.h,
                              left: 3.w,
                            ),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 22.0, vertical: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 6.h),
                                  Center(
                                    child: text_widget(
                                      "Great",
                                      color: MyColors.primary,
                                      fontSize: 15.8.sp,
                                    ),
                                  ),
                                  Center(
                                    child: text_widget(
                                      "Payment Success",
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 3.h),
                                  Row(
                                    children: [
                                      text_widget("Payment Mode",
                                          fontSize: 15.sp,
                                          color: Color(0xff757575),
                                          fontWeight: FontWeight.w400),
                                      Spacer(),
                                      text_widget(
                                        "Apple Pay",
                                        fontSize: 15.sp,
                                        color: MyColors.black,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 2.h),
                                  Row(
                                    children: [
                                      text_widget("Total Amount",
                                          fontSize: 15.sp,
                                          color: Color(0xff757575),
                                          fontWeight: FontWeight.w400),
                                      Spacer(),
                                      text_widget(
                                        "\$23.00",
                                        fontSize: 15.sp,
                                        color: MyColors.black,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 2.h),
                                  Row(
                                    children: [
                                      text_widget("Pay Date",
                                          fontSize: 15.sp,
                                          color: Color(0xff757575),
                                          fontWeight: FontWeight.w400),
                                      Spacer(),
                                      text_widget(
                                        "Apr 10, 2023",
                                        fontSize: 15.sp,
                                        color: MyColors.black,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 2.h),
                                  Row(
                                    children: [
                                      text_widget("Pay Time",
                                          fontSize: 15.sp,
                                          color: Color(0xff757575),
                                          fontWeight: FontWeight.w400),
                                      Spacer(),
                                      text_widget(
                                        "Pay Time",
                                        fontSize: 15.sp,
                                        color: MyColors.black,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 3.h),
                                  Divider(
                                    color: Color(0xffD9D9D9),
                                  ),
                                  SizedBox(height: 3.h),
                                  Center(
                                    child: text_widget(
                                      "Total Pay",
                                      fontSize: 14.5.sp,
                                      color: Color(0xff757575),
                                    ),
                                  ),
                                  SizedBox(height: 0.4.h),
                                  Center(
                                    child: text_widget("\$23.00",
                                        color: MyColors.primary,
                                        fontSize: 18.6.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        //  Positioned.fill(child: Container()),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Image.asset(
                            "assets/icons/done.png",
                            height: 8.h,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
        ),
      ],
    );
  }
}
