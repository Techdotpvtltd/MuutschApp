import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musch/config/colors.dart';
import 'package:musch/pages/home/chat/chat_page.dart';
import 'package:musch/widgets/custom_button.dart';
import 'package:musch/widgets/text_widget.dart';

import 'package:readmore/readmore.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../blocs/chat/ chat_bloc.dart';
import '../../blocs/chat/chat_event.dart';
import '../../blocs/chat/chat_state.dart';
import '../../blocs/friend/friend_bloc.dart';
import '../../blocs/friend/friend_event.dart';
import '../../blocs/friend/friend_state.dart';
import '../../blocs/user/user_bloc.dart';
import '../../blocs/user/user_event.dart';
import '../../blocs/user/user_state.dart';
import '../../manager/app_manager.dart';
import '../../models/friend_model.dart';
import '../../models/other_user_model.dart';
import '../../models/user_model.dart';
import '../../repos/user_repo.dart';
import '../../utils/dialogs/dialogs.dart';
import '../../utils/helping_methods.dart';
import '../../widgets/custom_network_image.dart';

class FriendView extends StatefulWidget {
  FriendView({
    super.key,
    this.friend,
    required this.userId,
  });
  final FriendModel? friend;
  final String userId;

  @override
  State<FriendView> createState() => _FriendViewState();
}

class _FriendViewState extends State<FriendView> {
  bool isSendingRequest = false;
  bool isAcceptingRequest = false;
  bool isRejectedRequest = false;
  late FriendModel? friend = widget.friend;
  UserModel? user;
  bool isLoadingUserDetail = true;
  bool isLoadingChat = false;

  void triggerSendRequestEvent(FriendBloc bloc) {
    bloc.add(FriendEventSend(recieverId: widget.userId));
  }

  void triggerGetFriendEvent(FriendBloc bloc) {
    bloc.add(FriendEventGet(friendId: widget.userId));
  }

  void triggerAcceptFriendEvent(FriendBloc bloc) {
    bloc.add(FriendEventAccept(friendId: friend!.uuid));
  }

  void triggerRemoveFriendEvent(FriendBloc bloc) {
    bloc.add(FriendEventRemove(friendId: friend!.uuid));
  }

  void triggerUserFetchEvent(UserBloc bloc) {
    bloc.add(UserEventFetchDetail(uid: widget.userId));
  }

  void triggerFetchChatEvent(ChatBloc bloc) {
    if (user != null) {
      bloc.add(
        ChatEventFetch(
          friendProfile: OtherUserModel(
            uid: user!.uid,
            name: user!.name,
            avatarUrl: user!.avatar,
            about: user?.bio ?? "",
            createdAt: DateTime.now(),
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    triggerUserFetchEvent(context.read<UserBloc>());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F2F2),
      body: MultiBlocListener(
        listeners: [
          /// Chat Bloc
          BlocListener<ChatBloc, ChatState>(
            listener: (context, state) {
              if (state is ChatStateCreating ||
                  state is ChatStateCreated ||
                  state is ChatStateCreateFailure ||
                  state is ChatStateFetched ||
                  state is ChatStateFetching ||
                  state is ChatStateFetchFailure) {
                setState(() {
                  isLoadingChat = state.isLoading;
                });

                if (state is ChatStateCreateFailure) {
                  CustomDialogs().errorBox(message: state.exception.message);
                }

                if (state is ChatStateFetchFailure) {
                  CustomDialogs().errorBox(message: state.exception.message);
                }

                if (state is ChatStateCreated) {
                  Get.to(UserChatPage(chat: state.chat));
                }

                if (state is ChatStateFetched) {
                  if (state.chat != null) {
                    Get.to(UserChatPage(chat: state.chat!));
                  }
                }
              }
            },
          ),

          /// User Bloc
          BlocListener<UserBloc, UserState>(
            listener: (context, state) {
              if (state is UserStateFetchingSingle ||
                  state is UserStateFetchSingleFailure ||
                  state is UserStateFetchedSingle) {
                setState(() {
                  isLoadingUserDetail = state.isLoading;
                });

                if (state is UserStateFetchedSingle) {
                  setState(() {
                    user = state.user;
                  });
                  triggerGetFriendEvent(context.read<FriendBloc>());
                }
              }
            },
          ),

          /// Friend Bloc
          BlocListener<FriendBloc, FriendState>(listener: (context, state) {
            if (state is FriendStateRemoving ||
                state is FriendStateRemoveFailure ||
                state is FriendStateRemoved) {
              setState(() {
                isRejectedRequest = state.isLoading;
              });

              if (state is FriendStateRemoveFailure) {
                CustomDialogs().errorBox(message: state.exception.message);
              }

              if (state is FriendStateRemoved &&
                  state.friendId == friend?.uuid) {
                setState(() {
                  friend = null;
                });
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
          }),
        ],
        child: SingleChildScrollView(
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
                      child: CustomNetworkImage(imageUrl: user?.avatar ?? ""),
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
              isLoadingUserDetail
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 22.0, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          textWidget(
                            user?.name ?? "---",
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          SizedBox(height: 3.h),
                          textWidget(
                            "Total Children",
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          SizedBox(height: 0.5.h),
                          Row(
                            children: [
                              for (int index = 0;
                                  index <
                                      ((user?.numberOfChildren ?? 0) > 3
                                          ? 3
                                          : (user?.numberOfChildren ?? 0));
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
                              if ((user?.numberOfChildren ?? 0) > 3)
                                textWidget(
                                  "+${(user?.numberOfChildren ?? 0) - 3}",
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
                              textWidget(
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
                                    textWidget(
                                      "${calculateDistance(aLat: AppManager().currentLocationPosition?.latitude ?? 0, aLong: AppManager().currentLocationPosition?.longitude ?? 0, bLat: user?.location?.latitude ?? 0, bLong: user?.location?.longitude ?? 0).toInt()} KM",
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
                          textWidget(
                            user?.location?.address ?? "",
                            fontSize: 15.6.sp,
                            fontWeight: FontWeight.w300,
                          ),
                          SizedBox(height: 3.h),
                          textWidget(
                            "About",
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          SizedBox(height: 0.5.h),
                          ReadMoreText(
                            user?.bio ?? "",
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
                          textWidget(
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
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 4,
                            ),
                            childrenDelegate: SliverChildBuilderDelegate(
                              childCount: user?.interests?.length ?? 0,
                              (context, index) {
                                return Container(
                                  padding: EdgeInsets.symmetric(horizontal: 14),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: textWidget(
                                      user?.interests?[index] ?? "",
                                      textAlign: TextAlign.center,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15.5.sp,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          if (user?.uid != UserRepo().currentUser.uid)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 4.h),
                                friend != null
                                    ? friend?.senderId !=
                                                UserRepo().currentUser.uid &&
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
                                                        context.read<
                                                            FriendBloc>());
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
                                                        context.read<
                                                            FriendBloc>());
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
                                            ? Row(
                                                children: [
                                                  Expanded(
                                                    child: gradientButton(
                                                      "Remove",
                                                      font: 15.6,
                                                      txtColor:
                                                          MyColors.primary,
                                                      isLoading:
                                                          isRejectedRequest,
                                                      ontap: () {
                                                        triggerRemoveFriendEvent(
                                                            context.read<
                                                                FriendBloc>());
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
                                                      "Chat",
                                                      font: 15.6,
                                                      isLoading: isLoadingChat,
                                                      txtColor: MyColors.white,
                                                      ontap: () {
                                                        triggerFetchChatEvent(
                                                            context.read<
                                                                ChatBloc>());
                                                      },
                                                      width: 90,
                                                      height: 6.6,
                                                      isColor: true,
                                                      clr: MyColors.primary,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : gradientButton(
                                                "Withdraw Request",
                                                font: 15.6,
                                                isLoading: isRejectedRequest,
                                                txtColor: MyColors.primary,
                                                ontap: () {
                                                  triggerRemoveFriendEvent(
                                                      context
                                                          .read<FriendBloc>());
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
                              ],
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
