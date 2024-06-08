import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:musch/config/colors.dart';
import 'package:musch/widgets/text_widget.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../blocs/message/mesaage_bloc.dart';
import '../../../blocs/message/message_event.dart';
import '../../../blocs/message/message_state.dart';
import '../../../models/chat_model.dart';
import '../../../models/light_user_model.dart';
import '../../../models/message_model.dart';
import '../../../repos/user_repo.dart';
import '../../../utils/constants/constants.dart';
import '../../../widgets/avatar_widget.dart';
import '../../../widgets/my_image_picker.dart';
import 'bubble_widget.dart';

class UserChatPage extends StatefulWidget {
  const UserChatPage({super.key, required this.chat});
  final ChatModel chat;
  @override
  _UserChatPageState createState() => _UserChatPageState();
}

TextEditingController messageController = TextEditingController();

class _UserChatPageState extends State<UserChatPage> {
  late final LightUserModel friend = widget.chat.participants
      .firstWhere((element) => element.uid != UserRepo().currentUser.uid);

  void triggerSenderMediaMessageEvent(
      {required String fileUrl, required String contentType}) {
    context.read<MessageBloc>().add(MessageEventSend(
        content: fileUrl,
        type: MessageType.photo,
        conversationId: widget.chat.uuid,
        friendId: friend.uid));
  }

  void onMediaPressed() {
    final MyImagePicker imagePicker = MyImagePicker();
    imagePicker.pick();
    imagePicker.onSelection((exception, data) {
      if (data is XFile) {
        triggerSenderMediaMessageEvent(
            fileUrl: data.path, contentType: "image/jpeg");
      }
    });
  }

  void triggerSenderMessageEvent() {
    context.read<MessageBloc>().add(MessageEventSend(
        content: messageController.text,
        type: MessageType.text,
        conversationId: widget.chat.uuid,
        friendId: friend.uid));
  }

  @override
  Widget build(BuildContext context) => BlocListener<MessageBloc, MessageState>(
        listener: (context, state) {
          if (state is MessageStateSent ||
              state is MessageStateSending ||
              state is MessageStateSendFailure) {
            messageController.clear();
          }
        },
        child: Stack(
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
                            AvatarWidget(
                              height: 60,
                              width: 60,
                              placeholderChar:
                                  (widget.chat.groupTitle ?? friend.name)
                                      .characters
                                      .first,
                              avatarUrl:
                                  widget.chat.groupAvatar ?? friend.avatarUrl,
                            ),
                            SizedBox(width: 3.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                textWidget(
                                  friend.name,
                                  fontSize: 16.4.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                                // textWidget(
                                //   "",
                                //   fontSize: 14.sp,
                                //   fontWeight: FontWeight.w400,
                                //   color: Colors.white,
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Expanded(
                          child:
                              BubbleWidget(conversationId: widget.chat.uuid)),
                      gapH10,
                      MessageTextField(
                        messageController: messageController,
                        onMediaPickerPressed: () {
                          onMediaPressed();
                        },
                        onSendPressed: () {
                          triggerSenderMessageEvent();
                        },
                      ),
                      gapH30,
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      );
}

class MessageTextField extends StatelessWidget {
  const MessageTextField(
      {super.key,
      required this.messageController,
      required this.onSendPressed,
      required this.onMediaPickerPressed});
  final TextEditingController messageController;
  final VoidCallback onSendPressed;
  final VoidCallback onMediaPickerPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 29),
      child: TextField(
        maxLines: 6,
        minLines: 1,
        controller: messageController,
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        clipBehavior: Clip.hardEdge,
        style: GoogleFonts.plusJakartaSans(
          color: Colors.black,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 30),
          filled: true,
          fillColor: Colors.white,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: MyColors.primary,
              width: 1,
            ),
            borderRadius: BorderRadius.all(Radius.circular(54)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
              width: 1,
            ),
            borderRadius: BorderRadius.all(Radius.circular(54)),
          ),
          hintText: "Send a message",
          hintStyle: GoogleFonts.plusJakartaSans(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: InkWell(
            onTap: () {
              onMediaPickerPressed();
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 10),
              child: Icon(
                Icons.file_present,
                color: MyColors.primary,
              ),
            ),
          ),
          suffixIcon: InkWell(
            onTap: () {
              onSendPressed();
            },
            child: Padding(
              padding: EdgeInsets.only(left: 20, right: 10),
              child: Icon(
                Icons.send,
                color: MyColors.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
