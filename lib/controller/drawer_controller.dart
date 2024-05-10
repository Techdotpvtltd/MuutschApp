import 'package:get/get.dart';
import 'dart:async';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:musch/controller/nav_controller.dart';

class MyDrawerController extends GetxController {
  final zoomDrawerController = ZoomDrawerController();
  bool open = false;
  void toggleDrawer() {
    print("Toggle drawer");
    Timer(const Duration(microseconds: 30), () {
      open = true;
      Get.find<NavController>().isVisible = false;
      Get.find<NavController>().update();

      update();
    });
    zoomDrawerController.toggle?.call();
    update();
  }

  int active = 0;

  void closeDrawer() {
    print("Close drawer");
    Timer(const Duration(microseconds: 800), () {
      open = false;
      Get.find<NavController>().isVisible = true;
      Get.find<NavController>().update();

      update();
    });
    zoomDrawerController.close?.call();
    update();
  }
}
