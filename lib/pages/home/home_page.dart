import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:musch/blocs/auth/auth_bloc.dart';
import 'package:musch/blocs/auth/auth_state.dart';
import 'package:musch/blocs/notification/notification_state.dart';
import 'package:musch/blocs/subscription/subscription_state.dart';
import 'package:musch/config/colors.dart';
import 'package:musch/controller/drawer_controller.dart';
import 'package:musch/models/chat_model.dart';
import 'package:musch/models/other_user_model.dart';
import 'package:musch/pages/home/all_events.dart';
import 'package:musch/pages/home/all_friends.dart';
import 'package:musch/pages/home/chat/chat_page.dart';
import 'package:musch/pages/home/friend_view.dart';
import 'package:musch/pages/home/notification_screen.dart';
import 'package:musch/repos/chat_repo.dart';
import 'package:musch/services/notification_services/push_notification_services.dart';
import 'package:musch/utils/dialogs/dialogs.dart';
import 'package:musch/utils/extensions/string_extension.dart';
import 'package:musch/widgets/event_widget.dart';
import 'package:musch/widgets/request_widget.dart';
import 'package:musch/widgets/text_widget.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

import '../../blocs/event/event_bloc.dart';
import '../../blocs/event/event_state.dart';
import '../../blocs/event/events_event.dart';
import '../../blocs/friend/friend_bloc.dart';
import '../../blocs/friend/friend_event.dart';
import '../../blocs/friend/friend_state.dart';
import '../../blocs/notification/notification_bloc.dart';
import '../../blocs/notification/notification_event.dart';
import '../../blocs/push_notification/psuh_notification_event.dart';
import '../../blocs/push_notification/push_notification_bloc.dart';
import '../../blocs/subscription/subscription_bloc.dart';
import '../../blocs/subscription/subscription_event.dart';
import '../../manager/app_manager.dart';
import '../../models/event_model.dart';
import '../../models/friend_model.dart';
import '../../models/user_model.dart';
import '../../repos/user_repo.dart';
import '../../utils/constants/constants.dart';
import '../../widgets/avatar_widget.dart';
import '../../widgets/text_field.dart';
import '../auth/splash_screen.dart';
import 'edit_profile.dart';
import 'event_detail.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<EventModel> filteredEvents = [];
  List<EventModel> events = [];
  List<FriendModel> friends = [];
  bool isNewNotifications = false;
  bool isFetchingEvents = false;
  final bool isSubscribed = AppManager().isActiveSubscription;

  void triggerFetchAllEvents(EventBloc bloc) {
    bloc.add(EventsEventFetchAll());
  }

  void triggerCurrentLocationEvent(EventBloc bloc) {
    bloc.add(EventsEventFetchCurrentLocation());
  }

  void triggerRequestLocationEvent(EventBloc bloc) {
    bloc.add(EventsEventRequestLocation());
  }

  void triggerJoinEvent(EventBloc bloc, String eventId) {
    bloc.add(EventsEventJoin(eventId: eventId));
  }

  void triggerFetchFriends(FriendBloc bloc) {
    bloc.add(FriendEventFetch());
  }

  void triggerPushNotificationSubscriptionEvents() {
    context
        .read<PushNotificationBloc>()
        .add(PushNotificationEventUserSubscribed());
  }

  void triggerFetchNotificationEvent(NotificationBloc bloc) {
    bloc.add(NotificationEventFetch());
  }

  void triggerSubscriptionListenerEvent(SubscriptionBloc bloc) {
    bloc.add(SubscriptionEventListener());
  }

  void triggerGetLastSubscriptionEvent(SubscriptionBloc bloc) {
    bloc.add(SubscriptionEventGetLast());
  }

  void filteredEventsBy(String search) {
    if (search == "") {
      setState(() {
        filteredEvents = events;
      });
    }
    setState(() {
      filteredEvents = events
          .where((e) => e.title.toLowerCase().contains(search.toLowerCase()))
          .toList();
    });
  }

  void getNotificationOnClick() async {
    try {
      final remote = await PushNotificationServices().getInitialMessage();
      if (remote != null) {
        _handlePushNotification(remote);
      }
    } catch (e) {
      debugPrint("Notification Get Initial Error: $e");
    }
  }

  Future<void> _handlePushNotification(RemoteMessage remote) async {
    try {
      final String type = remote.data['type'];
      final additionalData = remote.data['additionalData'];
      final data = json.decode(additionalData) as Map<String, dynamic>;
      // CustomDialogs().successBox(message: remote.data.toString());

      /// For Chat
      if (type == "chat" || type == "message") {
        final ChatModel chatJson =
            ChatModel.fromMap(data['chat'], isFromJson: true);
        if (!chatJson.isGroup) {
          Get.to(UserChatPage(chat: chatJson));
        } else {
          final ChatModel? chat =
              await ChatRepo().fetchChat(id: chatJson.uuid, isGroupChat: true);
          if (chat != null && chat.isChatEnabled) {
            if (chat.participantUids.contains(UserRepo().currentUser.uid)) {
              Get.to(UserChatPage(chat: chat));
            }
          } else {
            CustomDialogs().successBox(
              message:
                  "Group is not available. Once it available, we'll inform you.",
              title: chat?.groupTitle ?? "Group Chat",
            );
          }
        }
      }

      if (type == "request") {
        final FriendModel user =
            FriendModel.fromMap(data['friend'], isFromJson: true);
        Get.to(FriendView(userId: user.senderId));
      }

      if (type == "event") {
        final EventModel event =
            EventModel.fromMap(data['event'], isFromJson: true);
        Get.to(EventView(event: event, joinMembers: event.joinMemberDetails));
      }

      if (type == "member") {
        // who's join your event
        final OtherUserModel other =
            OtherUserModel.fromMap(data['member'], isFromJson: true);
        Get.to(FriendView(userId: other.uid));
      }
    } catch (e) {
      CustomDialogs().errorBox(message: e.toString());
    }
  }

  @override
  void initState() {
    triggerSubscriptionListenerEvent(context.read<SubscriptionBloc>());
    triggerGetLastSubscriptionEvent(context.read<SubscriptionBloc>());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SubscriptionBloc, SubscriptionState>(
          listener: (ctx, state) {
            if (state is SubscriptionStateGotLast) {
              triggerCurrentLocationEvent(context.read<EventBloc>());
              triggerFetchFriends(context.read<FriendBloc>());
              triggerPushNotificationSubscriptionEvents();
              triggerFetchNotificationEvent(context.read<NotificationBloc>());
              getNotificationOnClick();
            }
          },
        ),

        /// Auth Listener
        BlocListener<AuthBloc, AuthState>(
          listener: (_, state) {
            if (state is AuthStateLogout) {
              context
                  .read<PushNotificationBloc>()
                  .add(PushNotificationEventUserUnSubscribed());

              AppManager.clearAll();
              Get.offAll(const SplashScreen());

              /// Removing Get Instances
              Get.deleteAll(force: true);
            }
          },
        ),

        /// Event Listener
        BlocListener<EventBloc, EventState>(
          listener: (context, state) {
            if (state is EventStateFetchedCurrentLocation) {
              AppManager().currentLocationPosition = state.position;
              triggerFetchAllEvents(context.read<EventBloc>());
            }

            if (state is EventStateCurrentLocationFailure) {
              CustomDialogs().alertBox(
                message: state.status == LocationPermission.deniedForever
                    ? "Please allow us location permission in the settings and after allow,  close and open the app again."
                    : "It seem that we don't have location permission to show nearest events. Please allow us to show you the nearest events",
                title: "Location Denied",
                positiveTitle: state.status == LocationPermission.deniedForever
                    ? "Open Settings"
                    : "Allow Location",
                onPositivePressed: () {
                  state.status == LocationPermission.deniedForever
                      ? Geolocator.openAppSettings()
                      : triggerRequestLocationEvent(context.read<EventBloc>());
                },
              );
            }
          },
        ),
        BlocListener<FriendBloc, FriendState>(
          listener: (context, state) {
            if (state is FriendStateFetchedPendingRequests) {
              setState(
                () {
                  friends = state.friends;
                },
              );
            }

            if (state is FriendStateAccepted ||
                state is FriendStateRemoved ||
                state is FriendStateRejected) {
              triggerFetchFriends(context.read<FriendBloc>());
            }
          },
        ),

        /// Notification Listener
        BlocListener<NotificationBloc, NotificationState>(
          listener: (context, state) async {
            if (state is NotificationStateOnReceivedPush) {
              triggerFetchNotificationEvent(context.read<NotificationBloc>());
              final String type = state.message.data['type'];
              if (type == "request") {
                triggerFetchFriends(context.read<FriendBloc>());
              }
            }
            if (state is NotificationStateNewAvailable) {
              setState(() {
                isNewNotifications = state.isNew;
              });
            }
          },
        ),
      ],
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 53.h,
                color: Color(0xffBD9691),
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                ),
              )
            ],
          ),
          Positioned.fill(
            child: SafeArea(
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25.0,
                        vertical: 0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.find<MyDrawerController>().toggleDrawer();
                                },
                                child: Image.asset(
                                  "assets/images/logo.png",
                                  height: 5.h,
                                ),
                              ),
                              Spacer(),
                              InkWell(
                                onTap: () {
                                  Get.to(() =>
                                      NotificationScreen(isDrawer: false));
                                },

                                /// Notification Widget
                                child: Stack(
                                  children: [
                                    Image.asset(
                                      "assets/nav/d3.png",
                                      color: Colors.white,
                                      height: 4.0.h,
                                    ),
                                    if (isNewNotifications)
                                      Positioned(
                                        right: 5,
                                        child: CircleAvatar(
                                          radius: 5,
                                          backgroundColor: Colors.red,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 1.5.w,
                              ),

                              /// Profile Widget
                              InkWell(
                                onTap: () {
                                  Get.to(EditProfile());
                                },
                                child: AvatarWidget(
                                  height: 40,
                                  width: 40,
                                  backgroundColor: Colors.black,
                                  avatarUrl: UserRepo().currentUser.avatar,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 3.5.h),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: MyColors.primary,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: textWidget(
                              "Hello, ${UserRepo().currentUser.name}",
                              color: Colors.white,
                              fontSize: 15.sp,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          textWidget(
                            "Find Amazing Friends",
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          SizedBox(height: 2.5.h),
                          textFieldWithPrefixSuffuxIconAndHintText(
                            "Search Events",
                            fillColor: Colors.white,
                            mainTxtColor: Colors.black,
                            radius: 12,
                            onChanged: (p0) {
                              filteredEventsBy(p0);
                            },
                            bColor: Colors.transparent,
                            prefixIcon: "assets/nav/s1.png",
                            isPrefix: true,
                          ),
                        ],
                      ),
                    ),
                    gapH10,
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          triggerFetchAllEvents(context.read<EventBloc>());
                          triggerFetchFriends(context.read<FriendBloc>());
                          await Future.doWhile(() => isFetchingEvents);
                        },
                        child: SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (friends.isNotEmpty) SizedBox(height: 2.h),
                              if (friends.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 25,
                                    right: 25,
                                    bottom: 10,
                                  ),
                                  child: Row(
                                    children: [
                                      textWidget(
                                        "Friend Requests",
                                        color: Colors.white,
                                        fontSize: 17.5.sp,
                                      ),
                                      Spacer(),
                                      InkWell(
                                        onTap: () {
                                          Get.to(
                                            () => AllFriends(
                                                isRequestFriendScreen: true),
                                          );
                                        },
                                        child: textWidget(
                                          "View All",
                                          fontSize: 14.sp,
                                          color: MyColors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 25.0,
                                    right: 25,
                                  ),
                                  child: Row(
                                    children: [
                                      for (int i = 0;
                                          i < friends.take(5).length;
                                          i++)
                                        FutureBuilder<UserModel?>(
                                          future: UserRepo().fetchUser(
                                              profileId: friends[i].senderId),
                                          builder: (context, snapshot) {
                                            return snapshot.hasData &&
                                                    snapshot.data != null
                                                ? Row(
                                                    children: [
                                                      requestWidget(
                                                        user: snapshot.data!,
                                                        friend: friends[i],
                                                      ),
                                                      SizedBox(width: 2.w),
                                                    ],
                                                  )
                                                : Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                          },
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 3.h),
                              Container(
                                color: Colors.white,
                                child: BlocListener<EventBloc, EventState>(
                                  listener: (context, state) {
                                    if (state is EventStateFetched) {
                                      setState(
                                        () {
                                          events = state.events;
                                          filteredEvents =
                                              state.events.take(5).toList();
                                        },
                                      );
                                    }
                                    if (state is EventStateFetchFailure ||
                                        state is EventStateFetchedAll ||
                                        state is EventStateFetching ||
                                        state is EventStateJoined) {
                                      if (state is EventStateFetchedAll) {
                                        setState(() {
                                          isFetchingEvents = state.isLoading;
                                        });
                                        setState(
                                          () {
                                            events = state.events;
                                            debugPrint(
                                                state.events.length.toString());
                                            filteredEvents = state.events;
                                          },
                                        );
                                      }
                                      if (state is EventStateJoined) {
                                        final int index = filteredEvents
                                            .indexWhere((element) =>
                                                element.id == state.event.id);
                                        if (index > -1) {
                                          setState(() {
                                            filteredEvents[index] = state.event;
                                          });
                                        }
                                      }
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 25.0,
                                      vertical: 0,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            textWidget(
                                              "Nearby Events",
                                              color: Colors.black,
                                              fontSize: 17.5.sp,
                                            ),
                                            Spacer(),
                                            InkWell(
                                              onTap: () {
                                                Get.to(AllEvents());
                                              },
                                              child: textWidget(
                                                "View All",
                                                fontSize: 14.sp,
                                                color: MyColors.primary,
                                                decoration:
                                                    TextDecoration.underline,
                                                decorationColor:
                                                    MyColors.primary,
                                              ),
                                            ),
                                          ],
                                        ),
                                        gapH20,
                                        if (filteredEvents.isEmpty)
                                          SizedBox(
                                            width: SCREEN_WIDTH,
                                            height: SCREEN_HEIGHT / 2,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "No Events",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    triggerFetchAllEvents(
                                                        context
                                                            .read<EventBloc>());
                                                  },
                                                  child: Text(
                                                    "Refresh",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      decoration: TextDecoration
                                                          .underline,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        if (filteredEvents.isNotEmpty)
                                          for (final EventModel event
                                              in filteredEvents)
                                            Column(
                                              children: [
                                                eventWidget(
                                                  title: event.title,
                                                  address:
                                                      "${event.location.city}, ${event.location.country}",
                                                  eventId: event.id,
                                                  imageUrl: event.imageUrls
                                                          .firstOrNull ??
                                                      '',
                                                  creator: event
                                                      .creatorDetail.name
                                                      .capitalizeFirstCharacter(),
                                                  onClickEvent: () {
                                                    Get.to(
                                                      EventView(
                                                        event: event,
                                                        joinMembers: event
                                                            .joinMemberDetails,
                                                      ),
                                                    );
                                                  },
                                                  onClickJoinButton: () {
                                                    triggerJoinEvent(
                                                      context.read<EventBloc>(),
                                                      event.id,
                                                    );
                                                  },
                                                  isVisibleJoinButton:
                                                      event.joinMemberIds
                                                              .where(
                                                                (element) =>
                                                                    element ==
                                                                    UserRepo()
                                                                        .currentUser
                                                                        .uid,
                                                              )
                                                              .length <
                                                          1,
                                                ),
                                                gapH16,
                                              ],
                                            ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
