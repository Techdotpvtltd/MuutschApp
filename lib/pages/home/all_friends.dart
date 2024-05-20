import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:musch/config/colors.dart';
import 'package:musch/pages/home/friend_view.dart';
import 'package:musch/widgets/text_field.dart';
import 'package:musch/widgets/text_widget.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../models/friend_model.dart';
import '../../models/user_model.dart';
import '../../repos/user_repo.dart';

class AllFriends extends StatefulWidget {
  const AllFriends(
      {super.key, required this.friends, this.isRequestFriendScreen = false});
  final List<FriendModel> friends;
  final bool isRequestFriendScreen;
  @override
  State<AllFriends> createState() => _AllFriendsState();
}

class _AllFriendsState extends State<AllFriends> {
  late final List<FriendModel> friends = widget.friends;
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
                ),
              )
            ],
          ),
          Positioned.fill(
            child: SafeArea(
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18.0,
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
                              widget.isRequestFriendScreen
                                  ? "Requests"
                                  : "Friends",
                              color: Colors.white,
                              fontSize: 18.sp,
                            ),
                          ],
                        ),
                        SizedBox(height: 3.h),
                        textFieldWithPrefixSuffuxIconAndHintText(
                          "Search ",
                          fillColor: Colors.white,
                          isPrefix: true,
                          prefixIcon: "assets/nav/s1.png",
                          mainTxtColor: Colors.black,
                          radius: 12,
                          bColor: Colors.transparent,
                        ),
                        SizedBox(height: 3.h),
                        Row(
                          children: [
                            text_widget(
                              widget.isRequestFriendScreen
                                  ? "Requests"
                                  : "Friends",
                              fontSize: 16.5.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            SizedBox(width: 3.w),
                            Container(
                              decoration: BoxDecoration(
                                color: MyColors.primary,
                                borderRadius: BorderRadius.circular(36),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18.0,
                                  vertical: 6,
                                ),
                                child: text_widget(
                                  "${friends.length}",
                                  color: Colors.white,
                                  fontSize: 15.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 3.h),
                        ...List.generate(
                          friends.length,
                          (index) => FutureBuilder<UserModel?>(
                            future: UserRepo()
                                .fetchUser(profileId: friends[index].senderId),
                            builder: (context, snapshot) {
                              final UserModel? user = snapshot.data;

                              return InkWell(
                                onTap: () {
                                  if (user != null)
                                    Get.to(
                                      FriendView(
                                        isFriend: false,
                                        isChat: true,
                                        user: user,
                                        friend: friends[index],
                                      ),
                                    );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 4.0,
                                      ),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: MyColors.primary,
                                          radius: 2.4.h,
                                          backgroundImage: NetworkImage(
                                            user?.avatar ?? "",
                                          ),
                                        ),
                                        title: text_widget(
                                          user?.name ?? "---",
                                          fontSize: 16.5.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        trailing: Visibility(
                                          visible:
                                              widget.isRequestFriendScreen &&
                                                  friends[index].type ==
                                                      FriendType.request,
                                          child: IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                              Icons.check,
                                              color: MyColors.primary,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
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
