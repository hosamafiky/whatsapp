import 'package:flutter/material.dart';
import '../../../constants/palette.dart';
import '../../widgets/status_widgets/my_status_card.dart';
import '../../widgets/status_widgets/other_status_card.dart';

class StatusPage extends StatefulWidget {
  const StatusPage({Key? key}) : super(key: key);

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              MyStatusCard(
                image: 'assets/images/profile.png',
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                child: Text(
                  'Recent Updates',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black45,
                    fontSize: 16.0,
                  ),
                ),
              ),
              OtherStatusCard(
                name: 'Eslam Elrefaey',
                image: 'assets/images/profile.png',
                time: '1:40 PM',
                isSeen: false,
                numOfStatus: 3,
              ),
              OtherStatusCard(
                name: 'Abdelrahman Sobhy',
                image: 'assets/images/profile.png',
                time: '1:40 PM',
                isSeen: false,
                numOfStatus: 4,
              ),
              OtherStatusCard(
                name: 'Umar Sayed',
                image: 'assets/images/profile.png',
                time: '1:40 PM',
                isSeen: false,
                numOfStatus: 1,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                child: Text(
                  'Viewed Updates',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black45,
                    fontSize: 16.0,
                  ),
                ),
              ),
              OtherStatusCard(
                name: 'Eslam Elrefaey',
                image: 'assets/images/profile.png',
                time: '1:40 PM',
                isSeen: true,
                numOfStatus: 10,
              ),
              OtherStatusCard(
                name: 'Abdelrahman Sobhy',
                image: 'assets/images/profile.png',
                time: '1:40 PM',
                isSeen: true,
                numOfStatus: 7,
              ),
              OtherStatusCard(
                name: 'Umar Sayed',
                image: 'assets/images/profile.png',
                time: '1:40 PM',
                isSeen: true,
                numOfStatus: 5,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () {},
            backgroundColor: Colors.grey[200],
            mini: true,
            child: const Icon(
              Icons.edit,
              color: Colors.black54,
              size: 22.0,
            ),
          ),
          const SizedBox(height: 15.0),
          FloatingActionButton(
            onPressed: () {},
            backgroundColor: Palette.tabColor,
            child: const Icon(Icons.camera_alt, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
