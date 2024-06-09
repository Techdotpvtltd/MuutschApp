import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musch/utils/extensions/date_extension.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../blocs/message/mesaage_bloc.dart';
import '../../../blocs/message/message_event.dart';
import '../../../blocs/message/message_state.dart';
import '../../../config/colors.dart';
import '../../../models/message_model.dart';
import '../../../repos/message_repo.dart';
import '../../../repos/user_repo.dart';
import '../../../utils/constants/constants.dart';
import '../../../widgets/custom_network_image.dart';

class BubbleWidget extends StatefulWidget {
  const BubbleWidget({super.key, required this.conversationId});
  final String conversationId;
  @override
  State<BubbleWidget> createState() => _BubbleWidgetState();
}

class _BubbleWidgetState extends State<BubbleWidget> {
  bool isLoading = false;
  List<GroupedMessageModel> messages = MessageRepo().messages;

  Widget getMessageCell(MessageModel message) {
    final String userId = UserRepo().currentUser.uid;
    Widget currentWidget = SizedBox();

    if (message.senderId == userId) {
      switch (message.type) {
        case MessageType.text:
          currentWidget = _getBubble(BubbleMessageType.textSender, message);
          break;
        case MessageType.photo:
          currentWidget = _getBubble(BubbleMessageType.imageSender, message);
          break;
        case MessageType.video:
          currentWidget = _getBubble(BubbleMessageType.videoSender, message);
          break;
      }
    } else {
      switch (message.type) {
        case MessageType.text:
          currentWidget = _getBubble(BubbleMessageType.textReciever, message);
          break;
        case MessageType.photo:
          currentWidget = _getBubble(BubbleMessageType.imageReciever, message);
          break;
        case MessageType.video:
          currentWidget = _getBubble(BubbleMessageType.videoReciever, message);
          break;
      }
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: currentWidget,
    );
  }

  void triggerConversationFetchEvent() {
    context
        .read<MessageBloc>()
        .add(MessageEventFetch(conversationId: widget.conversationId));
  }

  @override
  void initState() {
    triggerConversationFetchEvent();
    super.initState();
  }

  @override
  void dispose() {
    MessageRepo().onDisposed();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MessageBloc, MessageState>(
      listener: (context, state) {
        if (state is MessageStateFetchFailure ||
            state is MessageStateFetching ||
            state is MessageStateFetched ||
            state is MessageStatePrepareToSend) {
          setState(() {
            isLoading = state.isLoading;
          });

          if (state is MessageStateFetched ||
              state is MessageStatePrepareToSend) {
            setState(() {
              messages = MessageRepo().messages;
            });
          }
        }
      },
      child: ListView.builder(
        itemCount: messages.length,
        reverse: true,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                messages[index].date.formatChatDateToString(),
                style: GoogleFonts.plusJakartaSans(
                  color: Color(0xFF7C7C7C),
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                ),
              ),
              for (final message in messages[index].messages)
                getMessageCell(message),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _getBubble(BubbleMessageType messageType, MessageModel message) {
  switch (messageType) {
    // ===========================Product Cell================================
    case BubbleMessageType.product:
      return Container(
        width: SCREEN_WIDTH,
        height: SCREEN_HEIGHT * 0.21,
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(
          color: Color(0xFFF5F6FB),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Image.asset(
                  "assets/images/boy.png",
                  height: constraints.maxHeight * 0.74,
                  width: constraints.maxWidth,
                  fit: BoxFit.fill,
                ),
                Padding(
                  padding:
                      EdgeInsets.only(top: 16, left: 8, right: 8, bottom: 3),
                  child: Text(
                    "Bentley luxury Car",
                    style: GoogleFonts.plusJakartaSans(
                      color: MyColors.txtclr2,
                      fontSize: 14.45,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );

    // ===========================Text Reciever Cell================================
    case BubbleMessageType.textReciever:
      return Align(
        alignment: Alignment.centerLeft,
        child: SizedBox(
          width: SCREEN_WIDTH,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                decoration: const BoxDecoration(
                  color: Color(0xFFF7F7F7),
                  borderRadius: BorderRadius.all(Radius.circular(11)),
                ),
                child: Text(
                  message.content,
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFF6B6B6B),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              gapH6,
              Row(
                children: [
                  Text(
                    // ignore: sdk_version_since
                    message.senderName,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF7C7C7C),
                    ),
                  ),
                  gapW20,
                  Text(
                    message.messageTime.dateToString("hh:mm a"),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 9,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF7C7C7C),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );

    // ===========================Text Sender Cell================================
    case BubbleMessageType.textSender:
      return Align(
        alignment: Alignment.centerRight,
        child: SizedBox(
          width: SCREEN_WIDTH * 0.7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                decoration: BoxDecoration(
                  color: MyColors.primary,
                  borderRadius: BorderRadius.all(Radius.circular(11)),
                ),
                child: Text(
                  message.content,
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              gapH6,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    message.messageTime.dateToString("hh:mm a"),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 9,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF7C7C7C),
                    ),
                  ),
                  gapW10,
                  message.conversationId != ""
                      ? SvgPicture.asset(
                          "assets/icons/double-check-ic.svg",
                          colorFilter: ColorFilter.mode(
                              MyColors.primary, BlendMode.srcIn),
                        )
                      : SizedBox(
                          width: 10,
                          height: 10,
                          child: CircularProgressIndicator(
                            color: MyColors.primary,
                            strokeWidth: 1,
                          ),
                        ),
                  // Row(
                  //   children: [
                  //     Text(
                  //       "Ali Akbar",
                  //       style: GoogleFonts.plusJakartaSans(
                  //         fontSize: 10.28,
                  //         fontWeight: FontWeight.w400,
                  //         color: Color(0xFF1E1E1E),
                  //       ),
                  //     ),
                  //     gapW6,
                  //     CircleAvatar(
                  //       radius: 12,
                  //       backgroundImage: AssetImage("assets/images/boy.png"),
                  //     ),
                  //   ],
                  // ),
                ],
              )
            ],
          ),
        ),
      );

    // ===========================Image Sender Cell================================
    case BubbleMessageType.imageSender:
      return Align(
        alignment: Alignment.centerRight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              width: 60.w,
              decoration: BoxDecoration(
                color: MyColors.primary,
                borderRadius: BorderRadius.all(
                  Radius.circular(11),
                ),
              ),
              child: Container(
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(11),
                  ),
                ),
                child: CustomNetworkImage(imageUrl: message.content),
              ),
            ),
            gapH6,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  message.messageTime.dateToString("hh:mm a"),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    color: MyColors.primary,
                  ),
                ),
                gapW6,
                message.conversationId != ""
                    ? SvgPicture.asset(
                        "assets/icons/double-check-ic.svg",
                        colorFilter:
                            ColorFilter.mode(MyColors.primary, BlendMode.srcIn),
                      )
                    : SizedBox(
                        width: 10,
                        height: 10,
                        child: CircularProgressIndicator(
                          color: MyColors.primary,
                          strokeWidth: 1,
                        ),
                      ),
              ],
            )
          ],
        ),
      );
    // ===========================Image Reciever Cell================================
    case BubbleMessageType.imageReciever:
      return Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 60.w,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Colors.grey[500],
                borderRadius: const BorderRadius.all(
                  Radius.circular(11),
                ),
              ),
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(11),
                  ),
                ),
                child: CustomNetworkImage(imageUrl: message.content),
              ),
            ),
            gapH6,
            Text(
              message.messageTime.dateToString("hh:mm a"),
              style: GoogleFonts.plusJakartaSans(
                fontSize: 9,
                fontWeight: FontWeight.w400,
                color: Color(0xFF7C7C7C),
              ),
            ),
          ],
        ),
      );

    // ===========================Other Cell================================
    default:
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Text(
          "Your app doesn't support this message. Please update the app to see the message.",
          style: GoogleFonts.plusJakartaSans(
            color: Color(0xFF1E1E1E),
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
      );
  }
}

enum BubbleMessageType {
  product,
  textSender,
  textReciever,
  imageSender,
  imageReciever,
  videoSender,
  videoReciever,
}
