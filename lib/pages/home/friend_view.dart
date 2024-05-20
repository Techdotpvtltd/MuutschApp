import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musch/config/colors.dart';
import 'package:musch/pages/home/chat/chat_page.dart';
import 'package:musch/pages/home/filter_screen.dart';
import 'package:musch/widgets/custom_button.dart';
import 'package:musch/widgets/text_widget.dart';

import 'package:readmore/readmore.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../blocs/friend/friend_bloc.dart';
import '../../blocs/friend/friend_event.dart';
import '../../blocs/friend/friend_state.dart';
import '../../manager/app_manager.dart';
import '../../models/friend_model.dart';
import '../../models/user_model.dart';
import '../../repos/user_repo.dart';
import '../../utils/dialogs/dialogs.dart';
import '../../utils/helping_methods.dart';
import '../../widgets/custom_network_image.dart';

class FriendView extends StatefulWidget {
  FriendView({
    super.key,
    required this.isFriend,
    required this.isChat,
    required this.user,
    this.friend,
  });
  final bool isFriend;
  final bool isChat;
  final UserModel user;
  final FriendModel? friend;
  @override
  State<FriendView> createState() => _FriendViewState();
}

class _FriendViewState extends State<FriendView> {
  bool isSendingRequest = false;
  bool isAcceptingRequest = false;
  bool isRejectedRequest = false;
  late FriendModel? friend = widget.friend;

  void triggerSendRequestEvent(FriendBloc bloc) {
    bloc.add(FriendEventSend(recieverId: widget.user.uid));
  }

  void triggerGetFriendEvent(FriendBloc bloc) {
    bloc.add(FriendEventGet(friendId: widget.user.uid));
  }

  void triggerAcceptFriendEvent(FriendBloc bloc) {
    bloc.add(FriendEventAccept(friendId: friend!.uuid));
  }

  void triggerRemoveFriendEvent(FriendBloc bloc) {
    bloc.add(FriendEventRemove(friendId: friend!.uuid));
  }

  @override
  void initState() {
    triggerGetFriendEvent(context.read<FriendBloc>());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FriendBloc, FriendState>(
      listener: (context, state) {
        if (state is FriendStateDataUpdated &&
            state.friend.uuid == friend?.uuid) {
          setState(() {
            friend = state.friend;
          });
        }

        if (state is FriendStateDataRemoved &&
            state.friend.uuid == friend?.uuid) {
          setState(() {
            friend = null;
          });
        }
        if (state is FriendStateRemoving ||
            state is FriendStateRemoveFailure ||
            state is FriendStateRemoved) {
          setState(() {
            isRejectedRequest = state.isLoading;
          });

          if (state is FriendStateRemoveFailure) {
            CustomDialogs().errorBox(message: state.exception.message);
          }
        }
        if (state is FriendStateAcceptFailure ||
            state is FriendStateAccepted ||
            state is FriendStateAccepting) {
          setState(() {
            isAcceptingRequest = state.isLoading;
          });

          if (state is FriendStateAcceptFailure) {
            CustomDialogs().errorBox(message: state.exception.message);
          }

          if (state is FriendStateAccepted &&
              state.frined.uuid == friend?.uuid) {
            setState(() {
              friend = state.frined;
            });
          }
        }
        if (state is FriendStateGot) {
          setState(() {
            friend = state.friend;
          });
        }
        if (state is FriendStateSendFailure ||
            state is FriendStateSending ||
            state is FriendStateSent) {
          setState(() {
            isSendingRequest = state.isLoading;
          });

          if (state is FriendStateSendFailure) {
            CustomDialogs().errorBox(message: state.exception.message);
          }

          if (state is FriendStateSent) {
            setState(() {
              friend = state.friend;
            });
            CustomDialogs()
                .successBox(message: "Your request sent successfully.");
          }
        }
      },
      child: Scaffold(
        backgroundColor: Color(0xffF2F2F2),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                    child: SizedBox(
                      width: 100.w,
                      height: 48.h,
                      child: CustomNetworkImage(imageUrl: widget.user.avatar),
                    ),
                  ),
                  Positioned.fill(
                    child: SafeArea(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Image.asset(
                              "assets/icons/arr.png",
                              height: 5.h,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 2.h),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 22.0, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    text_widget(
                      widget.user.name,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(height: 3.h),
                    text_widget(
                      "Total Children",
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        for (int index = 0;
                            index <
                                ((widget.user.numberOfChildren ?? 0) > 3
                                    ? 3
                                    : (widget.user.numberOfChildren ?? 0));
                            index++)
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.asset(
                                  'assets/images/boy.png',
                                  height: 5.h,
                                  width: 5.h,
                                ),
                              ),
                              SizedBox(width: .5.w),
                            ],
                          ),
                        if ((widget.user.numberOfChildren ?? 0) > 3)
                          text_widget(
                            "+${(widget.user.numberOfChildren ?? 0) - 3}",
                            fontSize: 15.6.sp,
                            fontWeight: FontWeight.w300,
                          ),
                        SizedBox(width: 1.w),
                        // InkWell(
                        //   onTap: () {
                        //     showDialog(
                        //       context: context,
                        //       barrierColor: MyColors.primary.withOpacity(0.88),
                        //       builder: (context) => ChildDetails(),
                        //     );
                        //   },
                        //   child: Container(
                        //     padding: EdgeInsets.symmetric(
                        //         horizontal: 16, vertical: 4),
                        //     decoration: BoxDecoration(
                        //       color: MyColors.primary,
                        //       borderRadius: BorderRadius.circular(50),
                        //     ),
                        //     child: text_widget(
                        //       "View Detail",
                        //       color: Colors.white,
                        //       fontSize: 13.sp,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                    SizedBox(height: 2.5.h),
                    Row(
                      children: [
                        text_widget(
                          "Location",
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        Spacer(),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: MyColors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/icons/p3.png",
                                height: 1.7.h,
                              ),
                              SizedBox(width: 1.w),
                              text_widget(
                                "${calculateDistance(aLat: AppManager().currentLocationPosition?.latitude ?? 0, aLong: AppManager().currentLocationPosition?.longitude ?? 0, bLat: widget.user.location?.latitude ?? 0, bLong: widget.user.location?.longitude ?? 0).toInt()} KM",
                                color: MyColors.primary,
                                fontSize: 13.sp,
                              ),
                              SizedBox(width: 1.w),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 0.5.h),
                    text_widget(
                      widget.user.location?.address ?? "",
                      fontSize: 15.6.sp,
                      fontWeight: FontWeight.w300,
                    ),
                    SizedBox(height: 3.h),
                    text_widget(
                      "About",
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(height: 0.5.h),
                    ReadMoreText(
                      widget.user.bio ?? "",
                      trimLines: 3,
                      style: GoogleFonts.poppins(
                          color: Color(0xff000000).withOpacity(0.46),
                          fontWeight: FontWeight.w400),
                      colorClickableText: Colors.pink,
                      trimMode: TrimMode.Line,
                      trimCollapsedText: 'Read all',
                      trimExpandedText: 'Show less',
                      moreStyle: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: MyColors.primary,
                          decoration: TextDecoration.underline),
                      lessStyle: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: MyColors.primary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    text_widget(
                      "Interests",
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(height: 0.8.h),

                    /// List Of Interests
                    GridView.custom(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 4,
                      ),
                      childrenDelegate: SliverChildBuilderDelegate(
                        childCount: widget.user.interests?.length,
                        (context, index) {
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: text_widget(
                                widget.user.interests?[index] ?? "",
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
                    friend != null
                        ? friend?.senderId != UserRepo().currentUser.uid &&
                                friend?.type == FriendType.request
                            ? Row(
                                children: [
                                  Expanded(
                                    child: gradientButton(
                                      "Decline Request",
                                      font: 15.6,
                                      txtColor: MyColors.primary,
                                      isLoading: isRejectedRequest,
                                      ontap: () {
                                        triggerRemoveFriendEvent(
                                            context.read<FriendBloc>());
                                      },
                                      width: 90,
                                      height: 6.6,
                                      isColor: false,
                                      clr: MyColors.primary,
                                    ),
                                  ),
                                  SizedBox(width: 2.w),
                                  Expanded(
                                    child: gradientButton(
                                      "Accept Request",
                                      font: 15.6,
                                      isLoading: isAcceptingRequest,
                                      txtColor: MyColors.white,
                                      ontap: () {
                                        triggerAcceptFriendEvent(
                                            context.read<FriendBloc>());
                                      },
                                      width: 90,
                                      height: 6.6,
                                      isColor: true,
                                      clr: MyColors.primary,
                                    ),
                                  ),
                                ],
                              )
                            : friend?.type == FriendType.friend
                                ? gradientButton(
                                    "Chat",
                                    font: 17,
                                    txtColor: MyColors.white,
                                    ontap: () {
                                      Get.to(UserChatPage(IsSupport: false));
                                      // _.loginUser();
                                    },
                                    width: 90,
                                    height: 6.6,
                                    isColor: true,
                                    clr: MyColors.primary,
                                  )
                                : gradientButton(
                                    "Withdraw Request",
                                    font: 15.6,
                                    isLoading: isRejectedRequest,
                                    txtColor: MyColors.primary,
                                    ontap: () {
                                      triggerRemoveFriendEvent(
                                          context.read<FriendBloc>());
                                    },
                                    width: 90,
                                    height: 6.6,
                                    isColor: false,
                                    clr: MyColors.primary,
                                  )
                        : gradientButton(
                            isSendingRequest
                                ? "Sending Request..."
                                : "Send Friend Request",
                            font: 17,
                            isLoading: isSendingRequest,
                            txtColor: MyColors.white,
                            ontap: () {
                              triggerSendRequestEvent(
                                  context.read<FriendBloc>());
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
            ],
          ),
        ),
      ),
    );
  }
}
