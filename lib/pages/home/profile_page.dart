import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musch/config/colors.dart';
import 'package:musch/controller/drawer_controller.dart';
import 'package:musch/pages/auth/change_password.dart';
import 'package:musch/pages/auth/login_page.dart';
import 'package:musch/pages/home/my_eventss.dart';
import 'package:musch/pages/home/all_friends.dart';
import 'package:musch/pages/home/bottom_navigation.dart';
import 'package:musch/pages/home/edit_profile.dart';
import 'package:musch/pages/home/home_drawer.dart';
import 'package:musch/pages/home/subscription_plan.dart';
import 'package:musch/widgets/custom_button.dart';
import 'package:musch/widgets/text_widget.dart';

import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ProfilePage extends StatefulWidget {
  final bool isDrawer;
  final VoidCallback updateParentState; // Define callback
  const ProfilePage(
      {Key? key, required this.isDrawer, required this.updateParentState})
      : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<bool> faqs = [false, false, false, false, false];
  bool status4 = false;
  // int current = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
            child: Image.asset(
          "assets/nav/dp.png",
          // height: 20.h,
          fit: BoxFit.fill,
        )),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 22.0, vertical: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          InkWell(
                              onTap: () {
                                if (widget.isDrawer) {
                                  setState(() {
                                    current = 0;
                                  });
                                  Get.find<NavScreenController>()
                                      .controller
                                      .jumpToTab(current);
                                  Get.find<NavScreenController>().update();
                                  widget.updateParentState();
                                  setState(() {});
                                } else {
                                  Get.find<MyDrawerController>().closeDrawer();
                                  Get.to(HomeDrawer());
                                }
                              },
                              child: Icon(
                                Remix.arrow_left_s_line,
                                color: Colors.black,
                                size: 3.h,
                              )),
                          SizedBox(width: 3.w),
                          text_widget("Profile",
                              fontWeight: FontWeight.w600, fontSize: 18.sp),
                        ],
                      ),
                      // SizedBox(height: 1.h),
                      SizedBox(height: 5.h),

                      InkWell(
                        onTap: () {
                          Get.to(EditProfile());
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: MyColors.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 3.5.h,
                                  backgroundColor: MyColors.background,
                                  backgroundImage:
                                      AssetImage("assets/images/girl.png"),
                                ),
                                SizedBox(width: 4.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      text_widget("Arslan Goursi",
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                      SizedBox(height: 0.5.h),
                                      text_widget(
                                        "arslangoursi123@gmail.com",
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 4.h),

                      InkWell(
                        onTap: () {
                          Get.to(ChangePassword(isDrawer: false));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: ListTile(
                              leading: Image.asset(
                                "assets/icons/lock.png",
                                height: 2.8.h,
                              ),
                              title: text_widget("Change password",
                                  fontSize: 15.2.sp),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      InkWell(
                          onTap: () {
                            Get.to(MyEvents());
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: ListTile(
                                leading: Image.asset(
                                  "assets/icons/e1.png",
                                  height: 2.8.h,
                                ),
                                title:
                                    text_widget("My Event", fontSize: 15.2.sp),
                              ),
                            ),
                          )),
                      SizedBox(height: 2.h),
                      InkWell(
                        onTap: () {
                          Get.to(AllFriends());
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: ListTile(
                              leading: Image.asset(
                                "assets/icons/fr.png",
                                height: 2.8.h,
                              ),
                              title:
                                  text_widget("My Friends", fontSize: 15.2.sp),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      InkWell(
                        onTap: () {
                          Get.to(SubscriptionPlan());
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: ListTile(
                              leading: Image.asset(
                                "assets/icons/sub1.png",
                                height: 2.8.h,
                              ),
                              title: text_widget("Subscription",
                                  fontSize: 15.2.sp),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5.h),
                      gradientButton("Log Out",
                          font: 17, txtColor: MyColors.white, ontap: () {
                        Get.offAll(LoginPage());
                        // _.loginUser();
                      },
                          width: 90,
                          height: 6.6,
                          isColor: true,
                          clr: MyColors.primary),
                    ],
                  ),
                )),
          ),
        ),
      ],
    );
  }
}
