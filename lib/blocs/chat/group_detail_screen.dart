// Project: 	   muutsch
// File:    	   group_detail_screen
// Path:    	   lib/blocs/chat/group_detail_screen.dart
// Author:       Ali Akbar
// Date:        06-07-24 16:25:42 -- Saturday
// Description:

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:musch/blocs/chat/%20chat_bloc.dart';
import 'package:musch/blocs/chat/chat_event.dart';
import 'package:musch/blocs/chat/chat_state.dart';
import 'package:musch/config/colors.dart';
import 'package:musch/pages/home/friend_view.dart';
import 'package:musch/repos/user_repo.dart';
import 'package:musch/utils/constants/constants.dart';
import 'package:musch/utils/dialogs/dialogs.dart';
import 'package:musch/utils/extensions/date_extension.dart';
import 'package:musch/widgets/avatar_widget.dart';
import 'package:musch/widgets/custom_dropdown.dart';

import '../../models/chat_model.dart';
import '../../models/other_user_model.dart';

class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({super.key, required this.chat});
  final ChatModel chat;
  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  late ChatModel chat = widget.chat;
  late final bool isOwner = UserRepo().currentUser.uid == chat.createdBy;
  final String uid = UserRepo().currentUser.uid;

  void triggerDisabledChat() {
    context
        .read<ChatBloc>()
        .add(ChatEventUpdateVisibilityStatus(status: false, chat: chat));
  }

  void triggerRemoveMember(OtherUserModel member) {
    context
        .read<ChatBloc>()
        .add(ChatEventRemoveMember(member: member, chatId: chat.uuid));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is ChatStateUpdatedStatus) {
          Get.back();
          Get.back();
        }

        if (state is ChatStateMemberRemoved) {
          if (state.memeberId == uid) {
            Get.back();
            Get.back();
          } else {
            final List<String> ids = chat.participantUids;
            final List<OtherUserModel> memebrs = chat.participants;

            ids.removeWhere((e) => state.memeberId == e);
            memebrs.removeWhere((e) => e.uid == state.memeberId);
            setState(() {
              chat = chat.copyWith(participantUids: ids, participants: memebrs);
            });
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            CustomMenuDropdown(
              items: [
                if (isOwner)
                  DropdownMenuModel(
                      title: "Disable Chat", icon: Icons.visibility_off),
                if (!isOwner)
                  DropdownMenuModel(
                      title: "Leave Group",
                      icon: Icons.remove_circle_outline_outlined),
              ],
              onSelectedItem: (item, index) {
                if (item == "Disable Chat") {
                  CustomDialogs().alertBox(
                    title: "Disabled Group",
                    message: "Are you sure to disabled this group?",
                    onPositivePressed: () {
                      triggerDisabledChat();
                    },
                  );
                }

                if (item == "Leave Group") {
                  CustomDialogs().alertBox(
                    title: "Leave",
                    message: "Are you sure to leave from this group?",
                    onPositivePressed: () {
                      triggerRemoveMember(
                          chat.participants.firstWhere((e) => e.uid == uid));
                    },
                  );
                }
              },
              buttonColor: Colors.black,
            ),
          ],
        ),
        body: Column(
          children: [
            AvatarWidget(
              backgroundColor: Colors.black,
              placeholderChar: "G",
              avatarUrl: chat.groupAvatar ?? '',
            ),
            gapH10,
            Text(
              chat.groupTitle ?? "--",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (isOwner)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "You ",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    "Created at ${chat.createdAt.dateToString("dd MMMM yyyy")}",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            if (isOwner) gapH6,
            Text(
              "${chat.participantUids.length} members",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),

            /// Member lists
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 10, right: 10, top: 20),
                margin:
                    EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: ListView.builder(
                  itemCount: chat.participants.length,
                  shrinkWrap: true,
                  itemBuilder: (cxt, index) {
                    final OtherUserModel member = chat.participants[index];

                    return InkWell(
                      onTap: () {
                        Get.to(FriendView(userId: member.uid));
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                AvatarWidget(
                                  backgroundColor: MyColors.primary,
                                  height: 40,
                                  width: 40,
                                  avatarUrl: member.avatarUrl,
                                  placeholderChar:
                                      member.name.characters.firstOrNull ?? "",
                                ),
                                gapW10,
                                Text(
                                  uid == member.uid ? "You" : member.name,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            if (isOwner && uid != member.uid)
                              CustomMenuDropdown(
                                items: [
                                  DropdownMenuModel(
                                    title: "Remove",
                                    icon: Icons.remove,
                                  ),
                                ],
                                buttonColor: Colors.black,
                                onSelectedItem: (item, index) {
                                  CustomDialogs().alertBox(
                                    title: "Remove",
                                    message:
                                        "Are you sure to remove ${member.name} from this group?",
                                    onPositivePressed: () {
                                      triggerRemoveMember(member);
                                    },
                                  );
                                },
                              )
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
    );
  }
}
