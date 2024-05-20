import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:musch/config/colors.dart';
import 'package:musch/pages/home/event_detail.dart';
import 'package:musch/pages/home/filter_screen.dart';
import 'package:musch/widgets/custom_button.dart';
import 'package:musch/widgets/event_widget.dart';
import 'package:musch/widgets/text_widget.dart';

import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../blocs/event/event_bloc.dart';
import '../../blocs/event/event_state.dart';
import '../../blocs/event/events_event.dart';
import '../../models/event_model.dart';
import '../../models/join_event_model.dart';
import '../../models/location_model.dart';
import '../../repos/event_repo.dart';
import '../../repos/user_repo.dart';
import '../../utils/dialogs/dialogs.dart';
import '../../widgets/custom_network_image.dart';
import '../../widgets/text_field.dart';

class AllEvents extends StatefulWidget {
  const AllEvents({super.key});

  @override
  State<AllEvents> createState() => _AllEventsState();
}

class _AllEventsState extends State<AllEvents> {
  bool isGrid = false;
  List<EventModel> events = [];
  bool isLoading = false;
  String? searchText;
  LocationModel? location;
  RangeValues? rangeValues;

  final TextEditingController searchController = TextEditingController();

  void triggerFetchAllEvents(EventBloc bloc) {
    bloc.add(EventsEventFetchAll());
  }

  void triggerFilteredEvent(EventBloc bloc) {
    bloc.add(
      EventsEventFilter(
        searchText: searchText,
        location: location,
        maxDistance: rangeValues?.end,
        minDistance: rangeValues?.start,
      ),
    );
  }

  void triggerJoinEvent(EventBloc bloc, String eventId) {
    bloc.add(EventsEventJoin(eventId: eventId));
  }

  @override
  void initState() {
    triggerFetchAllEvents(context.read<EventBloc>());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EventBloc, EventState>(
      listener: (context, state) {
        /// Filter States
        if (state is EventStateApplyFilter) {
          if (state.searchText != null) {
            setState(() {
              searchText = state.searchText;
              searchController.text = searchText ?? "";
            });
          }
          location = state.location;
          rangeValues = state.values;
          triggerFilteredEvent(context.read<EventBloc>());
        }

        if (state is EventStateClearFilter) {
          searchText = null;
          setState(() {
            searchController.clear();
          });
          location = null;
          rangeValues = null;
          triggerFilteredEvent(context.read<EventBloc>());
        }

        /// Fetch Data States
        if (state is EventStateFetchedFiltered) {
          setState(() {
            events = state.events;
          });
        }

        if (state is EventStateFetched) {
          setState(() {
            events = state.events;
          });
        }
        if (state is EventStateFetchFailure ||
            state is EventStateFetchedAll ||
            state is EventStateFetching) {
          setState(() {
            isLoading = state.isLoading;
          });

          if (state is EventStateFetchFailure) {
            CustomDialogs().errorBox(message: state.exception.message);
          }

          if (state is EventStateFetchedAll) {
            setState(() {
              events = state.events;
            });
          }
        }
      },
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus!.unfocus();
        },
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: 20.h,
                  color: Color(0xffBD9691),
                ),
                Expanded(
                  child: Container(
                    color: Color(0xfff2f2f2),
                  ),
                )
              ],
            ),
            Positioned.fill(
              child: SafeArea(
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 8,
                    ),
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
                            text_widget(
                              "All Events",
                              color: Colors.white,
                              fontSize: 18.sp,
                            ),
                            Spacer(),
                            isGrid
                                ? InkWell(
                                    onTap: () {
                                      setState(
                                        () {
                                          isGrid = false;
                                        },
                                      );
                                    },
                                    child: Image.asset(
                                      "assets/icons/list.png",
                                      height: 2.5.h,
                                    ),
                                  )
                                : InkWell(
                                    onTap: () {
                                      setState(
                                        () {
                                          isGrid = true;
                                        },
                                      );
                                    },
                                    child: Image.asset(
                                      "assets/icons/grid.png",
                                      height: 2.5.h,
                                    ),
                                  ),
                            SizedBox(width: 4.w),
                            InkWell(
                              onTap: () {
                                Get.to(
                                  FilterScreen(
                                    searchText: searchText,
                                    location: location,
                                    rangeValues: rangeValues,
                                  ),
                                );
                              },
                              child: Image.asset(
                                "assets/icons/filter.png",
                                height: 2.5.h,
                              ),
                            ),
                            SizedBox(width: 4.w),
                          ],
                        ),
                        SizedBox(height: 5.h),
                        textFieldWithPrefixSuffuxIconAndHintText(
                          "Search Event",
                          controller: searchController,
                          fillColor: Colors.white,
                          isPrefix: true,
                          prefixIcon: "assets/nav/s1.png",
                          mainTxtColor: Colors.black,
                          radius: 12,
                          bColor: Colors.transparent,
                          onSubmitted: (value) {
                            searchText = value;
                            triggerFilteredEvent(context.read<EventBloc>());
                          },
                        ),
                        SizedBox(height: 4.h),
                        isLoading
                            ? Center(child: CircularProgressIndicator())
                            : events.isEmpty
                                ? Expanded(
                                    child: Center(
                                      child: Text("No events"),
                                    ),
                                  )
                                : Expanded(
                                    child: GridView.count(
                                      crossAxisCount: isGrid ? 2 : 1,
                                      crossAxisSpacing: 10.0,
                                      mainAxisSpacing: 10.0,
                                      shrinkWrap: true,
                                      childAspectRatio: isGrid ? 0.8 : 3.3,
                                      children: List.generate(
                                        events.length,
                                        (index) {
                                          final EventModel event =
                                              events[index];

                                          return FutureBuilder(
                                            future: EventRepo().fetchJoinEvent(
                                                eventId: event.id),
                                            builder: (context, snapshot) {
                                              final List<JoinEventModel>
                                                  joinsModel =
                                                  snapshot.data ?? [];

                                              return BlocSelector<EventBloc,
                                                  EventState, bool?>(
                                                selector: (state) {
                                                  if (state
                                                      is EventStateJoined) {
                                                    if (state.joinModel
                                                            .eventId ==
                                                        event.id) {
                                                      joinsModel
                                                          .add(state.joinModel);
                                                      return true;
                                                    }
                                                  }

                                                  return null;
                                                },
                                                builder: (context, isJoined) {
                                                  return isGrid
                                                      ? InkWell(
                                                          onTap: () {
                                                            Get.to(EventView(
                                                                event: event,
                                                                joinsModel:
                                                                    joinsModel));
                                                          },
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12),
                                                                child: SizedBox(
                                                                  height: 10.h,
                                                                  width:
                                                                      Get.width,
                                                                  child:
                                                                      CustomNetworkImage(
                                                                    imageUrl: event
                                                                        .imageUrls
                                                                        .first,
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  height: 1.h),
                                                              text_widget(
                                                                event.title,
                                                                fontSize: 16.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                              SizedBox(
                                                                  height:
                                                                      0.5.h),
                                                              Row(
                                                                children: [
                                                                  Image.asset(
                                                                    "assets/images/p2.png",
                                                                    height:
                                                                        1.4.h,
                                                                  ),
                                                                  SizedBox(
                                                                      width:
                                                                          1.w),
                                                                  Flexible(
                                                                    child:
                                                                        text_widget(
                                                                      "${event.location.city}, ${event.location.country != null ? "${event.location.country}" : ""}",
                                                                      maxline:
                                                                          1,
                                                                      fontSize:
                                                                          12.8.sp,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                  height:
                                                                      0.8.h),
                                                              text_widget(
                                                                "Created by: Hammad Habib",
                                                                fontSize:
                                                                    12.2.sp,
                                                                color: MyColors
                                                                    .primary,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                              SizedBox(
                                                                  height:
                                                                      1.4.h),
                                                              Visibility(
                                                                visible: joinsModel
                                                                        .where((element) =>
                                                                            element.joinerId == UserRepo().currentUser.uid &&
                                                                            element.eventId ==
                                                                                event.id)
                                                                        .length <
                                                                    1,
                                                                child:
                                                                    gradientButton(
                                                                  "Join Event",
                                                                  font: 15,
                                                                  txtColor:
                                                                      MyColors
                                                                          .white,
                                                                  ontap: () {
                                                                    triggerJoinEvent(
                                                                        context.read<
                                                                            EventBloc>(),
                                                                        event
                                                                            .id);
                                                                  },
                                                                  width: 90,
                                                                  height: 3.5,
                                                                  isColor: true,
                                                                  clr: MyColors
                                                                      .primary,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      : eventWidget(
                                                          isEvent: true,
                                                          creator:
                                                              event.createdBy,
                                                          isVisibleJoinButton: joinsModel
                                                                  .where((element) =>
                                                                      element.joinerId ==
                                                                          UserRepo()
                                                                              .currentUser
                                                                              .uid &&
                                                                      element.eventId ==
                                                                          event
                                                                              .id)
                                                                  .length <
                                                              1,
                                                          title: event.title,
                                                          imageUrl: event
                                                              .imageUrls.first,
                                                          address:
                                                              "${event.location.city}, ${event.location.country != null ? "${event.location.country}" : ""}",
                                                          eventId: event.id,
                                                          onClickEvent: () {
                                                            Get.to(
                                                              EventView(
                                                                  event: event,
                                                                  joinsModel:
                                                                      joinsModel),
                                                            );
                                                          },
                                                          onClickJoinButton:
                                                              () {
                                                            triggerJoinEvent(
                                                                context.read<
                                                                    EventBloc>(),
                                                                event.id);
                                                          },
                                                        );
                                                },
                                              );
                                            },
                                          );
                                        },
                                      ),
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
      ),
    );
  }
}
