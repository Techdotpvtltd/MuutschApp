import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:musch/config/colors.dart';
import 'package:musch/pages/home/friend_view.dart';
import 'package:musch/widgets/text_field.dart';
import 'package:musch/widgets/text_widget.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AllFriends extends StatelessWidget {
  const AllFriends({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 18.h,
                color: Color(0xffBD9691),
              ),
              Expanded(
                  child: Container(
                color: Color(0xfff2f2f2),
              ))
            ],
          ),
          Positioned.fill(
            child: SafeArea(
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18.0, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: Icon(Remix.arrow_left_s_line,
                                    color: Colors.white, size: 4.h)),
                            SizedBox(width: 2.w),
                            text_widget("Friends",
                                color: Colors.white, fontSize: 18.sp),
                          ],
                        ),
                        SizedBox(height: 3.h),
                        textFieldWithPrefixSuffuxIconAndHintText(
                          "Search ",
                          // controller: _.password,
                          fillColor: Colors.white,
                          isPrefix: true,
                          prefixIcon: "assets/nav/s1.png",
                          mainTxtColor: Colors.black,
                          radius: 12,
                          bColor: Colors.transparent,
                        ),
                        SizedBox(height: 5.h),
                        text_widget("Active",
                            fontSize: 16.5.sp, fontWeight: FontWeight.w500),
                        SizedBox(height: 1.5.h),
                        SingleChildScrollView(
                          child: Row(
                            children: [
                              InkWell(
                                  onTap: () {
                                    Get.to(FriendView(
                                        isFriend: false, isChat: true));
                                  },
                                  child: Stack(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: MyColors.primary,
                                        radius: 2.8.h,
                                        backgroundImage: AssetImage(
                                            "assets/images/girl.png"),
                                      ),
                                      Positioned.fill(
                                          child: Align(
                                        alignment: Alignment.bottomRight,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 5.0),
                                          child: CircleAvatar(
                                            backgroundColor: Color(0xff7ED424),
                                            radius: 0.5.h,
                                          ),
                                        ),
                                      ))
                                    ],
                                  )),
                              SizedBox(width: 3.w),
                              InkWell(
                                onTap: () {
                                  Get.to(FriendView(
                                      isFriend: false, isChat: true));
                                },
                                child: Stack(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: MyColors.primary,
                                      radius: 2.8.h,
                                      backgroundImage:
                                          AssetImage("assets/images/girl.png"),
                                    ),
                                    Positioned.fill(
                                        child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 5.0),
                                        child: CircleAvatar(
                                          backgroundColor: Color(0xff7ED424),
                                          radius: 0.5.h,
                                        ),
                                      ),
                                    ))
                                  ],
                                ),
                              ),
                              SizedBox(width: 3.w),
                              InkWell(
                                onTap: () {
                                  Get.to(FriendView(
                                      isFriend: false, isChat: true));
                                },
                                child: Stack(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: MyColors.primary,
                                      radius: 2.8.h,
                                      backgroundImage:
                                          AssetImage("assets/images/girl.png"),
                                    ),
                                    Positioned.fill(
                                        child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 5.0),
                                        child: CircleAvatar(
                                          backgroundColor: Color(0xff7ED424),
                                          radius: 0.5.h,
                                        ),
                                      ),
                                    ))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            text_widget("Friends",
                                fontSize: 16.5.sp, fontWeight: FontWeight.w500),
                            SizedBox(width: 3.w),
                            Container(
                              decoration: BoxDecoration(
                                color: MyColors.primary,
                                borderRadius: BorderRadius.circular(36),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18.0, vertical: 6),
                                child: text_widget(
                                  "200",
                                  color: Colors.white,
                                  fontSize: 15.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 3.h),
                        ...List.generate(
                          6,
                          (index) => InkWell(
                            onTap: () {
                              Get.to(FriendView(isFriend: false, isChat: true));
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12)),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: MyColors.primary,
                                      radius: 2.4.h,
                                      backgroundImage:
                                          AssetImage("assets/images/girl.png"),
                                    ),
                                    title: text_widget("Jessica Parker",
                                        fontSize: 16.5.sp,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
