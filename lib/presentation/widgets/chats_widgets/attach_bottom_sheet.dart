import 'package:flutter/material.dart';

class AttachBottomSheet extends StatelessWidget {
  final VoidCallback onGalleryPressed;
  final VoidCallback onCameraPressed;
  final VoidCallback onDocumentPressed;
  final VoidCallback onContactPressed;
  final VoidCallback onLocationPressed;
  final VoidCallback onAudioPressed;
  const AttachBottomSheet({
    Key? key,
    required this.onGalleryPressed,
    required this.onCameraPressed,
    required this.onDocumentPressed,
    required this.onContactPressed,
    required this.onLocationPressed,
    required this.onAudioPressed,
  }) : super(key: key);

  Widget iconCreation({
    required IconData icon,
    required Color color,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
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
                    icon: Icons.insert_drive_file,
                    color: Colors.indigo,
                    text: 'Document',
                    onTap: onDocumentPressed,
                  ),
                  const SizedBox(width: 40.0),
                  iconCreation(
                    icon: Icons.camera_alt,
                    color: Colors.pink,
                    text: 'Camera',
                    onTap: onCameraPressed,
                  ),
                  const SizedBox(width: 40.0),
                  iconCreation(
                    icon: Icons.insert_photo,
                    color: Colors.purple,
                    text: 'Gallery',
                    onTap: onGalleryPressed,
                  ),
                ],
              ),
              const SizedBox(height: 25.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(
                    icon: Icons.headset,
                    color: Colors.orange,
                    text: 'Audio',
                    onTap: onAudioPressed,
                  ),
                  const SizedBox(width: 40.0),
                  iconCreation(
                    icon: Icons.location_pin,
                    color: Colors.teal,
                    text: 'Location',
                    onTap: onLocationPressed,
                  ),
                  const SizedBox(width: 40.0),
                  iconCreation(
                    icon: Icons.person,
                    color: Colors.blue,
                    text: 'Contact',
                    onTap: onContactPressed,
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
