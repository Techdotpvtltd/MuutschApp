// Project: 	   muutsch
// File:    	   event_member_list
// Path:    	   lib/pages/home/event_member_list.dart
// Author:       Ali Akbar
// Date:        29-05-24 12:04:55 -- Wednesday
// Description:

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../config/colors.dart';
import '../../models/join_event_model.dart';
import '../../repos/user_repo.dart';
import '../../widgets/text_widget.dart';
import 'friend_view.dart';

class EventMemberList extends StatelessWidget {
  const EventMemberList({super.key, required this.joinsModel});
  final List<JoinMemberModel> joinsModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          backgroundColor: Color(0xfff2f2f2),
          title: Text("Members"),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 18.0,
          vertical: 8,
        ),
        child: joinsModel.isEmpty
            ? Center(
                child: Text(
                  "Oops!\nOur system couldn't locate any members.",
                  textAlign: TextAlign.center,
                ),
              )
            : ListView.builder(
                itemCount: joinsModel.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                    ),
                    child: InkWell(
                      onTap: () {
                        Get.to(
                          FriendView(userId: joinsModel[index].joinerId),
                        );
                      },
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
                              backgroundImage:
                                  NetworkImage(joinsModel[index].avatar),
                            ),
                            title: text_widget(
                              UserRepo().currentUser.uid ==
                                      joinsModel[index].joinerId
                                  ? "You"
                                  : joinsModel[index].name,
                              fontSize: 16.5.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            // trailing: Visibility(
                            //   visible: widget.isRequestFriendScreen &&
                            //       friends[index].type ==
                            //           FriendType.request,
                            //   child: IconButton(
                            //     onPressed: () {
                            //       triggerAcceptedFriendRequestEvent(
                            //           context.read<FriendBloc>(),
                            //           filteredFriends[index].uuid);
                            //     },
                            //     icon: Icon(
                            //       Icons.check,
                            //       color: MyColors.primary,
                            //     ),
                            //   ),
                            // ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
