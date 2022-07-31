import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../constants/palette.dart';
import '../../../data/models/user_model.dart';

class ContactCard extends StatelessWidget {
  final Contact contact;
  const ContactCard(this.contact, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 23.0,
            backgroundColor: Colors.blueGrey[200],
            backgroundImage:
                contact.photo != null ? MemoryImage(contact.photo!) : null,
            child: contact.photo == null
                ? SvgPicture.asset(
                    'assets/icons/person.svg',
                    color: Colors.white,
                    width: 30.0,
                    height: 30.0,
                  )
                : null,
          ),
        ],
      ),
      title: Text(
        contact.displayName,
        style: const TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: TextButton(
        onPressed: () {},
        child: const Text(
          'Invite',
          style: TextStyle(
            color: Palette.tabColor,
          ),
        ),
      ),
      subtitle: contact.phones.length > 1
          ? Text(
              contact.phones
                  .firstWhere(
                      (element) => element.normalizedNumber.contains('+'))
                  .normalizedNumber,
              style: const TextStyle(fontSize: 13.0),
            )
          : Text(
              contact.phones[0].normalizedNumber,
              style: const TextStyle(fontSize: 13.0),
            ),
    );
  }
}

class UserCard extends StatelessWidget {
  final UserModel user;
  const UserCard(this.user, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 23.0,
            backgroundColor: Colors.blueGrey[200],
            backgroundImage: NetworkImage(user.profilePicture),
            // child: user.photo == null
            //     ? SvgPicture.asset(
            //         'assets/icons/person.svg',
            //         color: Colors.white,
            //         width: 30.0,
            //         height: 30.0,
            //       )
            //     : null,
          ),
        ],
      ),
      title: Text(
        user.name,
        style: const TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        user.status,
        style: const TextStyle(fontSize: 13.0),
      ),
    );
  }
}
