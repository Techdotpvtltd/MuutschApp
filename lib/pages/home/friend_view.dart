import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musch/config/colors.dart';
import 'package:musch/pages/home/chat/chat_page.dart';
import 'package:musch/pages/home/filter_screen.dart';
import 'package:musch/widgets/custom_button.dart';
import 'package:musch/widgets/text_widget.dart';

import 'package:readmore/readmore.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../models/user_model.dart';
import '../../widgets/custom_network_image.dart';

class FriendView extends StatelessWidget {
  FriendView(
      {super.key,
      required this.isFriend,
      required this.isChat,
      required this.user});
  final bool isFriend;
  final bool isChat;
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F2F2),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                  child: SizedBox(
                    width: 100.w,
                    height: 48.h,
                    child: CustomNetworkImage(imageUrl: user.avatar),
                  ),
                ),
                Positioned.fill(
                  child: SafeArea(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Image.asset(
                            "assets/icons/arr.png",
                            height: 5.h,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 2.h),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 22.0, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  text_widget(
                    user.name,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: 3.h),
                  text_widget(
                    "Total Children",
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: 0.5.h),
                  Row(
                    children: [
                      for (int index = 0;
                          index <
                              ((user.numberOfChildren ?? 0) > 3
                                  ? 3
                                  : (user.numberOfChildren ?? 0));
                          index++)
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.asset(
                                'assets/images/boy.png',
                                height: 5.h,
                                width: 5.h,
                              ),
                            ),
                            SizedBox(width: .5.w),
                          ],
                        ),
                      if ((user.numberOfChildren ?? 0) > 3)
                        text_widget("+${(user.numberOfChildren ?? 0) - 3}",
                            fontSize: 15.6.sp, fontWeight: FontWeight.w300),
                      SizedBox(width: 1.w),
                      InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              barrierColor: MyColors.primary.withOpacity(0.88),
                              builder: (context) => ChildDetails());
                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                            color: MyColors.primary,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: text_widget(
                            "View Detail",
                            color: Colors.white,
                            fontSize: 13.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.5.h),
                  Row(
                    children: [
                      text_widget("Location",
                          fontSize: 16.sp, fontWeight: FontWeight.w600),
                      Spacer(),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: MyColors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/icons/p3.png",
                              height: 1.7.h,
                            ),
                            SizedBox(width: 1.w),
                            text_widget("1 km",
                                color: MyColors.primary, fontSize: 13.sp),
                            SizedBox(width: 1.w),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 0.5.h),
                  text_widget(
                    user.location?.address ?? "",
                    fontSize: 15.6.sp,
                    fontWeight: FontWeight.w300,
                  ),
                  SizedBox(height: 3.h),
                  text_widget(
                    "About",
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: 0.5.h),
                  ReadMoreText(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam tellus in pretium dignissim Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam tellus in pretium dignissim Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam tellus in pretium dignissim ",
                    trimLines: 3,
                    style: GoogleFonts.poppins(
                        color: Color(0xff000000).withOpacity(0.46),
                        fontWeight: FontWeight.w400),
                    colorClickableText: Colors.pink,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: 'Read all',
                    trimExpandedText: 'Show less',
                    moreStyle: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: MyColors.primary,
                        decoration: TextDecoration.underline),
                    lessStyle: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: MyColors.primary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  text_widget(
                    "Interests",
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: 0.8.h),

                  /// List Of Interests
                  GridView.custom(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 4,
                    ),
                    childrenDelegate: SliverChildBuilderDelegate(
                      childCount: user.interests?.length,
                      (context, index) {
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: text_widget(
                              user.interests?[index] ?? "",
                              textAlign: TextAlign.center,
                              fontWeight: FontWeight.w400,
                              fontSize: 15.5.sp,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 4.h),
                  !isChat
                      ? isFriend
                          ? Row(
                              children: [
                                Expanded(
                                  child: gradientButton("Decline Request",
                                      font: 15.6,
                                      txtColor: MyColors.primary, ontap: () {
                                    // _.loginUser();
                                  },
                                      width: 90,
                                      height: 6.6,
                                      isColor: false,
                                      clr: MyColors.primary),
                                ),
                                SizedBox(width: 2.w),
                                Expanded(
                                  child: gradientButton("Accept Request",
                                      font: 15.6,
                                      txtColor: MyColors.white, ontap: () {
                                    // _.loginUser();
                                  },
                                      width: 90,
                                      height: 6.6,
                                      isColor: true,
                                      clr: MyColors.primary),
                                ),
                              ],
                            )
                          : gradientButton("Send Friend Request",
                              font: 17, txtColor: MyColors.white, ontap: () {
                              // _.loginUser();
                            },
                              width: 90,
                              height: 6.6,
                              isColor: true,
                              clr: MyColors.primary)
                      : isChat
                          ? gradientButton("Chat",
                              font: 17, txtColor: MyColors.white, ontap: () {
                              Get.to(UserChatPage(IsSupport: false));
                              // _.loginUser();
                            },
                              width: 90,
                              height: 6.6,
                              isColor: true,
                              clr: MyColors.primary)
                          : SizedBox(),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
