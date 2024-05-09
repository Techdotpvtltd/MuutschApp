import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musch/controller/drawer_controller.dart';
import 'package:musch/pages/auth/welcome_page.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Get.find<MyDrawerController>().closeDrawer();
    Timer(Duration(seconds: 2), () async {
      Get.offAll(WelcomePage());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
            child: Image.asset(
          "assets/images/splash.png",
          fit: BoxFit.fill,
          height: Get.height,
          width: Get.width,
        )),
        Positioned.fill(
            child: Align(
          child: Image.asset(
            "assets/images/logo.png",
            height: 20.h,
          ),
        ))
      ],
    );
  }
}
