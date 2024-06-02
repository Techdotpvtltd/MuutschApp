import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musch/config/colors.dart';
import 'package:musch/pages/auth/reset_password.dart';
import 'package:musch/pages/auth/signup_page.dart';
import 'package:musch/pages/home/home_drawer.dart';
import 'package:musch/widgets/custom_button.dart';
import 'package:musch/widgets/text_field.dart';
import 'package:musch/widgets/text_widget.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../utils/dialogs/dialogs.dart';
import '../../utils/dialogs/loaders.dart';
import 'dart:io' show Platform;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  void triggerLoginEvent(AuthBloc bloc) {
    bloc.add(
      AuthEventPerformLogin(
          email: emailController.text, password: passwordController.text),
    );
  }

  void triggeEmailVerificationMail(AuthBloc bloc) {
    bloc.add(AuthEventSentEmailVerificationLink());
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
        if (state is AuthStateLogging ||
            state is AuthStateLoggedIn ||
            state is AuthStateLoginFailure ||
            state is AuthStateEmailVerificationRequired ||
            state is AuthStateAppleLoggedIn ||
            state is AuthStateGoogleLoggedIn ||
            state is AuthStateGoogleLogging ||
            state is AuthStateSendingMailVerification ||
            state is AuthStateSendingMailVerificationFailure ||
            state is AuthStateSentMailVerification) {
          /// Start Of Code
          if (state is AuthStateLogging ||
              state is AuthStateLoggedIn ||
              state is AuthStateLoginFailure ||
              state is AuthStateEmailVerificationRequired ||
              state is AuthStateAppleLoggedIn ||
              state is AuthStateGoogleLoggedIn ||
              state is AuthStateGoogleLogging) {
            setState(() {
              isLoading = state.isLoading;
            });

            if (state is AuthStateLoginFailure) {
              CustomDialogs().errorBox(message: state.exception.message);
            }

            if (state is AuthStateLoggedIn ||
                state is AuthStateAppleLoggedIn ||
                state is AuthStateGoogleLoggedIn) {
              Get.offAll(const HomeDrawer());
            }
          }

          if (state is AuthStateEmailVerificationRequired) {
            CustomDialogs().alertBox(
              message:
                  "Please verify your email by clicking on the link provided in the email we've sent you.",
              title: "Email Verification Required",
              positiveTitle: "Login again",
              negativeTitle: "Sent link agin",
              onPositivePressed: () {
                triggerLoginEvent(context.read<AuthBloc>());
              },
              onNegativePressed: () {
                triggeEmailVerificationMail(context.read<AuthBloc>());
              },
            );
          }
          // For Email Verification States
          if (state is AuthStateSendingMailVerification ||
              state is AuthStateSendingMailVerificationFailure ||
              state is AuthStateSentMailVerification) {
            state.isLoading ? Loader().show() : Get.back();

            if (state is AuthStateSendingMailVerificationFailure) {
              CustomDialogs().errorBox(message: state.exception.message);
            }

            if (state is AuthStateSentMailVerification) {
              CustomDialogs().successBox(
                  message:
                      "We've sent you an email verification link to ${emailController.text}. Please verify your email by clicking the link before logging in.");
            }
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
                      )),
                      SizedBox(height: 4.h),
                      textWidget("Login for Business",
                          fontSize: 21.sp, fontWeight: FontWeight.w600),
                      SizedBox(height: 0.4.h),
                      textWidget("Enter your credentials  to log in",
                          fontSize: 15.sp, color: Color(0xff8C8C8C)),
                      SizedBox(height: 6.h),
                      textFieldWithPrefixSuffuxIconAndHintText(
                        "Enter Phone Number",
                        controller: emailController,
                        fillColor: Colors.white,
                        mainTxtColor: Colors.black,
                        radius: 12,
                        bColor: Colors.transparent,
                        prefixIcon: "assets/icons/phone.png",
                        isPrefix: true,
                      ),
                      SizedBox(height: 2.h),
                      textFieldWithPrefixSuffuxIconAndHintText(
                        "Enter Phone Number",
                        controller: passwordController,
                        fillColor: Colors.white,
                        mainTxtColor: Colors.black,
                        radius: 12,
                        bColor: Colors.transparent,
                        prefixIcon: "assets/icons/lock.png",
                        isPrefix: true,
                      ),
                      SizedBox(height: 1.h),
                      Row(
                        children: [
                          Spacer(),
                          InkWell(
                            onTap: () {
                              Get.to(ResetPassword());
                            },
                            child: textWidget(
                              "Forgot Password?",
                              fontSize: 13.5.sp,
                              color: Color(
                                0xff262626,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 7.h),
                      gradientButton(
                        "Log In",
                        isLoading: isLoading,
                        font: 17,
                        txtColor: MyColors.white,
                        ontap: () {
                          triggerLoginEvent(context.read<AuthBloc>());
                        },
                        width: 90,
                        height: 6.6,
                        isColor: true,
                        clr: MyColors.primary,
                      ),
                      SizedBox(height: 3.h),
                      Center(
                        child: InkWell(
                          onTap: () {
                            Get.offAll(SignupPage());
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
                                  text: 'Signup',
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
                                      decorationThickness: 1.4),
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
                          )),
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
          ))
        ],
      ),
    );
  }
}
