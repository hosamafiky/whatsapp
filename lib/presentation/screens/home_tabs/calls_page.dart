import 'package:flutter/material.dart';
import '../../../constants/palette.dart';
import '../../widgets/calls_widgets/call_card.dart';

class CallsPage extends StatefulWidget {
  const CallsPage({Key? key}) : super(key: key);

  @override
  State<CallsPage> createState() => _CallsPageState();
}

class _CallsPageState extends State<CallsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: const [
          CallCard(
            image: 'assets/images/profile.png',
            name: 'Hussam',
            time: '3:19 PM',
            isAudio: true,
            isRecieved: true,
            isMissed: false,
          ),
          CallCard(
            image: 'assets/images/profile.png',
            name: 'Hussam',
            time: '3:19 PM',
            isAudio: false,
            isRecieved: false,
            isMissed: true,
          ),
          CallCard(
            image: 'assets/images/profile.png',
            name: 'Hussam',
            time: '3:19 PM',
            isAudio: true,
            isRecieved: true,
            isMissed: false,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Palette.tabColor,
        child: const Icon(
          Icons.add_call,
          size: 26.0,
          color: Colors.white,
        ),
      ),
    );
  }
}
