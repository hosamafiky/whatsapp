// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp_clone/business_logic/chats_cubit/chats_cubit.dart';
import 'package:whatsapp_clone/business_logic/chats_cubit/chats_state.dart';
import 'package:whatsapp_clone/data/models/message_model.dart';
import 'package:whatsapp_clone/data/models/user_model.dart';
import 'package:whatsapp_clone/presentation/screens/camera/camera_screen.dart';
import 'package:whatsapp_clone/presentation/screens/camera/camera_view_screen.dart';
import 'package:whatsapp_clone/presentation/widgets/chats_widgets/message_card.dart';
import 'package:whatsapp_clone/utils/enums/message_enum.dart';
import 'package:whatsapp_clone/utils/utils.dart';
import '../../constants/palette.dart';
import '../widgets/chats_widgets/attach_bottom_sheet.dart';

class SingleChatScreen extends StatefulWidget {
  static const routeName = '/single-chat';
  final Map<String, dynamic> userModel;
  const SingleChatScreen(this.userModel, {Key? key}) : super(key: key);

  @override
  State<SingleChatScreen> createState() => _SingleChatScreenState();
}

class _SingleChatScreenState extends State<SingleChatScreen> {
  bool isShowSticker = false;
  bool isMessageExist = false;
  bool? isOnline;
  FocusNode focusNode = FocusNode();
  TextEditingController controller = TextEditingController();
  final ScrollController messageController = ScrollController();
  Widget emojiSelect() {
    return EmojiPicker(
      onEmojiSelected: (category, emoji) {
        setState(() {
          controller.text = controller.text + emoji.emoji;
        });
      },
      onBackspacePressed: () {
        setState(() {});
      },
      config: Config(
        columns: 7,
        emojiSizeMax: 32 *
            (Platform.isIOS
                ? 1.30
                : 1.0), // Issue: https://github.com/flutter/flutter/issues/28894
        verticalSpacing: 0,
        horizontalSpacing: 0,
        gridPadding: EdgeInsets.zero,
        initCategory: Category.RECENT,
        bgColor: const Color(0xFFF2F2F2),
        indicatorColor: Colors.blue,
        iconColor: Colors.grey,
        iconColorSelected: Colors.blue,
        progressIndicatorColor: Colors.blue,
        backspaceColor: Colors.blue,
        skinToneDialogBgColor: Colors.white,
        skinToneIndicatorColor: Colors.grey,
        enableSkinTones: true,
        showRecentsTab: true,
        recentsLimit: 28,
        noRecents: const Text(
          'No Recents',
          style: TextStyle(fontSize: 20, color: Colors.black26),
          textAlign: TextAlign.center,
        ),
        tabIndicatorAnimDuration: kTabScrollDuration,
        categoryIcons: const CategoryIcons(),
        buttonMode: ButtonMode.MATERIAL,
      ),
    );
  }

  void sendFileMessage(BuildContext context) async {
    File? messagePicture = await pickFileFromGallery(context);
    if (messagePicture != null) {
      var senderUserData =
          await BlocProvider.of<ChatsCubit>(context).getUserData();
      BlocProvider.of<ChatsCubit>(context).sendFileMessage(
        context,
        receiverId: widget.userModel['uId'],
        file: messagePicture,
        senderUserData: senderUserData,
        messageEnum: MessageEnum.image,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ChatsCubit>(context).getMessages(widget.userModel['uId']);
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          isShowSticker = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatsCubit, ChatsState>(
      listener: (context, state) {
        if (state is ChatsSendMessageSuccessState) {
          focusNode.unfocus();
          controller.text = '';
        } else if (state is ChatsMessageImagePickedSuccessState) {
          Navigator.pushNamed(
            context,
            CameraViewScreen.routeName,
            arguments: {
              'path': state.file.path,
              'receiverId': widget.userModel['uId'],
            },
          );
        }
      },
      builder: (context, state) {
        var cubit = ChatsCubit.get(context);
        return Scaffold(
          backgroundColor: Colors.lightGreen,
          appBar: AppBar(
            leadingWidth: 70.0,
            leading: InkWell(
              onTap: () => Navigator.pop(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.arrow_back,
                    size: 24.0,
                  ),
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.userModel['image']),
                    radius: 20.0,
                    backgroundColor: Colors.blueGrey,
                  ),
                ],
              ),
            ),
            title: InkWell(
              onTap: () {},
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    widget.userModel['name'],
                    style: const TextStyle(
                      fontSize: 18.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  StreamBuilder<UserModel>(
                    stream:
                        ChatsCubit().listenUserData(widget.userModel['uId']),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text(
                          isOnline ?? false ? 'online' : 'offline',
                          style: TextStyle(
                            fontSize: 13.0,
                            letterSpacing: 1.1,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        );
                      } else {
                        isOnline = snapshot.data!.isOnline;
                        return Text(
                          snapshot.data!.isOnline ? 'online' : 'offline',
                          style: TextStyle(
                            fontSize: 13.0,
                            letterSpacing: 1.1,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.videocam)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.call)),
              PopupMenuButton<String>(
                onSelected: (value) {
                  log(value);
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'View Contact',
                    child: Text('View Contact'),
                  ),
                  const PopupMenuItem(
                    value: 'Media, Links and docs',
                    child: Text('Media, Links and docs'),
                  ),
                  const PopupMenuItem(
                    value: 'Whatsapp Web',
                    child: Text('Whatsapp Web'),
                  ),
                  const PopupMenuItem(
                    value: 'Search',
                    child: Text('Search'),
                  ),
                  const PopupMenuItem(
                    value: 'Mute Notifications',
                    child: Text('Mute Notifications'),
                  ),
                  const PopupMenuItem(
                    value: 'Wallpaper',
                    child: Text('Wallpaper'),
                  ),
                ],
              ),
            ],
          ),
          body: GestureDetector(
            onTap: () => focusNode.unfocus(),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/backgroundImage-light.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: WillPopScope(
                onWillPop: () {
                  if (isShowSticker) {
                    setState(() {
                      isShowSticker = false;
                    });
                  } else {
                    Navigator.pop(context);
                  }
                  return Future.value(false);
                },
                child: Stack(
                  children: [
                    StreamBuilder<List<Message>>(
                      stream: cubit.getMessagesStream(widget.userModel['uId']),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          SchedulerBinding.instance.addPostFrameCallback((_) {
                            messageController.jumpTo(
                                messageController.position.maxScrollExtent);
                          });
                          return Column(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  controller: messageController,
                                  itemBuilder: (context, index) {
                                    if (index == cubit.recentMessages.length) {
                                      return const SizedBox(height: 60.0);
                                    } else {
                                      var message = cubit.recentMessages[index];
                                      if (message.senderId ==
                                          FirebaseAuth
                                              .instance.currentUser!.uid) {
                                        return MyMessageCard(message);
                                      } else {
                                        return ReplyMessageCard(message);
                                      }
                                    }
                                  },
                                  itemCount: cubit.recentMessages.length + 1,
                                ),
                              ),
                              const SizedBox(height: 60.0),
                            ],
                          );
                        }
                        SchedulerBinding.instance.addPostFrameCallback((_) {
                          messageController.jumpTo(
                              messageController.position.maxScrollExtent);
                        });
                        return Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                controller: messageController,
                                itemBuilder: (context, index) {
                                  if (index == snapshot.data!.length) {
                                    return const SizedBox(height: 60.0);
                                  } else {
                                    var message = snapshot.data![index];
                                    if (message.senderId ==
                                        FirebaseAuth
                                            .instance.currentUser!.uid) {
                                      return MyMessageCard(message);
                                    } else {
                                      return ReplyMessageCard(message);
                                    }
                                  }
                                },
                                itemCount: snapshot.data!.length + 1,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width - 60.0,
                                child: Card(
                                  margin: const EdgeInsets.only(
                                    left: 2.0,
                                    right: 2.0,
                                    bottom: 8.0,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                  child: TextFormField(
                                    focusNode: focusNode,
                                    controller: controller,
                                    textAlignVertical: TextAlignVertical.center,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 5,
                                    minLines: 1,
                                    onChanged: (value) {
                                      if (value.isNotEmpty) {
                                        setState(() {
                                          isMessageExist = true;
                                        });
                                      } else {
                                        setState(() {
                                          isMessageExist = false;
                                        });
                                      }
                                    },
                                    style: const TextStyle(
                                      decoration: TextDecoration.none,
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Type a message..',
                                      contentPadding: const EdgeInsets.all(5.0),
                                      prefixIcon: IconButton(
                                        onPressed: () => setState(() {
                                          focusNode.unfocus();
                                          focusNode.canRequestFocus = false;
                                          isShowSticker = !isShowSticker;
                                        }),
                                        icon: const Icon(
                                            Icons.emoji_emotions_outlined),
                                      ),
                                      suffixIcon: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            onPressed: () =>
                                                showModalBottomSheet(
                                              backgroundColor:
                                                  Colors.transparent,
                                              context: context,
                                              builder: (context) =>
                                                  const AttachBottomSheet(),
                                            ),
                                            icon: const Icon(
                                                Icons.attach_file_outlined),
                                          ),
                                          IconButton(
                                            onPressed: () =>
                                                Navigator.pushNamed(
                                              context,
                                              CameraScreen.routeName,
                                              arguments:
                                                  widget.userModel['uId'],
                                            ),
                                            icon: const Icon(Icons.camera_alt),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 8.0, right: 5.0, left: 2.0),
                                child: CircleAvatar(
                                  radius: 25.0,
                                  backgroundColor: Palette.tabColor,
                                  child: IconButton(
                                    onPressed: () async {
                                      if (isMessageExist) {
                                        cubit.sendMessage(
                                          context,
                                          message: controller.text,
                                          receiverId: widget.userModel['uId'],
                                          senderUserData:
                                              await cubit.getUserData(),
                                        );
                                      }
                                    },
                                    icon: Icon(
                                      isMessageExist ? Icons.send : Icons.mic,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (isShowSticker)
                            SizedBox(
                              height: 300.0,
                              width: double.infinity,
                              child: emojiSelect(),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
