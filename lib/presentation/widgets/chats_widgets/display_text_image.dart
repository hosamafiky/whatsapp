import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/data/models/message_model.dart';
import 'package:whatsapp_clone/utils/enums/message_enum.dart';

class DisplayTextImageWidget extends StatelessWidget {
  final Message message;
  const DisplayTextImageWidget(this.message, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return message.type == MessageEnum.text
        ? Text(
            message.text,
            style: const TextStyle(fontSize: 16.0),
          )
        : CachedNetworkImage(
            imageUrl: message.text,
          );
  }
}
