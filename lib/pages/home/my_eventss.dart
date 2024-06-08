import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:musch/pages/home/add_event.dart';
import 'package:musch/widgets/text_widget.dart';

import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../blocs/event/event_bloc.dart';
import '../../blocs/event/event_state.dart';
import '../../blocs/event/events_event.dart';
import '../../models/event_model.dart';
import '../../utils/constants/app_theme.dart';
import '../../utils/constants/constants.dart';
import '../../utils/dialogs/dialogs.dart';
import '../../widgets/custom_network_image.dart';
import '../../widgets/text_field.dart';
import 'event_detail.dart';

class MyEvents extends StatefulWidget {
  const MyEvents({super.key});

  @override
  State<MyEvents> createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> {
  bool isLoading = true;
  List<EventModel> events = [];
  List<EventModel> filteredEvents = [];

  void triggerFetchOwnEvents(EventBloc bloc) {
    bloc.add(EventsEventFetchOwn());
  }

  @override
  void initState() {
    triggerFetchOwnEvents(context.read<EventBloc>());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EventBloc, EventState>(
      listener: (context, state) {
        /// Update Event States
        if (state is EventStateUpdated) {
          final int index = events
              .indexWhere((element) => element.id == state.updatedEvent.id);
          if (index > -1) {
            setState(() {
              events[index] = state.updatedEvent;
            });
          }
          filteredEvents = events;
        }

        /// Created Event States
        if (state is EventStateCreated) {
          setState(() {
            events.insert(0, state.event);
            filteredEvents = events;
          });
        }

        /// Deleted Events States
        if (state is EventStateDeleted) {
          setState(() {
            events.removeWhere((element) => element.id == state.eventId);
            filteredEvents = events;
          });
        }

        /// Fetching Events States
        if (state is EventStateOwnFetching ||
            state is EventStateOwnFetched ||
            state is EventStateOwnFetchFailure) {
          setState(() {
            isLoading = state.isLoading;
          });

          if (state is EventStateOwnFetchFailure) {
            CustomDialogs().errorBox(message: state.exception.message);
          }

          if (state is EventStateOwnFetched) {
            setState(() {
              events = state.events;
              filteredEvents = events;
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
                floatingActionButton: InkWell(
                  onTap: () {
                    Get.to(AddEvent());
                  },
                  child: FloatingActionButton(
                    onPressed: () {
                      Get.to(AddEvent());
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    backgroundColor: Colors.white,
                    child: Icon(
                      Remix.add_line,
                      color: Color(0xffFFAD85),
                    ),
                  ),
                ),
                backgroundColor: Colors.transparent,
                body: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
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
                            "My Events",
                            color: Colors.white,
                            fontSize: 18.sp,
                          ),
                        ],
                      ),
                      SizedBox(height: 5.h),
                      textFieldWithPrefixSuffuxIconAndHintText(
                        "Search Event",
                        fillColor: Colors.white,
                        isPrefix: true,
                        prefixIcon: "assets/nav/s1.png",
                        mainTxtColor: Colors.black,
                        radius: 12,
                        onSubmitted: (search) {
                          setState(() {
                            if (search == "") {
                              filteredEvents = events;
                            } else {
                              filteredEvents = events
                                  .where((element) => element.title
                                      .toLowerCase()
                                      .contains(search.toLowerCase()))
                                  .toList();
                            }
                          });
                        },
                        bColor: Colors.transparent,
                      ),
                      Expanded(
                        child: isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: AppTheme.primaryColor1,
                                ),
                              )
                            : Center(
                                child: filteredEvents.isEmpty
                                    ? Text("No Events.")
                                    : ListView.builder(
                                        itemCount: filteredEvents.length,
                                        padding: EdgeInsets.only(
                                            top: 20, bottom: 60),
                                        itemBuilder: (context, index) {
                                          final EventModel event =
                                              filteredEvents[index];

                                          return InkWell(
                                            onTap: () {
                                              // Get.to(EditEvent());
                                              Get.to(
                                                EventView(
                                                  event: event,
                                                  isFromMyEvents: true,
                                                  joinMembers:
                                                      event.joinMemberDetails,
                                                ),
                                              );
                                            },
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 10),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 12, vertical: 10),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  12,
                                                ),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      12,
                                                    ),
                                                    child: SizedBox(
                                                      height:
                                                          SCREEN_HEIGHT * 0.2,
                                                      width: SCREEN_WIDTH,
                                                      child: CustomNetworkImage(
                                                        imageUrl: event
                                                                .imageUrls
                                                                // ignore: sdk_version_since
                                                                .firstOrNull ??
                                                            '',
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 1.h),
                                                  textWidget(
                                                    event.title,
                                                    fontSize: 16.sp,
                                                    maxline: 2,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  SizedBox(height: 0.5.h),
                                                  Row(
                                                    children: [
                                                      Image.asset(
                                                        "assets/icons/p5.png",
                                                        height: 1.4.h,
                                                      ),
                                                      SizedBox(width: 1.w),
                                                      Expanded(
                                                        child: textWidget(
                                                          event.location
                                                                  .address ??
                                                              "",
                                                          fontSize: 12.8.sp,
                                                          maxline: 1,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
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
    );
  }
}
