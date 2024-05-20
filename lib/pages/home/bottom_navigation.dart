import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musch/config/colors.dart';
import 'package:musch/pages/home/chat/inbox_page.dart';
import 'package:musch/pages/home/home_page.dart';
import 'package:musch/pages/home/map_view.dart';
import 'package:musch/pages/home/profile_page.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

int current = 0;

class NavScreen extends StatefulWidget {
  const NavScreen({super.key});

  @override
  State<NavScreen> createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  void updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NavScreenController>(
        init: NavScreenController(),
        builder: (NavScreenController _) => Scaffold(
              body: PersistentTabView(
                context,
                controller: _.controller,
                screens: [
                  HomePage(),
                  MapSample(updateParentState: updateState),
                  InboxPage(updateParentState: updateState),
                  ProfilePage(isDrawer: true, updateParentState: updateState),
                ],

                items: [
                  PersistentBottomNavBarItem(
                    // contentPadding: 10,
                    icon: current == 0
                        ? Image.asset(
                            "assets/nav/wn1.png",
                            height: 2.h,
                            width: 3.3.h,
                          )
                        : Image.asset(
                            "assets/nav/home.png",
                            height: 2.h,
                            width: 3.3.h,
                          ),

                    activeColorPrimary: MyColors.white,
                    // iconSize: 2.h,
                    inactiveColorSecondary: Color(0xff9CA3AF),
                    // iconSize: 4.h,

                    textStyle: TextStyle(
                        fontSize: 13.5.sp,
                        fontFamily: 'Poppins',
                        color: Colors.black,
                        fontWeight: FontWeight.w500),

                    inactiveColorPrimary: Color(0xff9CA3AF),
                    // inactiveColorSecondary: Colors.purple,
                  ),
                  PersistentBottomNavBarItem(
                    // contentPadding: 10,
                    icon: current == 1
                        ? Image.asset(
                            "assets/nav/wn2.png",
                            height: 2.h,
                            width: 3.3.h,
                          )
                        : Image.asset(
                            "assets/nav/search.png",
                            height: 2.h,
                            width: 3.3.h,
                          ),

                    activeColorPrimary: MyColors.white,
                    // iconSize: 2.h,
                    inactiveColorSecondary: Color(0xff9CA3AF),
                    // iconSize: 4.h,

                    textStyle: TextStyle(
                        fontSize: 13.5.sp,
                        fontFamily: 'Poppins',
                        color: Colors.black,
                        fontWeight: FontWeight.w500),

                    inactiveColorPrimary: Color(0xff9CA3AF),
                    // inactiveColorSecondary: Colors.purple,
                  ),
                  PersistentBottomNavBarItem(
                    // contentPadding: 10,
                    icon: current == 2
                        ? Image.asset(
                            "assets/nav/wn3.png",
                            height: 2.h,
                            width: 3.3.h,
                          )
                        : Image.asset(
                            "assets/nav/n3.png",
                            height: 2.h,
                            width: 3.3.h,
                          ),

                    activeColorPrimary: MyColors.white,
                    // iconSize: 2.h,
                    inactiveColorSecondary: Color(0xff9CA3AF),
                    // iconSize: 4.h,

                    textStyle: TextStyle(
                        fontSize: 13.5.sp,
                        fontFamily: 'Poppins',
                        color: Colors.black,
                        fontWeight: FontWeight.w500),

                    inactiveColorPrimary: Color(0xff9CA3AF),
                    // inactiveColorSecondary: Colors.purple,
                  ),
                  PersistentBottomNavBarItem(
                    // contentPadding: 10,
                    icon: current == 3
                        ? Image.asset(
                            "assets/nav/wn4.png",
                            height: 2.h,
                            width: 3.3.h,
                          )
                        : Image.asset(
                            "assets/nav/n4.png",
                            height: 2.h,
                            width: 3.3.h,
                          ),

                    activeColorPrimary: MyColors.white,
                    inactiveColorSecondary: Color(0xff9CA3AF),

                    textStyle: TextStyle(
                        fontSize: 13.5.sp,
                        fontFamily: 'Poppins',
                        color: Colors.black,
                        fontWeight: FontWeight.w500),

                    inactiveColorPrimary: Color(0xff9CA3AF),
                    // inactiveColorSecondary: Colors.purple,
                  ),
                ],
                onItemSelected: (value) {
                  setState(() {
                    current = value;
                  });
                  _.update();
                  log(current.toString());
                },
                confineInSafeArea: true,
                backgroundColor: MyColors.primary,
                handleAndroidBackButtonPress: true,
                resizeToAvoidBottomInset: false,
                stateManagement: true,
                // navBarHeight: 10.h,
                hideNavigationBarWhenKeyboardShows: true,
                margin: EdgeInsets.only(bottom: 0.0),
                popActionScreens: PopActionScreensType.all,
                // bottomScreenMargin: 16.h,
                padding: NavBarPadding.only(left: 8, right: 8, top: 0.2.h),
                decoration: NavBarDecoration(
                    colorBehindNavBar: Colors.white,
                    borderRadius: BorderRadius.circular(0.0)),
                popAllScreensOnTapOfSelectedTab: true,
                itemAnimationProperties: ItemAnimationProperties(
                  duration: Duration(milliseconds: 400),
                  curve: Curves.ease,
                ),
                screenTransitionAnimation: ScreenTransitionAnimation(
                  animateTabTransition: true,
                  curve: Curves.ease,
                  duration: Duration(milliseconds: 200),
                ),
                navBarStyle: NavBarStyle.style3,
              ),
            ));
  }
}

class NavScreenController extends GetxController {
  late PersistentTabController controller;
  @override
  void onInit() {
    super.onInit();
    controller = PersistentTabController(initialIndex: current);
    update();
  }
}
