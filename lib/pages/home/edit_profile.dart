import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:musch/config/colors.dart';
import 'package:musch/widgets/custom_button.dart';
import 'package:musch/widgets/text_field.dart';
import 'package:musch/widgets/text_widget.dart';
import 'package:place_picker/place_picker.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../blocs/user/user_bloc.dart';
import '../../blocs/user/user_event.dart';
import '../../blocs/user/user_state.dart';
import '../../models/location_model.dart';
import '../../models/user_model.dart';
import '../../repos/user_repo.dart';
import '../../utils/dialogs/dialogs.dart';
import '../../widgets/avatar_widget.dart';
import '../../widgets/my_image_picker.dart';
import '../auth/interest_page.dart';

class EditProfile extends StatefulWidget {
  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  List<bool> faqs = [false, false, false, false, false];
  bool status4 = false;
  int current = 0;
  final UserModel user = UserRepo().currentUser;
  String? selectedAvatar;
  List<String> interests = [];
  UserLocationModel? location;
  bool isLoading = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  void selectImage() {
    final MyImagePicker imagePicker = MyImagePicker();
    imagePicker.pick();
    imagePicker.onSelection(
      (exception, data) {
        if (data is XFile) {
          setState(() {
            selectedAvatar = data.path;
          });
        }
      },
    );
  }

  void pickLocation() async {
    final LocationResult result = await Get.to(
      PlacePicker(
        "AIzaSyCtEDCykUDeCa7QkT-LK63xQ7msSXNZoq0",
        defaultLocation:
            (location?.latitude != null && location?.longitude != null)
                ? LatLng(location!.latitude, location!.longitude)
                : null,
      ),
    );

    location = UserLocationModel(
      address: result.formattedAddress,
      city: result.city?.name,
      country: result.country?.name,
      latitude: result.latLng?.latitude ?? 0,
      longitude: result.latLng?.longitude ?? 0,
    );

    setState(() {
      locationController.text = location?.address ?? "";
    });
  }

  void triggerUpdateProfileEvent(UserBloc bloc) {
    if (interests.isEmpty) {
      CustomDialogs().errorBox(message: "Please select interests.");
      return;
    }

    if (nameController.text.isEmpty) {
      CustomDialogs().errorBox(message: "Please enter name.");
      return;
    }

    if (emailController.text.isEmpty) {
      CustomDialogs().errorBox(message: "Please enter email.");
      return;
    }

    if (location == null) {
      CustomDialogs().errorBox(message: "Please select location.");
      return;
    }

    bloc.add(
      UserEventUpdateProfile(
          location: location,
          avatar: selectedAvatar,
          name: nameController.text,
          email: emailController.text),
    );
  }

  @override
  void initState() {
    super.initState();

    nameController.text = user.name;
    emailController.text = user.email;
    locationController.text = user.location?.address ?? "";
    emailController.text = user.email;
    interests = user.interests ?? [];
    location = user.location;
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
            CustomDialogs().successBox(message: "Profile Updated");
            setState(() {
              nameController.text = nameController.text;
            });
          }
        }
      },
      child: Scaffold(
        backgroundColor: Color(0xfff2f2f2),
        body: SingleChildScrollView(
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 22.0, vertical: 14),
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
                            size: 3.8.h,
                          )),
                      SizedBox(width: 3.w),
                      text_widget(
                        "Edit Profile",
                        fontWeight: FontWeight.w600,
                        fontSize: 18.sp,
                        // color: Color(0xff1E1E1E)
                      ),
                    ],
                  ),
                  // SizedBox(height: 1.h),
                  SizedBox(height: 3.h),
                  Center(
                    child: Stack(
                      children: [
                        AvatarWidget(
                          backgroundColor: Colors.black,
                          avatarUrl: selectedAvatar ?? user.avatar,
                          onEditPressed: () {
                            selectImage();
                          },
                        ),
                        // Positioned(
                        //   child: Image.asset(
                        //     "assets/icons/cam1.png",
                        //     height: 3.h,
                        //   ),
                        // )
                      ],
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Center(
                    child: text_widget(
                      user.name,
                      fontSize: 17.8.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  text_widget(
                    "Name",
                    fontSize: 15.6.sp,
                  ),
                  SizedBox(height: 1.h),

                  textFieldWithPrefixSuffuxIconAndHintText(
                    "Enter Name",
                    controller: nameController,
                    fillColor: Colors.white,
                    mainTxtColor: Colors.black,
                    radius: 12,
                    bColor: Colors.transparent,
                  ),

                  SizedBox(height: 3.h),
                  text_widget(
                    "Email",
                    fontSize: 15.6.sp,
                  ),
                  SizedBox(height: 1.h),

                  textFieldWithPrefixSuffuxIconAndHintText(
                    "Enter email",
                    controller: emailController,
                    fillColor: Colors.white,
                    mainTxtColor: Colors.black,
                    radius: 12,
                    bColor: Colors.transparent,
                  ),
                  SizedBox(height: 3.h),

                  text_widget(
                    "Location",
                    fontSize: 15.6.sp,
                  ),
                  SizedBox(height: 1.h),

                  InkWell(
                    onTap: () {
                      pickLocation();
                    },
                    child: textFieldWithPrefixSuffuxIconAndHintText(
                      "Select Location",
                      controller: locationController,
                      fillColor: Colors.white,
                      mainTxtColor: Colors.black,
                      enable: false,
                      radius: 12,
                      bColor: Colors.transparent,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      text_widget(
                        "Interest",
                        fontSize: 15.6.sp,
                      ),
                      IconButton(
                        onPressed: () {
                          Get.to(InterestPage(isComingFromSignup: false));

                          setState(() {
                            interests = UserRepo().currentUser.interests ?? [];
                          });
                        },
                        icon: Image.asset(
                          'assets/icons/edit.png',
                          width: 16,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 1.h),

                  /// List Of Interests
                  GridView.custom(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 4,
                    ),
                    childrenDelegate: SliverChildBuilderDelegate(
                      childCount: interests.length,
                      (context, index) {
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: text_widget(
                              interests[index],
                              textAlign: TextAlign.center,
                              fontWeight: FontWeight.w400,
                              fontSize: 15.5.sp,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 4.h),
                  gradientButton(
                    "Save Change",
                    isLoading: isLoading,
                    font: 17,
                    txtColor: MyColors.white,
                    ontap: () {
                      triggerUpdateProfileEvent(context.read<UserBloc>());
                    },
                    width: 90,
                    height: 6.6,
                    isColor: true,
                    clr: MyColors.primary,
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
