import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:musch/blocs/notification/notification_bloc.dart';
import 'package:musch/models/chat_model.dart';
import 'package:musch/models/event_model.dart';
import 'package:musch/pages/home/chat/chat_page.dart';
import 'package:musch/repos/chat_repo.dart';
import 'package:musch/widgets/custom_dropdown.dart';

import 'package:musch/widgets/text_widget.dart';

import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../blocs/notification/notification_event.dart';
import '../../blocs/notification/notification_state.dart';
import '../../models/notification_model.dart';
import '../../utils/dialogs/dialogs.dart';
import '../../widgets/avatar_widget.dart';
import 'event_detail.dart';
import 'friend_view.dart';

class NotificationScreen extends StatefulWidget {
  final bool isDrawer;
  const NotificationScreen({super.key, required this.isDrawer});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool isLoading = false;
  late List<NotificationModel> notifications =
      context.read<NotificationBloc>().notifications;

  void triggerFetchNotificationEvent(NotificationBloc bloc) {
    bloc.add(NotificationEventFetch());
  }

  void triggerMarkNotificationReadableEvent(NotificationBloc bloc) {
    bloc.add(NotificationEventMarkReadable());
  }

  @override
  void initState() {
    triggerMarkNotificationReadableEvent(context.read<NotificationBloc>());
    // triggerFetchNotificationEvent(context.read<NotificationBloc>());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotificationBloc, NotificationState>(
      listener: (context, state) {
        if (state is NotificationStateFetchFailure ||
            state is NotificationStateFetched ||
            state is NotificationStateFetching ||
            state is NotificationStateDeleted) {
          setState(() {
            isLoading = state.isLoading;
          });

          if (state is NotificationStateFetchFailure) {
            CustomDialogs().errorBox(message: state.exception.message);
          }

          if (state is NotificationStateFetched) {
            triggerMarkNotificationReadableEvent(
                context.read<NotificationBloc>());

            setState(() {
              notifications = state.notifications;
            });
          }

          if (state is NotificationStateDeleted) {
            final int index =
                notifications.indexWhere((e) => e.uuid == state.uuid);
            if (index > -1) {
              setState(() {
                notifications.removeAt(index);
              });
            }
          }
        }
      },
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 20.h,
                color: Color(0xffBD9691),
              ),
            ],
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 87.h,
                decoration: BoxDecoration(
                  color: Color(0xfff2f2f2),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: SafeArea(
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18.0, vertical: 4),
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
                              color: Colors.white,
                              size: 4.h,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          textWidget(
                            "Notifications",
                            color: Colors.white,
                            fontSize: 18.sp,
                          ),
                        ],
                      ),
                      SizedBox(height: 3.h),
                      Expanded(
                        child: isLoading
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : ListView.builder(
                                physics: ScrollPhysics(),
                                itemCount: notifications.length,
                                itemBuilder: (context, index) {
                                  final NotificationModel notification =
                                      notifications[index];
                                  return InkWell(
                                    onTap: () async {
                                      // For user
                                      if (notification.type ==
                                          NotificationType.user) {
                                        Get.to(FriendView(
                                            userId: notification.senderId));
                                      }
                                      // For Chat
                                      if (notification.type ==
                                              NotificationType.chat &&
                                          notification.data != null) {
                                        final _ = ChatModel.fromMap(
                                            notification.data!);
                                        final ChatModel? chat = await ChatRepo()
                                            .fetchChat(
                                                id: _.uuid, isGroupChat: true);
                                        if (chat != null) {
                                          Get.to(UserChatPage(chat: chat));
                                        } else {
                                          CustomDialogs().successBox(
                                            message:
                                                "Group is not available. Once it available, we'll inform you.",
                                            title: chat?.groupTitle ??
                                                "Group Chat",
                                          );
                                        }
                                      }

                                      // For Event
                                      if (notification.type ==
                                              NotificationType.event &&
                                          notification.data != null) {
                                        final EventModel event =
                                            EventModel.fromMap(
                                                notification.data!);
                                        Get.to(
                                          EventView(
                                              event: event,
                                              joinMembers:
                                                  event.joinMemberDetails),
                                        );
                                      }
                                    },
                                    child: Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      decoration: BoxDecoration(
                                        color: Colors.white60,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: ListTile(
                                        leading: SizedBox(
                                          width: 55,
                                          height: 55,
                                          child: Center(
                                            child: AvatarWidget(
                                              backgroundColor:
                                                  Color(0xffBD9691),
                                              placeholderChar: notification
                                                  .title.characters.first,
                                              avatarUrl: notification.avatar,
                                            ),
                                          ),
                                        ),
                                        title: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: textWidget(
                                                notification.title,
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            CustomMenuDropdown(
                                              buttonColor: Colors.black,
                                              items: [
                                                DropdownMenuModel(
                                                  icon: Icons.delete,
                                                  title: "Remove",
                                                )
                                              ],
                                              onSelectedItem: (val, a) {
                                                if (a == 0) {
                                                  context
                                                      .read<NotificationBloc>()
                                                      .add(
                                                          NotificationEventDelete(
                                                              notificationId:
                                                                  notifications[
                                                                          index]
                                                                      .uuid));
                                                }
                                              },
                                            )
                                          ],
                                        ),
                                        subtitle: textWidget(
                                          notification.message,
                                          fontSize: 13.sp,
                                          color: Color(0xff8F8F8F),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
