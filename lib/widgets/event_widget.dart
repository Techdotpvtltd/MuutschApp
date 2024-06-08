import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musch/config/colors.dart';
import 'package:musch/widgets/text_widget.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

import '../blocs/event/event_bloc.dart';
import '../blocs/event/event_state.dart';
import 'custom_network_image.dart';

Widget eventWidget({
  bool isEvent = false,
  required String title,
  required String imageUrl,
  required String address,
  required String eventId,
  required VoidCallback onClickEvent,
  required VoidCallback onClickJoinButton,
  required String creator,
  bool isVisibleJoinButton = true,
}) {
  return BlocListener<EventBloc, EventState>(
    listener: (context, state) {
      if (state is EventStateJoined) {
        isVisibleJoinButton = false;
      }
    },
    child: InkWell(
      onTap: onClickEvent,
      child: Container(
        decoration: isEvent
            ? BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(12))
            : BoxDecoration(),
        child: Padding(
          padding: EdgeInsets.all(isEvent ? 12.0 : 0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  height: 8.5.h,
                  width: 10.h,
                  child: CustomNetworkImage(imageUrl: imageUrl),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textWidget(
                      title,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        Image.asset(
                          "assets/images/p2.png",
                          height: 1.4.h,
                        ),
                        SizedBox(width: 1.w),
                        Expanded(
                          child: textWidget(
                            address,
                            fontSize: 12.8.sp,
                            maxline: 1,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 0.8.h),
                    textWidget(
                      "Created by: $creator",
                      fontSize: 12.2.sp,
                      color: MyColors.primary,
                      fontWeight: FontWeight.w600,
                    )
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  onClickJoinButton();
                },
                child: Visibility(
                  visible: isVisibleJoinButton,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    decoration: BoxDecoration(
                      color: MyColors.primary,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: textWidget(
                      "Join",
                      color: Colors.white,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
