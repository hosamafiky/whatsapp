import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/constants/palette.dart';
import 'package:whatsapp_clone/data/models/message_model.dart';

class MyMessageCard extends StatelessWidget {
  final Message message;
  const MyMessageCard(this.message, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45.0,
        ),
        child: Card(
          color: Palette.messageColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          margin: const EdgeInsets.symmetric(
            horizontal: 15.0,
            vertical: 5.0,
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  10.0,
                  5.0,
                  60.0,
                  25.0,
                ),
                child: Text(
                  message.text,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              Positioned(
                bottom: 4.0,
                right: 10.0,
                child: Row(
                  children: [
                    Text(
                      DateFormat('hh:mm a').format(message.timeSent),
                      style: TextStyle(
                        fontSize: 13.0,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 5.0),
                    Icon(
                      Icons.done_all,
                      size: 17.0,
                      color: message.isSeen ? Palette.tabColor : Colors.grey,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReplyMessageCard extends StatelessWidget {
  final Message message;
  const ReplyMessageCard(this.message, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45.0,
        ),
        child: Card(
          // color: Palette.messageColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          margin: const EdgeInsets.symmetric(
            horizontal: 15.0,
            vertical: 5.0,
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  10.0,
                  5.0,
                  60.0,
                  25.0,
                ),
                child: Text(
                  message.text,
                  style: const TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
              Positioned(
                bottom: 4.0,
                right: 10.0,
                child: Row(
                  children: [
                    Text(
                      DateFormat('hh:mm a').format(message.timeSent),
                      style: TextStyle(
                        fontSize: 13.0,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
