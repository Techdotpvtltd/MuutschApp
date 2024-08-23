import 'package:flutter/material.dart';
import 'package:musch/config/colors.dart';
import 'package:musch/widgets/request_card.dart';
import 'package:musch/widgets/text_widget.dart';

import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({super.key});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  int current = 0;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 14.h,
                color: Color(0xffBD9691),
              ),
              Expanded(
                  child: Container(
                color: Color(0xfff2f2f2),
              ))
            ],
          ),
          Positioned.fill(
            child: SafeArea(
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18.0, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Remix.arrow_left_s_line,
                                color: Colors.white, size: 4.h),
                            SizedBox(width: 2.w),
                            textWidget("All Request",
                                color: Colors.white, fontSize: 18.sp),
                          ],
                        ),
                        SizedBox(height: 5.h),
                        Row(
                          children: [
                            SizedBox(width: 5.w),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  current = 0;
                                });
                              },
                              child: textWidget("Friend Request ",
                                  fontSize: 15.sp,
                                  color: current == 0
                                      ? MyColors.primary
                                      : Color(0xff000000).withOpacity(0.44)),
                            ),
                            Spacer(),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  current = 1;
                                });
                              },
                              child: textWidget("View Send Request ",
                                  fontSize: 15.sp,
                                  color: current == 1
                                      ? MyColors.primary
                                      : Color(0xff000000).withOpacity(0.44)),
                            ),
                            SizedBox(width: 5.w),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Divider(
                              thickness: 2,
                              color: current == 0
                                  ? MyColors.primary
                                  : Color(0xffD9D9D9),
                            )),
                            Expanded(
                                // flex: 2,
                                child: Divider(
                              thickness: 2,
                              color: current == 1
                                  ? MyColors.primary
                                  : Color(0xffD9D9D9),
                            )),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        requestCard(isAccept: current == 0 ? false : true),
                        requestCard(isAccept: current == 0 ? false : true),
                        requestCard(isAccept: current == 0 ? false : true),
                      ],
                    ),
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
