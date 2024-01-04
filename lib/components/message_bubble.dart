import 'package:flash_chat_starting_project/constants.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message, sender;
  final bool isMe;
  const MessageBubble(
      {required this.message, required this.sender, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Align(
        alignment: isMe! ? Alignment.centerRight : Alignment.centerLeft,
        child: Material(
          color: isMe! ? kSendButtonColor : kSenderBoxColor,
          borderRadius: BorderRadius.only(
            topLeft: isMe ? Radius.circular(kBubbleRadius) : Radius.circular(0),
            topRight:
                isMe ? Radius.circular(0) : Radius.circular(kBubbleRadius),
            bottomLeft:
                isMe ? Radius.circular(5) : Radius.circular(kBubbleRadius),
            bottomRight:
                isMe ? Radius.circular(kBubbleRadius) : Radius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  '$sender',
                  style: TextStyle(fontSize: 12, color: kChatEmailColor),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '$message',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
