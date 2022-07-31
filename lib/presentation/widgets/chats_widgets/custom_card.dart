import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/data/models/chat_model.dart';
import '../../screens/single_chat_screen.dart';

class CustomCard extends StatelessWidget {
  final Chat chat;
  const CustomCard(this.chat, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => Navigator.pushNamed(
            context,
            SingleChatScreen.routeName,
            arguments: {
              'name': chat.name,
              'uId': chat.contactId,
              'image': chat.image,
            },
          ),
          child: ListTile(
            leading: CircleAvatar(
              radius: 30.0,
              backgroundColor: Colors.blueGrey,
              backgroundImage: NetworkImage(chat.image),
            ),
            trailing: Text(DateFormat('hh:mm a').format(chat.timeSent)),
            title: Text(
              chat.name,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Row(
              children: [
                const Icon(
                  Icons.done_all,
                  size: 16.0,
                ),
                const SizedBox(width: 5.0),
                Text(chat.lastMessage),
              ],
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 80.0, right: 20.0),
          child: Divider(
            thickness: 1.0,
          ),
        ),
      ],
    );
  }
}
