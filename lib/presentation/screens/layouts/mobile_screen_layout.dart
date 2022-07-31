import 'package:flutter/material.dart';
import '../user_information/user_information_screen.dart';
import '../home_tabs/calls_page.dart';
import '../home_tabs/chats_page.dart';
import '../home_tabs/status_page.dart';
import '../camera/camera_screen.dart';

class MobileScreenLayout extends StatefulWidget {
  static const String routeName = '/mobile';
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this, initialIndex: 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'WhatsApp',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            onSelected: (value) {
              if (value == 'Settings') {
                Navigator.pushNamed(
                  context,
                  UserInformationScreen.routeName,
                  arguments: false,
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'New Group',
                child: Text('New Group'),
              ),
              const PopupMenuItem(
                value: 'New Broadcast',
                child: Text('New Broadcast'),
              ),
              const PopupMenuItem(
                value: 'Whatsapp Web',
                child: Text('Whatsapp Web'),
              ),
              const PopupMenuItem(
                value: 'Starred Messages',
                child: Text('Starred Messages'),
              ),
              const PopupMenuItem(
                value: 'Settings',
                child: Text('Settings'),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          indicatorWeight: 2.0,
          tabs: const [
            Tab(icon: Icon(Icons.camera_alt)),
            Tab(text: 'CHATS'),
            Tab(text: 'STATUS'),
            Tab(text: 'CALLS'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          CameraScreen(),
          ChatPage(),
          StatusPage(),
          CallsPage(),
        ],
      ),
    );
  }
}
