import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:musch/controller/drawer_controller.dart';
import 'package:musch/pages/auth/welcome_page.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../home/home_drawer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void triggerSplashEvent(AuthBloc bloc) {
    bloc.add(AuthEventSplashAction());
  }

  @override
  void initState() {
    super.initState();
    Get.find<MyDrawerController>().closeDrawer();
    triggerSplashEvent(context.read<AuthBloc>());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthStateSplashActionDone) {
          Get.offAll(const HomeDrawer());
        }

        if (state is AuthStateLoginRequired) {
          Future.delayed(const Duration(seconds: 1), () {
            Get.off(const WelcomePage());
          });
        }
      },
      child: Stack(
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
      ),
    );
  }
}
