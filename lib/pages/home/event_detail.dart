// ignore_for_file: sdk_version_since

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:musch/blocs/chat/%20chat_bloc.dart';
import 'package:musch/blocs/chat/chat_event.dart';
import 'package:musch/blocs/chat/chat_state.dart';
import 'package:musch/config/colors.dart';
import 'package:musch/models/chat_model.dart';
import 'package:musch/models/other_user_model.dart';
import 'package:musch/utils/extensions/date_extension.dart';
import 'package:musch/utils/extensions/navigation_service.dart';
import 'package:musch/widgets/custom_button.dart';
// import 'package:musch/widgets/map_sample.dart';
import 'package:musch/widgets/text_widget.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../blocs/event/event_bloc.dart';
import '../../blocs/event/event_state.dart';
import '../../blocs/event/events_event.dart';
import '../../models/event_model.dart';
import '../../repos/user_repo.dart';
import '../../utils/constants/constants.dart';
import '../../utils/dialogs/dialogs.dart';
import '../../widgets/custom_network_image.dart';
import 'add_event.dart';
import 'chat/chat_page.dart';
import 'event_member_list.dart';

class EventView extends StatefulWidget {
  const EventView(
      {super.key,
      required this.event,
      this.isFromMyEvents = false,
      required this.joinMembers});
  final EventModel event;
  final bool isFromMyEvents;
  final List<OtherUserModel> joinMembers;

  @override
  State<EventView> createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  late EventModel event = widget.event;
  bool isDeleting = false;
  bool isJoiningEvent = false;
  bool isChatLoading = false;

  String? joiningEventId;
  List<OtherUserModel> joinMembers = [];
  ChatModel? chat;

  void triggerDeleteEvent(EventBloc bloc) {
    bloc.add(EventsEventDelete(eventId: event.id));
  }

  void triggerJoinEvent(EventBloc bloc) {
    bloc.add(EventsEventJoin(eventId: event.id));
  }

  void triggerFetchChatEvent() {
    context.read<ChatBloc>().add(
          ChatEventFetchGroupChat(
            eventId: event.id,
            joinedMemberIds: event.joinMemberIds,
            eventTitle: event.title,
          ),
        );
  }

  @override
  void initState() {
    joinMembers = widget.joinMembers;
    triggerFetchChatEvent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ChatBloc, ChatState>(
          listener: (context, state) {
            if (state is ChatStateCreated ||
                state is ChatStateCreating ||
                state is ChatStateCreateFailure ||
                state is ChatStateFetching ||
                state is ChatStateFetched ||
                state is ChatStateFetchFailure ||
                state is ChatStateJoinFailure ||
                state is ChatStateJoined ||
                state is ChatStateJoining ||
                state is ChatStateUpdatedStatus ||
                state is ChatStateUpdateGroupStatusFailure ||
                state is ChatStateUpdatingGroupStatus) {
              setState(() {
                isChatLoading = state.isLoading;
              });

              if (state is ChatStateUpdatedStatus) {
                setState(() {
                  chat = chat?.copyWith(isChatEnabled: state.status);
                });
              }
              if (state is ChatStateFetchFailure) {
                log(state.exception.message);
              }
              if (state is ChatStateJoinFailure) {
                log(state.exception.message);
              }
              if (state is ChatStateCreateFailure) {
                log(state.exception.message.toString());
              }
              if (state is ChatStateFetched) {
                setState(() {
                  chat = state.chat;
                });
              }
              if (state is ChatStateJoined) {
                setState(() {
                  chat?.participantUids.add(UserRepo().currentUser.uid);
                });
                NavigationService.go(UserChatPage(chat: chat!));
              }
              if (state is ChatStateCreated) {
                setState(() {
                  chat = state.chat;
                });
              }
            }
          },
        ),
        BlocListener<EventBloc, EventState>(
          listener: (context, state) {
            /// Join Event States
            if (state is EventStateJoinFailure ||
                state is EventStateJoined ||
                state is EventStateJoining) {
              setState(() {
                isJoiningEvent = state.isLoading;
                if (state is EventStateJoining) {
                  joiningEventId = state.eventId;
                }
              });

              if (state is EventStateJoined) {
                setState(() {
                  event = state.event;
                });
                triggerFetchChatEvent();
              }

              if (state is EventStateJoinFailure) {
                CustomDialogs().errorBox(message: state.exception.message);
              }
            }

            /// Update Event States
            if (state is EventStateUpdated) {
              setState(() {
                event = state.updatedEvent;
              });
            }

            /// Delete Event States
            if (state is EventStateDeleteFailure ||
                state is EventStateDeleted ||
                state is EventStateDeteing) {
              setState(() {
                isDeleting = state.isLoading;
              });

              if (state is EventStateDeleteFailure) {
                CustomDialogs().errorBox(message: state.exception.message);
              }

              if (state is EventStateDeleted) {
                CustomDialogs().successBox(
                  message: "Event deleted successfully.",
                  positiveTitle: "Go back",
                  onPositivePressed: () {
                    Get.back();
                  },
                  barrierDismissible: false,
                );
              }
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Color(0xffF2F2F2),
        body: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 22.0, vertical: 0),
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
                            size: 4.h,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        textWidget(
                          "Events Detail",
                          fontSize: 19.sp,
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: SizedBox(
                        height: 38.h,
                        width: 100.w,
                        child: CustomNetworkImage(
                          imageUrl: event.imageUrls.first,
                          backgroundColor: Colors.grey,
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        textWidget(
                          event.title,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () {
                            Get.to(EventMemberList(joinMembers: joinMembers));
                          },
                          child: textWidget(
                            "View Members (${joinMembers.length}/${event.maxPersons})",
                            fontSize: 13.6.sp,
                            fontWeight: FontWeight.w700,
                            color: MyColors.primary3,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset("assets/icons/d2.png", height: 1.8.h),
                            SizedBox(width: 2.w),
                            textWidget(
                              (event.dateTime).dateToString('dd MMMM, yyyy'),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w300,
                            ),
                            SizedBox(width: 6.w),
                            Image.asset("assets/icons/cl.png", height: 1.8.h),
                            SizedBox(width: 2.w),
                            textWidget(
                              (event.dateTime).dateToString('hh:mm a'),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w300,
                            ),
                          ],
                        ),

                        /// For Admin
                        if (event.createdBy == UserRepo().currentUser.uid)
                          isChatLoading
                              ? Center(child: CircularProgressIndicator())
                              : InkWell(
                                  onTap: () {
                                    if (chat == null) {
                                      context.read<ChatBloc>().add(
                                            ChatEventCreate(
                                              isGroup: true,
                                              chatAvatar:
                                                  event.imageUrls.firstOrNull ??
                                                      "",
                                              chatTitle: event.title,
                                              eventId: event.id,
                                              isChatEnabled: true,
                                              ids: event.joinMemberIds,
                                            ),
                                          );
                                      return;
                                    }

                                    if (chat!.isChatEnabled) {
                                      context.read<ChatBloc>().add(
                                          ChatEventUpdateVisibilityStatus(
                                              status: false,
                                              memberIds: event.joinMemberIds,
                                              chatId: chat!.uuid,
                                              groupTitle: event.title));
                                      return;
                                    }
                                    if (!chat!.isChatEnabled) {
                                      context.read<ChatBloc>().add(
                                          ChatEventUpdateVisibilityStatus(
                                              status: true,
                                              memberIds: event.joinMemberIds,
                                              chatId: chat!.uuid,
                                              groupTitle: event.title));
                                      return;
                                    }
                                  },
                                  child: Text(
                                    chat != null
                                        ? chat!.isChatEnabled
                                            ? "Disable Group Chat"
                                            : "Enable Group Chat"
                                        : "Create Group Chat",
                                    style: TextStyle(
                                      color: MyColors.primary3,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),

                        /// For Users
                        if (event.createdBy != UserRepo().currentUser.uid &&
                            chat != null &&
                            chat!.isChatEnabled &&
                            event.joinMemberIds
                                .contains(UserRepo().currentUser.uid))
                          isChatLoading
                              ? Center(child: CircularProgressIndicator())
                              : InkWell(
                                  onTap: () {
                                    chat!.participantUids.contains(
                                      UserRepo().currentUser.uid,
                                    )
                                        ? NavigationService.go(
                                            UserChatPage(chat: chat!))
                                        : context.read<ChatBloc>().add(
                                              ChatEventJoinGroupChat(
                                                eventId: event.id,
                                              ),
                                            );
                                  },
                                  child: Text(
                                    chat!.participantUids.contains(
                                      UserRepo().currentUser.uid,
                                    )
                                        ? "View Group Chat"
                                        : "Join Group Chat",
                                    style: TextStyle(
                                      color: MyColors.primary3,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                      ],
                    ),
                    if (event.description != "" || event.description == null)
                      SizedBox(height: 3.h),
                    if (event.description != "" || event.description == null)
                      textWidget(
                        "Description",
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    if (event.description != "" || event.description == null)
                      SizedBox(height: 0.5.h),
                    if (event.description != "" || event.description == null)
                      textWidget(
                        event.description ?? "",
                        fontSize: 14.6.sp,
                        fontWeight: FontWeight.w400,
                        color: Color(
                          0xff8A8A8A,
                        ),
                      ),
                    SizedBox(height: 3.h),
                    Row(
                      children: [
                        textWidget(
                          "Location",
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        Image.asset(
                          "assets/icons/p4.png",
                          height: 1.7.h,
                        ),
                        SizedBox(width: 2.w),
                        Flexible(
                          child: textWidget(
                            event.location.address ?? "",
                            fontSize: 15.6.sp,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    widget.isFromMyEvents
                        ? Row(
                            children: [
                              Expanded(
                                child: gradientButton(
                                  "Delete",
                                  isLoading: isDeleting,
                                  font: 15.5,
                                  txtColor: MyColors.primary,
                                  ontap: () {
                                    CustomDialogs().deleteBox(
                                      title: "Delete Event Confirmation",
                                      message:
                                          "Are you sure to delete this ${event.title} event? This Process will not be undo.",
                                      onPositivePressed: () {
                                        triggerDeleteEvent(
                                            context.read<EventBloc>());
                                      },
                                    );
                                  },
                                  width: 90,
                                  height: 6,
                                  isColor: false,
                                  clr: MyColors.primary,
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Expanded(
                                child: gradientButton(
                                  "Edit",
                                  font: 15.5,
                                  txtColor: MyColors.white,
                                  ontap: () {
                                    Get.to(AddEvent(event: event));
                                  },
                                  width: 90,
                                  height: 6,
                                  isColor: true,
                                  clr: MyColors.primary,
                                ),
                              ),
                            ],
                          )
                        : Visibility(
                            visible: widget.joinMembers
                                    .where((element) =>
                                        element.uid ==
                                        UserRepo().currentUser.uid)
                                    .length <
                                1,
                            child: gradientButton(
                              isJoiningEvent && joiningEventId == event.id
                                  ? "Joining..."
                                  : "Join Event",
                              font: 17,
                              isLoading:
                                  isJoiningEvent && joiningEventId == event.id,
                              txtColor: MyColors.white,
                              ontap: () {
                                triggerJoinEvent(context.read<EventBloc>());
                              },
                              width: 90,
                              height: 6.6,
                              isColor: true,
                              clr: MyColors.primary,
                            ),
                          ),
                    gapH20,
                  ],
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
