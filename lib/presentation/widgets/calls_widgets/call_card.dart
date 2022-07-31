import 'package:flutter/material.dart';

class CallCard extends StatelessWidget {
  final String image;
  final String name;
  final String time;
  final bool isAudio;
  final bool isRecieved;
  final bool isMissed;
  const CallCard({
    Key? key,
    required this.image,
    required this.name,
    required this.time,
    required this.isAudio,
    required this.isRecieved,
    required this.isMissed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 26.0,
        backgroundImage: AssetImage(image),
      ),
      title: Text(
        name,
        style: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Row(
        children: [
          Icon(
            isRecieved ? Icons.call_received : Icons.call_made,
            size: 16.0,
            color: isMissed ? Colors.red : Colors.green,
          ),
          const SizedBox(width: 5.0),
          Text('Today, $time'),
        ],
      ),
      trailing: Icon(isAudio ? Icons.call : Icons.videocam_rounded),
    );
  }
}
