import 'package:flutter/material.dart';

class AttachBottomSheet extends StatelessWidget {
  const AttachBottomSheet({Key? key}) : super(key: key);

  Widget iconCreation(IconData icon, Color color, String text) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          CircleAvatar(
            radius: 30.0,
            backgroundColor: color,
            child: Icon(
              icon,
              size: 29.0,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5.0),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 278.0,
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: const EdgeInsets.all(18.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 20.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(
                    Icons.insert_drive_file,
                    Colors.indigo,
                    'Document',
                  ),
                  const SizedBox(width: 40.0),
                  iconCreation(
                    Icons.camera_alt,
                    Colors.pink,
                    'Camera',
                  ),
                  const SizedBox(width: 40.0),
                  iconCreation(
                    Icons.insert_photo,
                    Colors.purple,
                    'Gallery',
                  ),
                ],
              ),
              const SizedBox(height: 25.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(
                    Icons.headset,
                    Colors.orange,
                    'Audio',
                  ),
                  const SizedBox(width: 40.0),
                  iconCreation(
                    Icons.location_pin,
                    Colors.teal,
                    'Location',
                  ),
                  const SizedBox(width: 40.0),
                  iconCreation(
                    Icons.person,
                    Colors.blue,
                    'Contact',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
