import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp_clone/business_logic/chats_cubit/chats_cubit.dart';
import 'package:whatsapp_clone/business_logic/chats_cubit/chats_state.dart';
import 'package:whatsapp_clone/presentation/screens/select_contact_screen.dart';
import 'package:whatsapp_clone/presentation/widgets/chats_widgets/custom_card.dart';
import '../../../constants/palette.dart';
import '../../../data/models/chat_model.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        BlocProvider.of<ChatsCubit>(context).setUserData(true);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
        BlocProvider.of<ChatsCubit>(context).setUserData(false);
        break;
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatsCubit, ChatsState>(
      listener: (context, state) {
        if (state is ChatsGetContactsSuccessState) {
          Navigator.pushNamed(
            context,
            SelectContactScreen.routeName,
            arguments: {
              'contacts': state.contacts,
              'users': state.users,
            },
          );
        }
      },
      builder: (context, state) {
        var cubit = ChatsCubit.get(context);
        return Scaffold(
          body: StreamBuilder<List<Chat>>(
            stream: cubit.getChatsStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.waiting) {
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) =>
                        CustomCard(snapshot.data![index]));
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: cubit.recentChats.length,
                  itemBuilder: (context, index) =>
                      CustomCard(cubit.recentChats[index]),
                );
              }
            },
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Palette.tabColor,
            onPressed: () => cubit.getContacts(),
            child: const Icon(
              Icons.chat,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}
