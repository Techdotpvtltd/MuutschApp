import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:musch/blocs/interest/interest_bloc.dart';
import 'package:musch/blocs/interest/interest_event.dart';
import 'package:musch/blocs/interest/interest_state.dart';
import 'package:musch/config/colors.dart';
import 'package:musch/utils/extensions/string_extension.dart';
import 'package:musch/widgets/custom_button.dart';
import 'package:musch/widgets/text_widget.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../blocs/user/user_bloc.dart';
import '../../blocs/user/user_event.dart';
import '../../blocs/user/user_state.dart';
import '../../repos/user_repo.dart';
import '../../utils/dialogs/dialogs.dart';
import '../../widgets/text_field.dart';
import 'login_page.dart';

class InterestPage extends StatefulWidget {
  const InterestPage({super.key, this.isComingFromSignup = true});
  final bool isComingFromSignup;
  @override
  State<InterestPage> createState() => _InterestPageState();
}

class _InterestPageState extends State<InterestPage> {
  List interests = [];
  List<String> selectedInterests = [];
  List current2 = [];
  bool isSaving = false;
  bool isFetchingInterests = false;

  final TextEditingController bioController = TextEditingController();

  void triggerFetchAllInterestEvent() {
    context.read<InterestBloc>().add(InterestEventFetchAll());
  }

  void triggerUpdateProfileEvent(UserBloc bloc) {
    if (selectedInterests.isEmpty) {
      CustomDialogs().errorBox(message: "Please select at least one interest.");
      return;
    }

    bloc.add(UserEventUpdateProfile(
        interests: selectedInterests, bio: bioController.text));
  }

  @override
  void initState() {
    triggerFetchAllInterestEvent();
    bioController.text = UserRepo().currentUser.bio ?? "";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        /// InterestBloc
        BlocListener<InterestBloc, InterestState>(
          listener: (context, state) {
            if (state is InterestStateFetching ||
                state is InterestStateFetchFailure ||
                state is InterestStateFetched) {
              setState(() {
                isFetchingInterests = state.isLoading;
              });

              if (state is InterestStateFetched) {
                setState(() {
                  interests = state.interests
                      .map((e) => e.name.capitalizeFirstCharacter())
                      .toList();

                  selectedInterests = UserRepo().currentUser.interests ?? [];
                  if (selectedInterests.isNotEmpty) {
                    selectedInterests.forEach((a) {
                      final index = interests.indexWhere((element) =>
                          element.toString().toLowerCase() == a.toLowerCase());
                      if (index > -1) {
                        current2.add(index);
                      }
                    });
                  }
                });
              }

              if (state is InterestStateFetchFailure) {
                log(state.exception.message);
              }
            }
          },
        ),

        /// UserBloc
        BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UserStateProfileUpdating ||
                state is UserStateProfileUpdated ||
                state is UserStateProfileUpdatingFailure) {
              setState(() {
                isSaving = state.isLoading;
              });

              if (state is UserStateProfileUpdatingFailure) {
                CustomDialogs().errorBox(message: state.exception.message);
              }

              if (state is UserStateProfileUpdated) {
                if (!widget.isComingFromSignup) {
                  Get.back();
                  Get.back();
                  return;
                }
                CustomDialogs().successBox(
                  message:
                      "We've sent you an email verification link to email. Please verify your email by clicking the link before logging in.",
                  positiveTitle: "Go to Login",
                  onPositivePressed: () {
                    Get.off(const LoginPage());
                  },
                );
              }
            }
          },
        ),
      ],
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
                        ),
                      ),
                      SizedBox(height: 4.h),
                      textWidget(
                        "Your Interest",
                        fontSize: 21.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      SizedBox(height: 0.4.h),
                      textWidget(
                        "Allow us to access your location while you’re using the app so we can help you find and meet members.",
                        fontSize: 15.sp,
                        color: Color(0xff8C8C8C),
                      ),
                      SizedBox(height: 2.h),
                      textWidget(
                        "Your Bio",
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      SizedBox(height: 2.h),
                      textFieldWithPrefixSuffuxIconAndHintText(
                        "Tell us about yourself",
                        controller: bioController,
                        fillColor: Colors.white,
                        mainTxtColor: Colors.black,
                        radius: 12,
                        bColor: Colors.transparent,
                      ),
                      SizedBox(height: 4.h),
                      Wrap(
                        children: [
                          ...List.generate(
                              interests.length,
                              (index) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4.0, vertical: 4),
                                    child: InkWell(
                                      onTap: () {
                                        if (current2.contains(index)) {
                                          setState(() {
                                            current2.remove(index);
                                            selectedInterests
                                                .remove(interests[index]);
                                          });
                                        } else {
                                          setState(() {
                                            current2.add(index);
                                            selectedInterests
                                                .add(interests[index]);
                                          });
                                        }
                                      },
                                      child: Chip(
                                        backgroundColor:
                                            current2.contains(index)
                                                ? MyColors.primary
                                                : Colors.transparent,

                                        label: textWidget(interests[index],
                                            fontSize: 14.sp,
                                            color: current2.contains(index)
                                                ? Colors.white
                                                : MyColors.primary,
                                            fontWeight: FontWeight.w500),

                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(14)),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 18, vertical: 5),
                                        //  backgroundColor: ,
                                        side: BorderSide(
                                            color: Colors.transparent),
                                      ),
                                    ),
                                  ))
                        ],
                      ),
                      SizedBox(height: 5.h),
                      gradientButton(
                        widget.isComingFromSignup ? "Next" : 'Save',
                        isLoading: isSaving,
                        font: 16,
                        txtColor: MyColors.white,
                        ontap: () {
                          triggerUpdateProfileEvent(context.read<UserBloc>());
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
