import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musch/config/colors.dart';
import 'package:musch/pages/auth/about_children.dart';
import 'package:musch/pages/auth/login_page.dart';
import 'package:musch/widgets/custom_button.dart';
import 'package:musch/widgets/text_field.dart';
import 'package:musch/widgets/text_widget.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../utils/dialogs/dialogs.dart';
import '../home/home_drawer.dart';
import 'dart:io' show Platform;

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool isLoading = false;
  bool? isUser;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void triggerSignupEvent(AuthBloc bloc) {
    if (isUser == null) {
      CustomDialogs().errorBox(message: "Please select user type.");
      return;
    }
    bloc.add(
      AuthEventRegistering(
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
        isUser: isUser!,
      ),
    );
  }

  void triggerAppleLogin(AuthBloc bloc) {
    bloc.add(AuthEventAppleLogin());
  }

  void triggerGoogleLogin(AuthBloc bloc) {
    bloc.add(AuthEventGoogleLogin());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthStateRegisterFailure ||
            state is AuthStateRegistered ||
            state is AuthStateRegistering ||
            state is AuthStateAppleLoggedIn ||
            state is AuthStateGoogleLoggedIn ||
            state is AuthStateLogging ||
            state is AuthStateLoggedIn ||
            state is AuthStateLoginFailure ||
            state is AuthStateGoogleLogging) {
          setState(() {
            isLoading = state.isLoading;
          });

          if (state is AuthStateRegisterFailure) {
            CustomDialogs().errorBox(message: state.exception.message);
          }

          if (state is AuthStateRegistered) {
            Get.to(AboutChildren());
          }

          if (state is AuthStateLoginFailure) {
            if (state.exception.errorCode != null) {
              CustomDialogs().errorBox(message: state.exception.message);
            }
          }

          if (state is AuthStateLoggedIn ||
              state is AuthStateAppleLoggedIn ||
              state is AuthStateGoogleLoggedIn) {
            Get.offAll(const HomeDrawer());
          }
        }
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Color(0xffF2F2F2),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Image.asset(
                "assets/images/shape.png",
                height: 25.h,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Positioned.fill(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: SafeArea(
                bottom: false,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Image.asset(
                            "assets/images/logo.png",
                            height: 10.h,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        textWidget(
                          "Registration",
                          fontSize: 21.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        SizedBox(height: 0.4.h),
                        textWidget(
                          "Are you sign up as a business or a person",
                          fontSize: 15.sp,
                          color: Color(0xff8C8C8C),
                        ),
                        SizedBox(height: 4.h),
                        textFieldWithPrefixSuffuxIconAndHintText(
                          controller: nameController,
                          "Name",
                          // controller: _.password,
                          fillColor: Colors.white,
                          mainTxtColor: Colors.black,
                          radius: 12,
                          bColor: Colors.transparent,
                          prefixIcon: "assets/icons/name.png",
                          isPrefix: true,
                        ),
                        SizedBox(height: 2.h),
                        textFieldWithPrefixSuffuxIconAndHintText(
                          controller: emailController,
                          "Email",
                          // controller: _.password,
                          fillColor: Colors.white,
                          mainTxtColor: Colors.black,
                          radius: 12,
                          bColor: Colors.transparent,
                          prefixIcon: "assets/icons/mail.png",
                          isPrefix: true,
                        ),
                        SizedBox(height: 2.h),
                        textFieldWithPrefixSuffuxIconAndHintText(
                          controller: passwordController,
                          "Create Password",
                          // controller: _.password,
                          fillColor: Colors.white,
                          mainTxtColor: Colors.black,
                          radius: 12,
                          bColor: Colors.transparent,
                          prefixIcon: "assets/icons/lock.png",
                          isPrefix: true,
                        ),
                        SizedBox(height: 4.h),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            textWidget("Sign up as: "),
                            Row(
                              children: [
                                Radio(
                                  value: isUser ?? false,
                                  groupValue: true,
                                  onChanged: (value) {
                                    setState(
                                      () {
                                        isUser = true;
                                      },
                                    );
                                  },
                                ),
                                textWidget("User", fontSize: 16.0),
                                Radio(
                                  value: isUser == false,
                                  groupValue: true,
                                  onChanged: (value) {
                                    setState(() {
                                      isUser = false;
                                    });
                                  },
                                ),
                                textWidget("Business", fontSize: 16.0),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 3.h),
                        gradientButton("Next",
                            font: 17,
                            txtColor: MyColors.white,
                            width: 90,
                            isLoading: isLoading,
                            height: 6.6, ontap: () {
                          triggerSignupEvent(context.read<AuthBloc>());
                        }, isColor: true, clr: MyColors.primary),
                        SizedBox(height: 2.h),
                        Center(
                          child: InkWell(
                            onTap: () {
                              Get.offAll(LoginPage());
                            },
                            child: RichText(
                              text: TextSpan(
                                style: GoogleFonts.poppins(
                                  color: MyColors.black,
                                  fontSize: 15.3.sp,
                                ),
                                children: <TextSpan>[
                                  TextSpan(text: 'Don’t have an account ?\t'),
                                  TextSpan(
                                    text: 'Sign In',
                                    style: GoogleFonts.poppins(
                                      shadows: [
                                        Shadow(
                                            color: MyColors.black,
                                            offset: Offset(0, -2))
                                      ],
                                      fontWeight: FontWeight.bold,
                                      color: Colors.transparent,
                                      fontSize: 15.3.sp,
                                      decoration: TextDecoration.underline,
                                      decorationColor: MyColors.primary,
                                      decorationThickness: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: MyColors.primary,
                                thickness: 1,
                              ),
                            ),
                            textWidget(" OR ", color: MyColors.primary),
                            Expanded(
                              child: Divider(
                                color: MyColors.primary,
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 3.h),
                        Row(
                          children: [
                            Spacer(),
                            Visibility(
                              visible: Platform.isIOS,
                              child: InkWell(
                                onTap: () {
                                  triggerAppleLogin(context.read<AuthBloc>());
                                },
                                child: Image.asset(
                                  "assets/nav/apple.png",
                                  height: 6.h,
                                ),
                              ),
                            ),
                            SizedBox(width: 4.w),
                            InkWell(
                              onTap: () {
                                triggerGoogleLogin(context.read<AuthBloc>());
                              },
                              child: Image.asset("assets/nav/google.png",
                                  height: 6.h),
                            ),
                            Spacer(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
