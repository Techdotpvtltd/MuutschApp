import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:musch/blocs/notification/notification_bloc.dart';

import 'package:musch/controller/drawer_controller.dart';
import 'package:musch/pages/home/home_drawer.dart';
import 'package:musch/widgets/text_widget.dart';

import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../blocs/notification/notification_event.dart';
import '../../blocs/notification/notification_state.dart';
import '../../models/notification_model.dart';
import '../../utils/dialogs/dialogs.dart';
import '../../widgets/avatar_widget.dart';
import 'friend_view.dart';

class NotificationScreen extends StatefulWidget {
  final bool isDrawer;
  const NotificationScreen({super.key, required this.isDrawer});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool isLoading = false;
  List<NotificationModel> notifications = [];

  void triggerFetchNotificationEvent(NotificationBloc bloc) {
    bloc.add(NotificationEventFetch());
  }

  @override
  void initState() {
    triggerFetchNotificationEvent(context.read<NotificationBloc>());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotificationBloc, NotificationState>(
      listener: (context, state) {
        if (state is NotificationStateFetchFailure ||
            state is NotificationStateFetched ||
            state is NotificationStateFetching) {
          setState(() {
            isLoading = state.isLoading;
          });

          if (state is NotificationStateFetchFailure) {
            CustomDialogs().errorBox(message: state.exception.message);
            debugPrint("Calling");
          }

          if (state is NotificationStateFetched) {
            setState(() {
              notifications = state.notifications;
            });
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
                              Get.find<MyDrawerController>().closeDrawer();
                              Get.to(HomeDrawer());
                            },
                            child: Icon(
                              Remix.arrow_left_s_line,
                              color: Colors.white,
                              size: 4.h,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          text_widget(
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
                                    onTap: () {
                                      if (notification.type ==
                                          NotificationType.user) {
                                        Get.to(FriendView(
                                            userId: notification.senderId));
                                        return;
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
                                        leading: InkWell(
                                          onTap: () {
                                            Get.to(FriendView(
                                                userId: notification.senderId));
                                          },
                                          child: SizedBox(
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
                                        ),
                                        title: text_widget(
                                          notification.title,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        subtitle: text_widget(
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
