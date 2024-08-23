import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavController extends GetxController {
  NavController() {
    currentIndex = 0;
  }
  int currentTab = 0;
  int currentIndex = 0;
  bool isVisible = true;

  Widget currentScreen = SizedBox();
}

class NavController1 extends GetxController {
  NavController1() {
    currentIndex = 0;
  }
  int currentTab = 0;
  int currentIndex = 0;
  bool isVisible = true;

  Widget currentScreen = SizedBox();
}
