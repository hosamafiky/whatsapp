import 'package:flutter/material.dart';
import 'package:whatsapp_clone/data/models/chat_model.dart';

class NewGroupScreen extends StatefulWidget {
  static const String routeName = '/new-group';
  const NewGroupScreen({Key? key}) : super(key: key);

  @override
  State<NewGroupScreen> createState() => _NewGroupScreenState();
}

class _NewGroupScreenState extends State<NewGroupScreen> {
  final List<Chat> contacts = [
    Chat(
      name: 'Hussam Abed',
      image: 'assets/images/profile.png',
      contactId: '',
      timeSent: DateTime.now(),
      lastMessage: 'Hurry up',
    ),
    Chat(
      name: 'Flutter Group',
      image: '',
      contactId: '',
      timeSent: DateTime.now(),
      lastMessage: 'Hurry up',
    ),
    Chat(
      name: 'Hussam Abed',
      image: 'assets/images/profile.png',
      contactId: '',
      timeSent: DateTime.now(),
      lastMessage: 'Hurry up',
    ),
  ];
  List<Chat> groupContacts = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            Text(
              'New Group',
              style: TextStyle(
                fontSize: 19.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Add participants',
              style: TextStyle(fontSize: 13.0),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
              size: 26.0,
            ),
          ),
        ],
      ),
      //   body: Column(
      //     children: [
      //       if (groupContacts.isNotEmpty)
      //         Container(
      //           alignment: Alignment.center,
      //           height: 75.0,
      //           decoration: const BoxDecoration(
      //             color: Colors.white,
      //             border: Border(
      //               bottom: BorderSide(
      //                 color: Colors.black26,
      //                 width: 2.0,
      //               ),
      //             ),
      //           ),
      //           child: ListView.builder(
      //             scrollDirection: Axis.horizontal,
      //             itemBuilder: (context, index) => InkWell(
      //               onTap: () {
      //                 setState(() {
      //                   contacts[index].selected = false;
      //                   groupContacts.remove(contacts[index]);
      //                 });
      //               },
      //               child: AvatarCard(groupContacts[index]),
      //             ),
      //             itemCount: groupContacts.length,
      //           ),
      //         ),
      //       // Expanded(
      //       //   child: ListView.builder(
      //       //     itemCount: contacts.length,
      //       //     itemBuilder: (context, index) {
      //       //       return InkWell(
      //       //         onTap: () {
      //       //           if (!contacts[index].selected) {
      //       //             setState(() {
      //       //               contacts[index].selected = true;
      //       //               groupContacts.add(contacts[index]);
      //       //             });
      //       //           } else {
      //       //             setState(() {
      //       //               contacts[index].selected = false;
      //       //               groupContacts.remove(contacts[index]);
      //       //             });
      //       //           }
      //       //         },
      //       //         child: ContactCard(contacts[index]),
      //       //       );
      //       //     },
      //       //   ),
      //       // ),
      //     ],
      //   ),
      // );
    );
  }
}
