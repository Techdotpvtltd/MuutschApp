import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:musch/config/colors.dart';
import 'package:musch/pages/auth/allow_location.dart';
import 'package:musch/widgets/custom_button.dart';
import 'package:musch/widgets/text_widget.dart';

import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../blocs/user/user_bloc.dart';
import '../../blocs/user/user_event.dart';
import '../../blocs/user/user_state.dart';
import '../../utils/dialogs/dialogs.dart';
import '../../widgets/avatar_widget.dart';
import '../../widgets/my_image_picker.dart';

class UploadPicture extends StatefulWidget {
  const UploadPicture({super.key});

  @override
  State<UploadPicture> createState() => _UploadPictureState();
}

class _UploadPictureState extends State<UploadPicture> {
  String? avatar;
  bool isLoading = false;

  void triggerUpdateProfileEvent(UserBloc bloc) {
    if (avatar == "" || avatar == null) {
      CustomDialogs().errorBox(message: "Please select profile");
      return;
    }
    bloc.add(UserEventUpdateProfile(avatar: avatar));
  }

  void selectImage() {
    final MyImagePicker imagePicker = MyImagePicker();
    imagePicker.pick();
    imagePicker.onSelection(
      (exception, data) {
        if (data is XFile) {
          setState(() {
            avatar = data.path;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserStateProfileUpdating ||
            state is UserStateProfileUpdated ||
            state is UserStateProfileUpdatingFailure ||
            state is UserStateAvatarUploading ||
            state is UserStateAvatarUploaded ||
            state is UserStatAvatareUploadingFailure) {
          setState(() {
            isLoading = state.isLoading;
          });

          if (state is UserStateProfileUpdatingFailure) {
            CustomDialogs().errorBox(message: state.exception.message);
          }

          if (state is UserStateProfileUpdated) {
            Get.to(AllowLocation());
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
                            ),
                          )
                        ],
                      ),
                      Center(
                        child: Image.asset(
                          "assets/images/logo.png",
                          height: 10.h,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      text_widget(
                        "Upload Picture",
                        fontSize: 21.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      SizedBox(height: 0.4.h),
                      text_widget(
                        "Please Upload Your Profile picture to create an account.",
                        fontSize: 15.sp,
                        color: Color(
                          0xff8C8C8C,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Center(
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 8.h,
                              backgroundColor: MyColors.primary,
                              child: CircleAvatar(
                                radius: 7.8.h,
                                backgroundColor: Colors.white,
                                child: AvatarWidget(
                                  avatarUrl: avatar,
                                  backgroundColor: Colors.black,
                                  height: 135,
                                  width: 135,
                                ),
                              ),
                            ),

                            /// Camera Button
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: InkWell(
                                  onTap: () {
                                    selectImage();
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: MyColors.primary,
                                    radius: 2.h,
                                    child: Image.asset(
                                      "assets/icons/cam.png",
                                      height: 2.4.h,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 3.h),
                      SizedBox(height: 7.h),
                      gradientButton(
                        isLoading: isLoading,
                        "Next",
                        font: 17,
                        txtColor: MyColors.white,
                        ontap: () {
                          // _.loginUser();

                          triggerUpdateProfileEvent(context.read<UserBloc>());
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
          ))
        ],
      ),
    );
  }
}
