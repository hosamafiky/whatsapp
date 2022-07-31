import 'package:flutter/material.dart';

import '../../../constants/palette.dart';

class MyStatusCard extends StatelessWidget {
  final String image;
  const MyStatusCard({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 26.0,
            backgroundImage: AssetImage(image),
          ),
          const Positioned(
            bottom: 0.0,
            right: 0.0,
            child: CircleAvatar(
              radius: 12.0,
              backgroundColor: Palette.tabColor,
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 18.0,
              ),
            ),
          ),
        ],
      ),
      title: const Text(
        'My Status',
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: const Text('Tap to add status update'),
    );
  }
}
