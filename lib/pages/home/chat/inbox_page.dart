import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musch/config/colors.dart';
import 'package:musch/pages/home/bottom_navigation.dart';
import 'package:musch/pages/home/chat/chat_page.dart';
import 'package:musch/widgets/text_field.dart';
import 'package:musch/widgets/text_widget.dart';

import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class InboxPage extends StatefulWidget {
  final VoidCallback updateParentState; // Define callback
  const InboxPage({Key? key, required this.updateParentState})
      : super(key: key);

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
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
                height: 18.h,
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
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    current = 0;
                                  });
                                  Get.find<NavScreenController>()
                                      .controller
                                      .jumpToTab(current);
                                  widget.updateParentState();
                                  setState(() {});
                                },
                                child: Icon(
                                  Remix.arrow_left_s_line,
                                  color: Colors.white,
                                  size: 3.h,
                                )),
                            SizedBox(width: 2.w),
                            text_widget("Chat",
                                color: Colors.white, fontSize: 18.sp),
                          ],
                        ),
                        SizedBox(height: 3.h),
                        textFieldWithPrefixSuffuxIconAndHintText(
                          "Search ",
                          // controller: _.password,
                          fillColor: Colors.white,
                          isPrefix: true,
                          prefixIcon: "assets/nav/s1.png",
                          mainTxtColor: Colors.black,
                          radius: 12,
                          bColor: Colors.transparent,
                        ),
                        SizedBox(height: 3.h),
                        ...List.generate(5, (index) => chatList(index))
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

Widget chatList(index) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: InkWell(
      onTap: () {
        Get.to(UserChatPage(
          IsSupport: false,
        ));
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          // isThreeLine: true,
          leading: CircleAvatar(
            backgroundColor: MyColors.primary,
            radius: 2.8.h,
            backgroundImage: AssetImage("assets/images/girl.png"),
          ),
          title: text_widget(
            "Jane Cooper",
            fontWeight: FontWeight.w500,
            fontSize: 16.sp,
          ),
          subtitle: text_widget("Hi! How Are You Doing",
              fontSize: 14.4.sp, color: Color(0xff9CA3AF)),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 1.h),
              text_widget("54 min Ago",
                  fontSize: 13.5.sp, color: Color(0xff9CA3AF)),
              SizedBox(height: 1.h),
              CircleAvatar(
                radius: 1.h,
                backgroundColor: MyColors.primary,
                child: text_widget("2", color: Colors.white, fontSize: 13.6.sp),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    ),
  );
}
