import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:musch/config/colors.dart';
import 'package:musch/utils/extensions/string_extension.dart';
import 'package:musch/widgets/custom_button.dart';
import 'package:musch/widgets/text_field.dart';
import 'package:musch/widgets/text_widget.dart';

import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../blocs/user/user_bloc.dart';
import '../../blocs/user/user_event.dart';
import '../../blocs/user/user_state.dart';
import '../../utils/dialogs/dialogs.dart';
import 'upload_picture.dart';

class AboutChildren extends StatefulWidget {
  const AboutChildren({super.key});

  @override
  State<AboutChildren> createState() => _AboutChildrenState();
}

class _AboutChildrenState extends State<AboutChildren> {
  bool isLoading = false;
  final TextEditingController controller = TextEditingController();

  void triggerUpdateUserEvent(UserBloc bloc) {
    if (controller.text == "") {
      CustomDialogs().errorBox(message: "Please enter number of children.");
      return;
    }

    if (!controller.text.isNumeric()) {
      CustomDialogs().errorBox(message: "Value must be in numbers.");
      return;
    }

    bloc.add(UserEventUpdateProfile(
        numberOfChildren: int.tryParse(controller.text)));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserStateProfileUpdating ||
            state is UserStateProfileUpdated ||
            state is UserStateProfileUpdatingFailure) {
          setState(() {
            isLoading = state.isLoading;
          });

          if (state is UserStateProfileUpdatingFailure) {
            CustomDialogs().errorBox(message: state.exception.message);
          }

          if (state is UserStateProfileUpdated) {
            Get.to(UploadPicture());
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
          )),
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
                        Row(
                          children: [
                            InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: Icon(
                                  Remix.arrow_left_s_line,
                                  color: Colors.black,
                                  size: 3.h,
                                ))
                          ],
                        ),
                        Center(
                            child: Image.asset(
                          "assets/images/logo.png",
                          height: 10.h,
                        )),
                        SizedBox(height: 4.h),
                        textWidget("About Children",
                            fontSize: 21.sp, fontWeight: FontWeight.w600),
                        SizedBox(height: 0.4.h),
                        textWidget(
                            "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                            fontSize: 15.sp,
                            color: Color(0xff8C8C8C)),
                        SizedBox(height: 6.h),
                        textFieldWithPrefixSuffuxIconAndHintText(
                          controller: controller,
                          "Enter Number of Child",
                          // controller: _.password,
                          fillColor: Colors.white,
                          mainTxtColor: Colors.black,
                          radius: 12,

                          bColor: Colors.transparent,
                          prefixIcon: "assets/icons/child.png",
                          isPrefix: true,
                        ),
                        SizedBox(height: 3.h),
                        SizedBox(height: 7.h),
                        gradientButton(
                          "Next",
                          isLoading: isLoading,
                          font: 17,
                          txtColor: MyColors.white,
                          ontap: () {
                            triggerUpdateUserEvent(context.read<UserBloc>());
                          },
                          width: 90,
                          height: 6.6,
                          isColor: true,
                          clr: MyColors.primary,
                        ),
                        SizedBox(height: 3.h),
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
