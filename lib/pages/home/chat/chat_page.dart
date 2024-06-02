import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musch/config/colors.dart';
import 'package:musch/widgets/text_widget.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'bubble.dart';

class UserChatPage extends StatefulWidget {
  final bool IsSupport;

  const UserChatPage({super.key, required this.IsSupport});
  @override
  _UserChatPageState createState() => _UserChatPageState();
}

TextEditingController cont = TextEditingController();

class _UserChatPageState extends State<UserChatPage> {
  @override
  Widget build(BuildContext context) => Stack(
        children: [
          Column(
            children: [
              Container(
                height: 15.h,
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
            child: Scaffold(
              extendBodyBehindAppBar: true,
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: true,
              bottomNavigationBar:
                  _buildMessageComposer(controller: cont, context),
              body: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Icon(
                              Remix.arrow_left_s_line,
                              color: Colors.white,
                              size: 3.5.h,
                            ),
                          ),
                          SizedBox(width: 3.w),
                          CircleAvatar(
                            radius: 3.h,
                            backgroundColor: MyColors.primary,
                            backgroundImage:
                                AssetImage("assets/images/girl.png"),
                          ),
                          SizedBox(width: 3.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              textWidget(
                                "Jenifer Alex",
                                fontSize: 16.4.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              textWidget(
                                "Granactive Retinoid ",
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Expanded(
                      child: _messagesWithUserInfo(context),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      );
  Widget _messagesWithUserInfo(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            // isService?    serviceWidget(context,isPrice: false,isEdit: false):SizedBox(),
            SizedBox(height: 3.h),
            textWidget("Today", fontSize: 15.sp),
            _buildContainer(context)
          ],
        ),
      );

  Widget _buildContainer(BuildContext context) => Expanded(
      child: Container(
          padding: const EdgeInsets.only(top: 18),
          decoration: const BoxDecoration(color: Colors.transparent),
          child: _messagesList(context)));

  Widget _messagesList(BuildContext context) => ListView.builder(
        padding: const EdgeInsets.all(0),
        itemCount: 7,
        itemBuilder: (BuildContext context, int index) => widget.IsSupport
            ? Bubble2(
                index == 1 || index == 3 || index == 6,
                index,
                voice: index == 4 || index == 5,
              )
            : Bubble(
                index == 1 || index == 3 || index == 6,
                index,
                voice: index == 4 || index == 5,
              ),
      );
}

_buildMessageComposer(context, {controller}) {
  return Padding(
    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
    child: SafeArea(
      top: false,
      child: SizedBox(
        width: 100.w,
        child: Row(
          children: [
            SizedBox(width: 1.w),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: TextField(
                    style: GoogleFonts.roboto(
                        fontSize: 16.sp, color: Colors.black),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      suffixIconConstraints: BoxConstraints(minWidth: 12.w),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            "assets/icons/mic.png",
                            height: 2.4.h,
                          ),
                          SizedBox(width: 4.w),
                          Image.asset(
                            "assets/icons/send.png",
                            height: 2.4.h,
                          ),
                          SizedBox(width: 4.w),
                        ],
                      ),
                      hintText: "Write Here",
                      hintStyle: GoogleFonts.poppins(
                        color: Colors.black54,
                        fontSize: 15.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 1.w)
          ],
        ),
      ),
    ),
  );
}
