import 'package:flutter/material.dart';
import 'package:whatsapp_clone/data/models/chat_model.dart';

class AvatarCard extends StatelessWidget {
  final Chat chat;
  const AvatarCard(this.chat, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.0,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                backgroundColor: Colors.blueGrey[200],
                backgroundImage: NetworkImage(chat.image),
                // child: chat.image == null
                //     ? SvgPicture.asset(
                //         'assets/icons/person.svg',
                //         color: Colors.white,
                //         width: 30.0,
                //         height: 30.0,
                //       )
                //     : null,
              ),
              Positioned(
                bottom: -2.0,
                right: -2.0,
                child: CircleAvatar(
                  backgroundColor: Colors.blueGrey[200],
                  radius: 10.0,
                  child: const Icon(
                    Icons.clear,
                    color: Colors.white,
                    size: 14.0,
                  ),
                ),
              )
            ],
          ),
          Text(
            chat.name,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            maxLines: 1,
            style: const TextStyle(fontSize: 12.0),
          ),
        ],
      ),
    );
  }
}
