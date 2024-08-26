import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musch/config/colors.dart';
import 'package:musch/pages/home/chat/inbox_page.dart';
import 'package:musch/pages/home/home_page.dart';
import 'package:musch/pages/home/map_view.dart';
import 'package:musch/pages/home/profile_page.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
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
      builder: (NavScreenController _) => PersistentTabView(
        controller: _.controller,
        navBarBuilder: (navBarConfig) => Style4BottomNavBar(
          navBarConfig: navBarConfig,
          navBarDecoration: NavBarDecoration(
            color: MyColors.primary,
            padding: EdgeInsets.only(left: 8, right: 8, top: 0.2.h),
            borderRadius: BorderRadius.circular(0.0),
          ),
        ),
        tabs: [
          PersistentTabConfig(
            screen: HomePage(),
            item: ItemConfig(
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
              activeForegroundColor: MyColors.white,
              inactiveBackgroundColor: Color(0xff9CA3AF),
              textStyle: TextStyle(
                  fontSize: 13.5.sp,
                  fontFamily: 'Poppins',
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
              inactiveForegroundColor: Color(0xff9CA3AF),
            ),
          ),
          PersistentTabConfig(
            screen: MapSample(updateParentState: updateState),
            item: ItemConfig(
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
              activeForegroundColor: MyColors.white,
              inactiveBackgroundColor: Color(0xff9CA3AF),
              textStyle: TextStyle(
                  fontSize: 13.5.sp,
                  fontFamily: 'Poppins',
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
              inactiveForegroundColor: Color(0xff9CA3AF),
            ),
          ),
          PersistentTabConfig(
            screen: InboxPage(updateParentState: updateState),
            item: ItemConfig(
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
              activeForegroundColor: MyColors.white,
              inactiveBackgroundColor: Color(0xff9CA3AF),
              textStyle: TextStyle(
                  fontSize: 13.5.sp,
                  fontFamily: 'Poppins',
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
              inactiveForegroundColor: Color(0xff9CA3AF),
            ),
          ),
          PersistentTabConfig(
            screen:
                ProfilePage(isBackShow: false, updateParentState: updateState),
            item: ItemConfig(
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
              activeForegroundColor: MyColors.white,
              inactiveBackgroundColor: Color(0xff9CA3AF),
              textStyle: TextStyle(
                  fontSize: 13.5.sp,
                  fontFamily: 'Poppins',
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
              inactiveForegroundColor: Color(0xff9CA3AF),
            ),
          ),
        ],
        onTabChanged: (value) {
          setState(() {
            current = value;
          });
          _.update();
          log(current.toString());
        },
        avoidBottomPadding: true,
        backgroundColor: MyColors.primary,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: false,
        stateManagement: true,
        margin: EdgeInsets.only(bottom: 0.0),
        popActionScreens: PopActionScreensType.all,
        popAllScreensOnTapOfSelectedTab: true,
        screenTransitionAnimation: ScreenTransitionAnimation(
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
      ),
    );
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
