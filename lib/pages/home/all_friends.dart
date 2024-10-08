import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import 'package:musch/config/colors.dart';
import 'package:musch/pages/home/friend_view.dart';
import 'package:musch/widgets/text_field.dart';
import 'package:musch/widgets/text_widget.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../blocs/friend/friend_bloc.dart';
import '../../blocs/friend/friend_event.dart';
import '../../blocs/friend/friend_state.dart';
import '../../models/friend_model.dart';
import '../../models/user_model.dart';
import '../../repos/user_repo.dart';

class AllFriends extends StatefulWidget {
  const AllFriends({super.key, this.isRequestFriendScreen = false});
  final bool isRequestFriendScreen;
  @override
  State<AllFriends> createState() => _AllFriendsState();
}

class _AllFriendsState extends State<AllFriends> {
  List<FriendModel> friends = [];
  List<FriendModel> filteredFriends = [];
  List<UserModel> filteredUsers = [];

  void triggerFetchFriends(FriendBloc bloc) {
    bloc.add(widget.isRequestFriendScreen
        ? FriendEventFetchPendingRequests()
        : FriendEventFetchFriends());
  }

  void triggerAcceptedFriendRequestEvent(FriendBloc bloc, String friendId) {
    bloc.add(FriendEventAccept(friendId: friendId));
  }

  @override
  void initState() {
    triggerFetchFriends(context.read<FriendBloc>());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FriendBloc, FriendState>(
      listener: (context, state) {
        if (state is FriendStateRemoved) {
          filteredFriends
              .removeWhere((element) => element.uuid == state.friendId);

          setState(() {
            filteredFriends = filteredFriends;
          });
        }
        if (state is FriendStateFetchedFriends) {
          friends.clear();
          filteredFriends.clear();
          setState(() {
            friends = state.friends;
            filteredFriends = state.friends;
          });
        }
        if (state is FriendStateFetchedPendingRequests) {
          friends.clear();
          filteredFriends.clear();
          setState(() {
            friends = state.friends;
            filteredFriends = state.friends;
          });
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
                              textWidget(
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
                            onSubmitted: (search) {
                              setState(
                                () {
                                  if (search == "") {
                                    filteredFriends = friends;
                                  } else {
                                    final users = filteredUsers.where(
                                        (element) => element.name
                                            .toLowerCase()
                                            .contains(search.toLowerCase()));
                                    if (users.isEmpty) {
                                      filteredFriends = [];
                                    }
                                    for (final user in users) {
                                      filteredFriends = friends
                                          .where((element) => element
                                              .participants
                                              .contains(user.uid))
                                          .toList();
                                    }
                                  }
                                },
                              );
                            },
                            bColor: Colors.transparent,
                          ),
                          SizedBox(height: 3.h),
                          Row(
                            children: [
                              textWidget(
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
                                  child: textWidget(
                                    "${filteredFriends.length}",
                                    color: Colors.white,
                                    fontSize: 15.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 3.h),
                          if (filteredFriends.isEmpty)
                            Center(
                              child: Text(
                                  "No ${widget.isRequestFriendScreen ? "Friend Requests" : "Friends"} found."),
                            ),
                          if (filteredFriends.isNotEmpty)
                            ...List.generate(
                              filteredFriends.length,
                              (index) => FutureBuilder<UserModel?>(
                                future: UserRepo().fetchUser(
                                    profileId: filteredFriends[index]
                                        .participants
                                        .firstWhere((e) =>
                                            e != UserRepo().currentUser.uid)),
                                builder: (context, snapshot) {
                                  final String userId = filteredFriends[index]
                                      .participants
                                      .firstWhere((e) =>
                                          e != UserRepo().currentUser.uid);

                                  final UserModel? user = snapshot.data;
                                  if (user != null) {
                                    filteredUsers.add(user);
                                  }

                                  return InkWell(
                                    onTap: () {
                                      if (user != null)
                                        Get.to(
                                          FriendView(
                                            userId: userId,
                                            friend: filteredFriends[index],
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
                                          borderRadius:
                                              BorderRadius.circular(12),
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
                                            title: textWidget(
                                              user?.name ?? "---",
                                              fontSize: 16.5.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            trailing: Visibility(
                                              visible: widget
                                                      .isRequestFriendScreen &&
                                                  friends[index].type ==
                                                      FriendType.request,
                                              child: IconButton(
                                                onPressed: () {
                                                  triggerAcceptedFriendRequestEvent(
                                                      context
                                                          .read<FriendBloc>(),
                                                      filteredFriends[index]
                                                          .uuid);
                                                },
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
                            ),
                        ],
                      ),
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
