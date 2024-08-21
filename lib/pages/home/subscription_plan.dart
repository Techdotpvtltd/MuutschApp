import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:musch/config/colors.dart';
import 'package:musch/widgets/custom_button.dart';
import 'package:musch/widgets/text_widget.dart';

import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../blocs/subscription/subscription_bloc.dart';
import '../../blocs/subscription/subscription_event.dart';
import '../../blocs/subscription/subscription_state.dart';
import '../../manager/app_manager.dart';
import '../../repos/subscription/subscription_repo.dart';
import '../../utils/dialogs/dialogs.dart';

class SubscriptionPlan extends StatefulWidget {
  const SubscriptionPlan({super.key});

  @override
  State<SubscriptionPlan> createState() => _SubscriptionPlanState();
}

int currentPage = 0;

class _SubscriptionPlanState extends State<SubscriptionPlan> {
  String activeSubscriptionId = AppManager().isActiveSubscription
      ? SubscriptionRepo().lastSubscription?.productId ?? ""
      : "";
  List<ProductDetails> productDetails = [];
  bool isLoading = false;

  void triggerBuySubscriptionEvent(ProductDetails product) {
    context
        .read<SubscriptionBloc>()
        .add(SubscriptionEventBuySubscription(productDetails: product));
  }

  void triggerGetProductsEvent() {
    context.read<SubscriptionBloc>().add(SubscriptionEventReady());
  }

  final double carouselItemMargin = 4;

  int position = 0;
  late PageController _pageController;
  bool isSubscribing = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0, viewportFraction: 0.94);
    triggerGetProductsEvent();
  }

  List<bool> faqs = [false, false, false, false, false];
  bool status4 = false;
  int current = 0;
  @override
  Widget build(BuildContext context) {
    return BlocListener<SubscriptionBloc, SubscriptionState>(
      listener: (context, state) {
        if (state is SubscriptionStateGettingProducts ||
            state is SubscriptionStateGotProducts) {
          setState(() {
            isLoading = state.isLoading;
          });

          if (state is SubscriptionStateGotProducts) {
            productDetails = state.products;
            productDetails.sort((a, b) => a.rawPrice.compareTo(b.rawPrice));
            activeSubscriptionId = AppManager().isActiveSubscription
                ? SubscriptionRepo().lastSubscription?.productId ?? ""
                : "";
            setState(() {});
          }
        }

        if (state is SubscriptionStateReady ||
            state is SubscriptionStateFailure ||
            state is SubscriptionStateStoreStatus ||
            state is SubscriptionStatePurchased ||
            state is SubscriptionStatePurchaseFailure) {
          setState(() {
            isSubscribing = state.isLoading;
          });

          if (state is SubscriptionStateFailure) {
            debugPrint(state.exception.message);
            CustomDialogs().errorBox(message: state.exception.message);
          }

          if (state is SubscriptionStatePurchaseFailure) {
            debugPrint(state.exception.message);
            CustomDialogs().errorBox(message: state.exception.message);
          }

          if (state is SubscriptionStatePurchased) {
            setState(() {
              activeSubscriptionId = AppManager().isActiveSubscription
                  ? SubscriptionRepo().lastSubscription?.productId ?? ""
                  : "";
            });

            AppManager().isActiveSubscription = true;
            CustomDialogs().successBox(
              message:
                  "Thank you for subscribing! Your subscription is now active. Enjoy all the benefits and features available to you.",
              positiveTitle: "Go to Home",
              onPositivePressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            );
          }
        }
      },
      child: Stack(
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
                        textWidget(
                          "Subscription Plan",
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 20.sp,
                        ),
                      ],
                    ),
                    // SizedBox(height: 1.h),
                    SizedBox(height: 6.h),
                    Expanded(
                      child: isLoading
                          ? Center(child: CircularProgressIndicator())
                          : PageView.builder(
                              controller: _pageController,
                              itemCount: productDetails.length,
                              onPageChanged: (int position) {
                                setState(() {
                                  position = position;
                                  currentPage = position;
                                });
                                setState(() {});
                              },
                              itemBuilder:
                                  (BuildContext context, int position) {
                                final product = productDetails[position];
                                return AnimatedBuilder(
                                  animation: _pageController,
                                  builder: (BuildContext context, widget) {
                                    return Container(
                                      margin:
                                          EdgeInsets.all(carouselItemMargin),
                                      child: Center(child: widget),
                                    );
                                  },
                                  child: Container(
                                    child: CardFb1(
                                      text: product.title,
                                      showButton: !isSubscribing,
                                      imageUrl: "",
                                      subtitle: product.description,
                                      onPressed: () {
                                        triggerBuySubscriptionEvent(product);
                                      },
                                      price: product.price,
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                    if (productDetails.length > 1) SizedBox(height: 2.h),
                    if (productDetails.length > 1)
                      Center(
                        child: SmoothPageIndicator(
                          controller: _pageController,
                          count: productDetails.length,
                          axisDirection: Axis.horizontal,
                          effect: WormEffect(
                            dotHeight: 1.5.h,
                            dotWidth: 1.5.h,
                            dotColor: Color(0xffFFAD85).withOpacity(0.4),
                            activeDotColor: Color(0xff9B8E6D),
                          ),
                        ),
                      ),
                    SizedBox(height: 12.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CardFb1 extends StatelessWidget {
  final String text;
  final String imageUrl;
  final String subtitle;
  final Function() onPressed;
  final String price;
  final bool showButton;

  const CardFb1(
      {required this.text,
      required this.imageUrl,
      required this.subtitle,
      required this.onPressed,
      required this.showButton,
      Key? key,
      required this.price})
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
            textWidget(
              text,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(height: 0.5.h),
            textWidget(subtitle, color: Color(0xff979797), fontSize: 15.sp),
            SizedBox(height: 2.5.h),
            Row(
              // crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                textWidget(
                  price,
                  fontSize: 21.sp,
                  fontWeight: FontWeight.bold,
                  color: MyColors.primary,
                ),
                textWidget(
                  "/Month",
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
                      child: textWidget(txts[index],
                          color: Color(0xff8A8A8A),
                          fontSize: 14.5.sp,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 2.h),
            if (showButton)
              Center(
                child: gradientButton(
                  AppManager().isActiveSubscription ? "Actived" : "Choose Plan",
                  ontap: AppManager().isActiveSubscription ? () {} : onPressed,
                  height: 4.8,
                  font: 16.5,
                  width: 60,
                  isColor: true,
                  clr: AppManager().isActiveSubscription
                      ? Colors.green
                      : MyColors.primary,
                ),
              ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}

List txts = [
  "Unlimited Friend requests per Month",
  "Create and Join Events",
  "Find friends worldwide",
  "Find Events worldwide",
  "See Events time and date.",
];
