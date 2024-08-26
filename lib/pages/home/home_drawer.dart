import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musch/config/colors.dart';
import 'package:musch/controller/drawer_controller.dart';
import 'package:musch/controller/nav_controller.dart';
import 'package:musch/pages/auth/change_password.dart';
import 'package:musch/pages/auth/reset_password.dart';
import 'package:musch/pages/home/bottom_navigation.dart';
import 'package:musch/pages/home/contact_us.dart';
import 'package:musch/pages/home/notification_screen.dart';
import 'package:musch/pages/home/privacy_policy.dart';
import 'package:musch/pages/home/profile_page.dart';
import 'package:musch/widgets/text_widget.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

import '../../repos/user_repo.dart';
import '../../widgets/avatar_widget.dart';

List titles = [
  "Home",
  "Profile",
  "Notifications",
  "Change Password",
  "Privacy Policy",
  "Contact us",
];

List images = [
  "assets/nav/d2.png",
  "assets/nav/d1.png",
  "assets/nav/d3.png",
  "assets/nav/d4.png",
  "assets/nav/d5.png",
  "assets/nav/d7.png",
];

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({Key? key}) : super(key: key);

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  int currentIndex = -1;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyDrawerController>(
      init: MyDrawerController(),
      builder: (MyDrawerController _) => GestureDetector(
        onTap: () {
          _.closeDrawer();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Color(0xfff2f2f2),
          body: Builder(
            builder: (context) {
              return Stack(
                children: [
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Image.asset(
                        "assets/images/shape2.png",
                        height: 25.h,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  ZoomDrawer(
                      disableDragGesture: true,
                      controller: _.zoomDrawerController,
                      menuScreen: DrawerScreen(
                        setIndex: (index) {
                          setState(
                            () {
                              currentIndex = index;
                              _.open = false;
                            },
                          );
                        },
                      ),
                      mainScreen: Builder(
                        builder: (context) {
                          return currentScreen();
                        },
                      ),
                      borderRadius: 30,
                      // style: DrawerStyle.style2,
                      showShadow: true,
                      angle: -0,
                      slideWidth: 290,
                      shadowLayer1Color: Colors.grey.shade200,
                      // slideHeight: 0,
                      menuBackgroundColor: Colors.transparent),
                  _.open
                      ? Positioned.fill(
                          child: SafeArea(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          _.closeDrawer();
                                        },
                                        child: const Icon(
                                          Icons.arrow_back_ios_new_rounded,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(width: 2.w),
                                      textWidget(
                                        "Setting",
                                        fontSize: 18.sp,
                                      ),
                                      const Spacer(),
                                    ],
                                  ),
                                  SizedBox(height: 3.h),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0,
                                    ),
                                    child: SizedBox(
                                      width: 100,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          AvatarWidget(
                                            height: 80,
                                            width: 80,
                                            backgroundColor: Colors.black,
                                            avatarUrl:
                                                UserRepo().currentUser.avatar,
                                          ),
                                          SizedBox(height: 1.h),
                                          textWidget(
                                            UserRepo().currentUser.name,
                                            color: Colors.black,
                                            maxline: 1,
                                            fontWeight: FontWeight.w600,
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget currentScreen() {
    switch (currentIndex) {
      case 0:
        return NavScreen();
      case 1:
        return ProfilePage(
          isBackShow: true,
          updateParentState: () {},
        );
      case 2:
        return NotificationScreen(
          isDrawer: true,
        );
      case 3:
        return ChangePassword(
          isDrawer: true,
        );
      case 4:
        return PrivacyPolicyPage(
          isDrawer: true,
        );

      case 6:
        return ContactUsPage(
          isDrawer: true,
        );
      default:
        return NavScreen();
    }
  }
}

class DrawerScreen extends StatefulWidget {
  final ValueSetter setIndex;
  const DrawerScreen({Key? key, required this.setIndex}) : super(key: key);

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  List pages = [
    NavScreen(),
    ProfilePage(
      isBackShow: true,
      updateParentState: () {},
    ),
    NotificationScreen(
      isDrawer: true,
    ),
    ResetPassword(),
    PrivacyPolicyPage(isDrawer: true),
    ContactUsPage(isDrawer: true),
  ];
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyDrawerController>(
      init: MyDrawerController(),
      builder: (MyDrawerController _) => Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: 80.h,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Center(
                          child: SizedBox(
                            width: 43.w,
                            child: ListView.builder(
                              // padding: EdgeInsets.zero,
                              itemCount: titles.length,
                              itemBuilder: (context, index) => InkWell(
                                onTap: () {
                                  setState(
                                    () {
                                      _.update();
                                      log(_.active.toString());
                                      Get.to(pages[index]);
                                      _.closeDrawer();
                                      if (_.active != 3 &&
                                          _.active != 5 &&
                                          _.active != 6) {
                                        Get.find<NavController>().isVisible =
                                            true;
                                        Get.find<NavController>().update();
                                      }
                                      ZoomDrawer.of(context)!.close();
                                      _.closeDrawer();
                                    },
                                  );
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 6.0),
                                  child: Container(
                                    height: 5.h,
                                    decoration: BoxDecoration(
                                      color: _.active == index
                                          ? Color(0xffFFFFFF)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox(width: 4.w),
                                        Image.asset(
                                          images[index],
                                          height: 2.h,
                                          color: Colors.black,
                                        ),
                                        SizedBox(width: 4.w),
                                        Text(
                                          titles[index],
                                          style: GoogleFonts.plusJakartaSans(
                                            color: MyColors.black,
                                            fontSize: 14.sp,
                                            fontWeight: _.active == index
                                                ? FontWeight.w600
                                                : FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
