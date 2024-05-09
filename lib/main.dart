import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musch/controller/drawer_controller.dart';
import 'package:musch/controller/nav_controller.dart';
import 'package:musch/pages/auth/splash_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() {
  Get.put(MyDrawerController());
  Get.put(NavController());
  Get.find<MyDrawerController>().closeDrawer();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, screenType) {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      );
    });
  }
}
