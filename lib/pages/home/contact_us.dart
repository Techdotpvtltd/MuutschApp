import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:musch/blocs/contact_us/contact_us_bloc.dart';
import 'package:musch/blocs/contact_us/contact_us_event.dart';
import 'package:musch/blocs/contact_us/contact_us_state.dart';
import 'package:musch/config/colors.dart';
import 'package:musch/models/user_model.dart';
import 'package:musch/repos/user_repo.dart';
import 'package:musch/utils/dialogs/dialogs.dart';
import 'package:musch/widgets/custom_button.dart';
import 'package:musch/widgets/text_field.dart';
import 'package:musch/widgets/text_widget.dart';

import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ContactUsPage extends StatefulWidget {
  final bool isDrawer;
  const ContactUsPage({super.key, required this.isDrawer});

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  bool isLoading = false;

  void triggerContactUsEvent() {
    context.read<ContactUsBloc>().add(ContactEventSend(
        name: nameController.text,
        email: emailController.text,
        message: messageController.text));
  }

  @override
  void initState() {
    final UserModel user = UserRepo().currentUser;
    nameController.text = user.name;
    emailController.text = user.email;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ContactUsBloc, ContactUsState>(
      listener: (context, state) {
        if (state is ContactStateSending ||
            state is ContactStateSendFailure ||
            state is ContactStateSent) {
          setState(() {
            isLoading = state.isLoading;
          });

          if (state is ContactStateSendFailure) {
            CustomDialogs().errorBox(message: state.exception.message);
          }

          if (state is ContactStateSent) {
            CustomDialogs()
                .successBox(message: "Your message has been recorded.");
            // messageController.clear();
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
              child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              bottom: false,
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4.0, horizontal: 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Icon(Remix.arrow_left_s_line,
                                color: Colors.black, size: 4.h),
                          ),
                          SizedBox(width: 2.w),
                          textWidget(
                            "Contact us",
                            color: Colors.black,
                            fontSize: 18.sp,
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      Center(
                        child: Image.asset(
                          "assets/icons/us.png",
                          height: 24.h,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      textWidget(
                        "Name",
                        fontSize: 15.6.sp,
                      ),
                      SizedBox(height: 1.h),
                      textFieldWithPrefixSuffuxIconAndHintText(
                        "Write Here",
                        controller: nameController,
                        fillColor: Colors.white,
                        mainTxtColor: Colors.black,
                        radius: 12,
                        bColor: Colors.transparent,
                        prefixIcon: "assets/icons/lock.png",
                        isPrefix: false,
                      ),
                      SizedBox(height: 2.h),
                      textWidget(
                        "Email",
                        fontSize: 15.6.sp,
                      ),
                      SizedBox(height: 1.h),
                      textFieldWithPrefixSuffuxIconAndHintText(
                        "Write Here",
                        controller: emailController,
                        fillColor: Colors.white,
                        mainTxtColor: Colors.black,
                        radius: 12,
                        bColor: Colors.transparent,
                        prefixIcon: "assets/icons/lock.png",
                        isPrefix: false,
                      ),
                      SizedBox(height: 2.h),
                      textWidget(
                        "Message",
                        fontSize: 15.6.sp,
                      ),
                      SizedBox(height: 1.h),
                      textFieldWithPrefixSuffuxIconAndHintText(
                        "Write Here",
                        line: 5,
                        controller: messageController,
                        fillColor: Colors.white,
                        mainTxtColor: Colors.black,
                        radius: 12,
                        bColor: Colors.transparent,
                        prefixIcon: "assets/icons/lock.png",
                        isPrefix: false,
                      ),
                      SizedBox(height: 4.h),
                      gradientButton(
                        isLoading ? "Sending" : "Submit",
                        font: 16,
                        txtColor: MyColors.white,
                        ontap: () {
                          triggerContactUsEvent();
                        },
                        width: 90,
                        isLoading: isLoading,
                        height: 6.6,
                        isColor: true,
                        clr: MyColors.primary,
                      ),
                      SizedBox(height: 14.h),
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
