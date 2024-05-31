import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:musch/config/colors.dart';
import 'package:musch/pages/home/bottom_navigation.dart';
import 'package:musch/pages/home/chat/chat_page.dart';
import 'package:musch/widgets/text_field.dart';
import 'package:musch/widgets/text_widget.dart';

import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../blocs/chat/ chat_bloc.dart';
import '../../../blocs/chat/chat_event.dart';
import '../../../blocs/chat/chat_state.dart';
import '../../../models/chat_model.dart';
import '../../../models/light_user_model.dart';
import '../../../repos/chat_repo.dart';
import '../../../repos/user_repo.dart';
import '../../../widgets/avatar_widget.dart';

class InboxPage extends StatefulWidget {
  final VoidCallback updateParentState; // Define callback
  const InboxPage({Key? key, required this.updateParentState})
      : super(key: key);

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  bool isLoading = false;
  List<ChatModel> filteredChats = [];

  void triggerFetchChatsEvent(ChatBloc bloc) {
    bloc.add(ChatEventFetchAll());
  }

  void applyFiltered({String? withText}) {
    if (withText == null || withText == "") {
      setState(() {
        filteredChats = ChatRepo().chats;
      });
    }
  }

  @override
  void initState() {
    triggerFetchChatsEvent(context.read<ChatBloc>());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is ChatStateFetchingAll ||
            state is ChatStateFetchAllFailure ||
            state is ChatStateFetchedAll) {
          setState(() {
            isLoading = state.isLoading;
          });

          if (state is ChatStateFetchedAll) {
            applyFiltered();
          }

          if (state is ChatStateFetchAllFailure) {}
        }
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
                body: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
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
                            ),
                          ),
                          SizedBox(width: 2.w),
                          text_widget(
                            "Chat",
                            color: Colors.white,
                            fontSize: 18.sp,
                          ),
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
                      Expanded(
                        child: isLoading
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : ListView.builder(
                                itemCount: filteredChats.length,
                                itemBuilder: (context, index) {
                                  return chatList(chat: filteredChats[index]);
                                },
                              ),
                      ),
                    ],
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

Widget chatList({required ChatModel chat}) {
  LightUserModel? senderUser;
  if (!chat.isGroup) {
    senderUser = chat.participants
        .firstWhere((e) => e.uid != UserRepo().currentUser.uid);
  }
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: InkWell(
      onTap: () {
        Get.to(
          UserChatPage(
            IsSupport: false,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          // isThreeLine: true,
          leading: SizedBox(
            height: 50,
            width: 50,
            child: AvatarWidget(
                placeholderChar:
                    ((chat.isGroup ? chat.groupTitle : senderUser?.name) ?? "")
                        .characters
                        .first,
                avatarUrl:
                    (chat.isGroup ? chat.groupAvatar : senderUser?.avatarUrl) ??
                        ""),
          ),
          title: text_widget(
            (chat.isGroup ? chat.groupTitle : senderUser?.name) ?? "",
            fontWeight: FontWeight.w500,
            fontSize: 16.sp,
          ),
          subtitle: text_widget(
            "",
            fontSize: 14.4.sp,
            color: Color(0xff9CA3AF),
          ),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 1.h),
              text_widget(
                "---",
                fontSize: 13.5.sp,
                color: Color(
                  0xff9CA3AF,
                ),
              ),
              SizedBox(height: 1.h),
              CircleAvatar(
                radius: 1.h,
                backgroundColor: MyColors.primary,
                child: text_widget(
                  "1",
                  color: Colors.white,
                  fontSize: 13.6.sp,
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    ),
  );
}
