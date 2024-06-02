import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:musch/config/colors.dart';
import 'package:musch/widgets/custom_button.dart';
import 'package:musch/widgets/text_field.dart';
import 'package:musch/widgets/text_widget.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../utils/dialogs/dialogs.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  void triggerForgotPassword(AuthBloc bloc) {
    bloc.add(
      AuthEventForgotPassword(email: emailController.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthStateSendingForgotEmail ||
            state is AuthStateSendForgotEmailFailure ||
            state is AuthStateSentForgotEmail) {
          setState(() {
            isLoading = state.isLoading;
          });

          if (state is AuthStateSendForgotEmailFailure) {
            CustomDialogs().errorBox(message: state.exception.message);
          }

          if (state is AuthStateSentForgotEmail) {
            CustomDialogs().successBox(
              message:
                  "We've just sent you an email containing a password reset link.\nPlease check your mail.",
              title: "Mail Sent!",
              positiveTitle: "Go back",
              onPositivePressed: () {
                Get.back();
              },
            );
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
                      SizedBox(height: 8.h),
                      Center(
                        child: Image.asset(
                          "assets/images/reset.png",
                          height: 14.h,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Center(
                        child: textWidget(
                          "Reset Your Password",
                          fontSize: 21.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 0.4.h),
                      textWidget(
                          "Please check your inbox and follow the instructions to reset your password.",
                          fontSize: 15.sp,
                          color: Color(0xff8C8C8C),
                          textAlign: TextAlign.center),
                      SizedBox(height: 4.h),
                      textFieldWithPrefixSuffuxIconAndHintText(
                        "Email",
                        controller: emailController,
                        fillColor: Colors.white,
                        mainTxtColor: Colors.black,
                        radius: 12,
                        bColor: Colors.transparent,
                        prefixIcon: "assets/icons/mail.png",
                        isPrefix: true,
                      ),
                      SizedBox(height: 9.h),
                      gradientButton(
                        "Send Link",
                        font: 16,
                        isLoading: isLoading,
                        txtColor: MyColors.white,
                        ontap: () {
                          triggerForgotPassword(context.read<AuthBloc>());
                        },
                        width: 90,
                        height: 6.6,
                        isColor: true,
                        clr: MyColors.primary,
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
