import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:musch/config/colors.dart';
import 'package:musch/controller/drawer_controller.dart';
import 'package:musch/pages/auth/change_password.dart';
import 'package:musch/pages/home/my_eventss.dart';
import 'package:musch/pages/home/all_friends.dart';
import 'package:musch/pages/home/bottom_navigation.dart';
import 'package:musch/pages/home/edit_profile.dart';
import 'package:musch/pages/home/home_drawer.dart';
import 'package:musch/pages/home/subscription_plan.dart';
import 'package:musch/widgets/custom_button.dart';
import 'package:musch/widgets/text_widget.dart';

import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/user/user_bloc.dart';
import '../../blocs/user/user_state.dart';
import '../../models/user_model.dart';
import '../../repos/user_repo.dart';
import '../../utils/dialogs/dialogs.dart';
import '../../widgets/avatar_widget.dart';

class ProfilePage extends StatefulWidget {
  final bool isDrawer;
  final VoidCallback updateParentState; // Define callback
  const ProfilePage(
      {Key? key, required this.isDrawer, required this.updateParentState})
      : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<bool> faqs = [false, false, false, false, false];
  bool status4 = false;
  final UserModel user = UserRepo().currentUser;

  // int current = 0;

  void trigegrLogoutEvent(AuthBloc bloc) {
    CustomDialogs().alertBox(
      title: "Logout Action",
      message: "Are you sure to logout this account?",
      negativeTitle: "No",
      positiveTitle: "Yes",
      onPositivePressed: () {
        bloc.add(AuthEventPerformLogout());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          /// Background
          child: Image.asset(
            "assets/nav/dp.png",
            // height: 20.h,
            fit: BoxFit.fill,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 22.0, vertical: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          InkWell(
                              onTap: () {
                                if (widget.isDrawer) {
                                  setState(() {
                                    current = 0;
                                  });
                                  Get.find<NavScreenController>()
                                      .controller
                                      .jumpToTab(current);
                                  Get.find<NavScreenController>().update();
                                  widget.updateParentState();
                                  setState(() {});
                                } else {
                                  Get.find<MyDrawerController>().closeDrawer();
                                  Get.to(HomeDrawer());
                                }
                              },
                              child: Icon(
                                Remix.arrow_left_s_line,
                                color: Colors.black,
                                size: 3.h,
                              )),
                          SizedBox(width: 3.w),
                          text_widget("Profile",
                              fontWeight: FontWeight.w600, fontSize: 18.sp),
                        ],
                      ),
                      // SizedBox(height: 1.h),
                      SizedBox(height: 5.h),

                      InkWell(
                        onTap: () {
                          Get.to(EditProfile());
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: MyColors.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child:
                                BlocSelector<UserBloc, UserState, UserModel?>(
                                    selector: (state) {
                              return state is UserStateProfileUpdated
                                  ? UserRepo().currentUser
                                  : null;
                            }, builder: (context, statedData) {
                              return Row(
                                children: [
                                  AvatarWidget(
                                    height: 60,
                                    width: 60,
                                    backgroundColor: Colors.black,
                                    avatarUrl: (statedData ?? user).avatar,
                                  ),
                                  SizedBox(width: 4.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        text_widget(
                                          (statedData ?? user).name,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        SizedBox(height: 0.5.h),
                                        text_widget(
                                          (statedData ?? user).email,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                        ),
                      ),
                      SizedBox(height: 4.h),

                      InkWell(
                        onTap: () {
                          Get.to(ChangePassword(isDrawer: false));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: ListTile(
                              leading: Image.asset(
                                "assets/icons/lock.png",
                                height: 2.8.h,
                              ),
                              title: text_widget("Change password",
                                  fontSize: 15.2.sp),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      InkWell(
                          onTap: () {
                            Get.to(MyEvents());
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: ListTile(
                                leading: Image.asset(
                                  "assets/icons/e1.png",
                                  height: 2.8.h,
                                ),
                                title:
                                    text_widget("My Event", fontSize: 15.2.sp),
                              ),
                            ),
                          )),
                      SizedBox(height: 2.h),
                      InkWell(
                        onTap: () {
                          Get.to(
                            AllFriends(friends: []),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: ListTile(
                              leading: Image.asset(
                                "assets/icons/fr.png",
                                height: 2.8.h,
                              ),
                              title:
                                  text_widget("My Friends", fontSize: 15.2.sp),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      InkWell(
                        onTap: () {
                          Get.to(SubscriptionPlan());
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: ListTile(
                              leading: Image.asset(
                                "assets/icons/sub1.png",
                                height: 2.8.h,
                              ),
                              title: text_widget("Subscription",
                                  fontSize: 15.2.sp),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5.h),
                      gradientButton("Log Out",
                          font: 17, txtColor: MyColors.white, ontap: () {
                        trigegrLogoutEvent(context.read<AuthBloc>());
                        // _.loginUser();
                      },
                          width: 90,
                          height: 6.6,
                          isColor: true,
                          clr: MyColors.primary),
                    ],
                  ),
                )),
          ),
        ),
      ],
    );
  }
}
