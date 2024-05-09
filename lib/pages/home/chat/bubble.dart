import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musch/widgets/text_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../config/colors.dart';

class Bubble extends StatelessWidget {
  Bubble(this.me, this.index, {Key? key, this.voice = false}) : super(key: key);
  bool me, voice;
  int index;

  @override
  Widget build(BuildContext context) => Container(
      margin: EdgeInsets.symmetric(horizontal: 2.2.w, vertical: 2.w),
      child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.end,
          textDirection: me ? TextDirection.rtl : TextDirection.ltr,
          children: [_bubble(context)]));

  Widget _bubble(BuildContext context) => Container(
      constraints: BoxConstraints(maxWidth: 100.w * .6, maxHeight: 12.h),
      padding: EdgeInsets.symmetric(vertical: 2.w),
      child: me
          ? Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Container(
                  // constraints: BoxConstraints(maxWidth: 51.w),
                  padding:
                      EdgeInsets.symmetric(vertical: 2.5.w, horizontal: 1.w),
                  decoration: BoxDecoration(
                      color: MyColors.primary,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15))),
                  child:
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                              width: 50.w,
                              child: Text(
                                  'Hi, where have you been? Let’s do some fun!',
                                  textDirection: TextDirection.ltr,
                                  style: GoogleFonts.poppins(
                                      fontSize: 14.sp,
                                      color: me
                                          ? Colors.white
                                          : Colors.white.withOpacity(0.97))))
                        ])
                  ])),
              Padding(
                  padding: EdgeInsets.only(right: 12.0, top: 5),
                  child: Row(
                    children: [
                      Text('1:' '${index + 30}' ' PM',
                          style: GoogleFonts.poppins(
                              fontSize: 12.8.sp, color: MyColors.grey)),
                      Spacer(),
                      text_widget("Jenifer Alex",
                          fontSize: 13.4.sp, fontWeight: FontWeight.w400),
                      SizedBox(width: 2.w),
                      CircleAvatar(
                        radius: 1.3.h,
                        backgroundColor: MyColors.primary,
                        backgroundImage: AssetImage("assets/images/girl.png"),
                      )
                    ],
                  ))
            ])
          : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                  // constraints: BoxConstraints(maxWidth: 43.w),
                  padding:
                      EdgeInsets.symmetric(vertical: 2.5.w, horizontal: 1.w),
                  decoration: BoxDecoration(
                      color: Color(0xffF7F7F7),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          bottomRight: Radius.circular(15))),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                  width: 50.w,
                                  child: Padding(
                                      padding:
                                          EdgeInsets.only(top: 0.0, left: 13),
                                      child: Text(
                                          'Hi, where have you been? Let’s do some fun!',
                                          textDirection: TextDirection.ltr,
                                          style: GoogleFonts.poppins(
                                              fontSize: 14.sp,
                                              color: me
                                                  ? Colors.black
                                                      .withOpacity(0.97)
                                                  : Colors.black
                                                      .withOpacity(0.7)))))
                            ])
                      ])),
              Padding(
                  padding: EdgeInsets.only(right: 12.0, top: 5),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 1.3.h,
                        backgroundColor: MyColors.primary,
                        backgroundImage: AssetImage("assets/images/girl.png"),
                      ),
                      SizedBox(width: 2.w),
                      text_widget("Jenifer Alex",
                          fontSize: 13.4.sp, fontWeight: FontWeight.w400),
                      Spacer(),
                      Text('1:' '${index + 30}' ' PM',
                          style: GoogleFonts.poppins(
                              fontSize: 12.8.sp, color: MyColors.grey)),
                    ],
                  ))
            ]));
}

class Bubble2 extends StatelessWidget {
  Bubble2(this.me, this.index, {Key? key, this.voice = false})
      : super(key: key);
  bool me, voice;
  int index;

  @override
  Widget build(BuildContext context) => Container(
      margin: EdgeInsets.symmetric(horizontal: 2.2.w, vertical: 2.w),
      child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.end,
          textDirection: me ? TextDirection.rtl : TextDirection.ltr,
          children: [_bubble(context)]));

  Widget _bubble(BuildContext context) => Container(
      constraints: BoxConstraints(maxWidth: 100.w * .7),
      padding: EdgeInsets.symmetric(vertical: 2.w),
      child: me
          ? Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Container(
                  constraints: BoxConstraints(maxWidth: 43.w),
                  padding:
                      EdgeInsets.symmetric(vertical: 2.5.w, horizontal: 1.w),
                  decoration: BoxDecoration(
                      color: MyColors.primary.withOpacity(0.09),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          topRight: Radius.circular(10))),
                  child:
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                              width: 37.w,
                              child: Padding(
                                  padding: EdgeInsets.only(top: 6.0),
                                  child: Text(
                                      'Hi, where have you been? Let’s do some fun!',
                                      textDirection: TextDirection.ltr,
                                      style: GoogleFonts.poppins(
                                          fontSize: 14.sp,
                                          color: MyColors.primary)))),
                        ])
                  ])),
              Padding(
                  padding: EdgeInsets.only(right: 12.0, top: 5),
                  child: Row(
                    children: [
                      Spacer(),
                      Text('1:' '${index + 30}' ' PM',
                          style: GoogleFonts.poppins(
                              fontSize: 12.8.sp, color: MyColors.grey)),
                    ],
                  ))
            ])
          : Column(
              children: [
                Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  CircleAvatar(
                      radius: 1.8.h,
                      backgroundImage: AssetImage("assets/images/cc.png")),
                  SizedBox(width: 1.w),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            constraints: BoxConstraints(maxWidth: 60.w),
                            padding: EdgeInsets.symmetric(
                                vertical: 2.5.w, horizontal: 1.w),
                            decoration: BoxDecoration(
                                color: Color(0xffF3F4F6),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                    bottomRight: Radius.circular(15))),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                            width: 55.w,
                                            child: Padding(
                                                padding: EdgeInsets.only(
                                                    top: 0.0, left: 13),
                                                child: Text(
                                                    'I am ChatGPT, a conversational AI language model developed by OpenAI. I am designed to process natural language and respond to various queries and conversations in a way that simulates human-like conversation. My purpose is to assist and provide helpful responses to users who interact with me.',
                                                    textDirection:
                                                        TextDirection.ltr,
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 14.sp,
                                                        color: me
                                                            ? Colors.black
                                                                .withOpacity(
                                                                    0.97)
                                                            : Colors.black
                                                                .withOpacity(
                                                                    0.7)))))
                                      ])
                                ]))
                      ])
                ]),
                Padding(
                    padding: EdgeInsets.only(right: 12.0, top: 5),
                    child: Row(
                      children: [
                        Spacer(),
                        Text('1:' '${index + 30}' ' PM',
                            style: GoogleFonts.poppins(
                                fontSize: 12.8.sp, color: MyColors.grey)),
                      ],
                    ))
              ],
            ));
}
