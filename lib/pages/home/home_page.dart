import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:musch/config/colors.dart';
import 'package:musch/controller/drawer_controller.dart';
import 'package:musch/pages/home/all_events.dart';
import 'package:musch/pages/home/all_friends.dart';
import 'package:musch/pages/home/notification_screen.dart';
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
import '../../blocs/push_notification/psuh_notification_event.dart';
import '../../blocs/push_notification/push_notification_bloc.dart';
import '../../manager/app_manager.dart';
import '../../models/event_model.dart';
import '../../models/friend_model.dart';
import '../../models/join_event_model.dart';
import '../../models/user_model.dart';
import '../../repos/event_repo.dart';
import '../../repos/user_repo.dart';
import '../../utils/constants/constants.dart';
import '../../widgets/avatar_widget.dart';
import '../../widgets/text_field.dart';
import 'edit_profile.dart';
import 'event_detail.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<EventModel> events = [];
  List<FriendModel> friends = [];

  void triggerFetchAllEvents(EventBloc bloc) {
    bloc.add(EventsEventFetchAll());
  }

  void triggerCurrentLocationEvent(EventBloc bloc) {
    bloc.add(EventsEventFetchCurrentLocation());
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

  @override
  void initState() {
    triggerCurrentLocationEvent(context.read<EventBloc>());
    triggerFetchFriends(context.read<FriendBloc>());
    triggerPushNotificationSubscriptionEvents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<EventBloc, EventState>(
          listener: (context, state) {
            if (state is EventStateFetchedCurrentLocation) {
              AppManager().currentLocationPosition = state.position;
              triggerFetchAllEvents(context.read<EventBloc>());
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
                          horizontal: 25.0, vertical: 0),
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
                                  Get.to(NotificationScreen(isDrawer: false));
                                },

                                /// Notification Widget
                                child: Image.asset(
                                  "assets/nav/d3.png",
                                  color: Colors.white,
                                  height: 4.5.h,
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
                                horizontal: 25, vertical: 8),
                            decoration: BoxDecoration(
                              color: MyColors.primary,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: text_widget(
                                "Hello, ${UserRepo().currentUser.name}",
                                color: Colors.white,
                                fontSize: 15.sp),
                          ),
                          SizedBox(height: 1.h),
                          text_widget(
                            "Find Amazing Friends",
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          SizedBox(height: 2.5.h),
                          textFieldWithPrefixSuffuxIconAndHintText(
                            "Search Events & Friends",
                            // controller: _.password,
                            fillColor: Colors.white,
                            mainTxtColor: Colors.black,
                            radius: 12,
                            bColor: Colors.transparent,
                            prefixIcon: "assets/nav/s1.png",
                            isPrefix: true,
                          ),
                        ],
                      ),
                    ),
                    gapH10,
                    Expanded(
                      child: SingleChildScrollView(
                        physics: ScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 2.h),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 25,
                                right: 25,
                                bottom: 10,
                              ),
                              child: Row(
                                children: [
                                  text_widget(
                                    "Friend Requests",
                                    color: Colors.white,
                                    fontSize: 17.5.sp,
                                  ),
                                  Spacer(),
                                  InkWell(
                                    onTap: () {
                                      Get.to(
                                        AllFriends(
                                          isRequestFriendScreen: true,
                                        ),
                                      );
                                    },
                                    child: text_widget(
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
                                        events = state.events.take(5).toList();
                                      },
                                    );
                                  }
                                  if (state is EventStateFetchFailure ||
                                      state is EventStateFetchedAll ||
                                      state is EventStateFetching) {
                                    if (state is EventStateFetchedAll) {
                                      setState(
                                        () {
                                          events =
                                              state.events.take(5).toList();
                                        },
                                      );
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
                                          text_widget(
                                            "Nearby Events",
                                            color: Colors.black,
                                            fontSize: 17.5.sp,
                                          ),
                                          Spacer(),
                                          InkWell(
                                            onTap: () {
                                              Get.to(AllEvents());
                                            },
                                            child: text_widget(
                                              "View All",
                                              fontSize: 14.sp,
                                              color: MyColors.primary,
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationColor: MyColors.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                      gapH20,
                                      for (final EventModel event in events)
                                        FutureBuilder(
                                          future: EventRepo().fetchJoinEvent(
                                              eventId: event.id),
                                          builder: (context, snapshot) {
                                            final List<JoinMemberModel>
                                                joinsModel =
                                                snapshot.data ?? [];

                                            return BlocSelector<EventBloc,
                                                EventState, bool?>(
                                              selector: (state) {
                                                if (state is EventStateJoined) {
                                                  if (state.joinModel.eventId ==
                                                      event.id) {
                                                    joinsModel
                                                        .add(state.joinModel);
                                                    return true;
                                                  }
                                                }

                                                return null;
                                              },
                                              builder: (context, isJoined) {
                                                return Column(
                                                  children: [
                                                    eventWidget(
                                                      title: event.title,
                                                      address:
                                                          "${event.location.city}, ${event.location.country}",
                                                      eventId: event.id,
                                                      imageUrl:
                                                          event.imageUrls.first,
                                                      creator: event.createdBy,
                                                      onClickEvent: () {
                                                        Get.to(
                                                          EventView(
                                                            event: event,
                                                            joinsModel:
                                                                joinsModel,
                                                          ),
                                                        );
                                                      },
                                                      onClickJoinButton: () {
                                                        triggerJoinEvent(
                                                          context.read<
                                                              EventBloc>(),
                                                          event.id,
                                                        );
                                                      },
                                                      isVisibleJoinButton:
                                                          joinsModel
                                                                  .where(
                                                                    (element) =>
                                                                        element.joinerId ==
                                                                            UserRepo()
                                                                                .currentUser
                                                                                .uid &&
                                                                        element.eventId ==
                                                                            event.id,
                                                                  )
                                                                  .length <
                                                              1,
                                                    ),
                                                    gapH16,
                                                  ],
                                                );
                                              },
                                            );
                                          },
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
