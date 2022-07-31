import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp_clone/business_logic/chats_cubit/chats_cubit.dart';
import 'package:whatsapp_clone/business_logic/chats_cubit/chats_state.dart';
import 'package:whatsapp_clone/utils/enums/message_enum.dart';
import 'package:whatsapp_clone/utils/utils.dart';

class CameraViewScreen extends StatefulWidget {
  static const String routeName = '/camera-view';
  final Map<String, dynamic> path;
  const CameraViewScreen(this.path, {Key? key}) : super(key: key);

  @override
  State<CameraViewScreen> createState() => _CameraViewScreenState();
}

class _CameraViewScreenState extends State<CameraViewScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatsCubit, ChatsState>(
      listener: (context, state) {
        if (state is ChatsSendMessageSuccessState) {
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
        } else if (state is ChatsSendMessageLoadingState) {
          showLoadingDialog(context);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.crop_rotate),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.emoji_emotions_outlined),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.title),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.edit),
            ),
          ],
        ),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 140.0,
                child: Image.file(
                  File(widget.path['path']),
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 0.0,
                child: Container(
                  color: Colors.black38,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 6,
                    minLines: 1,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17.0,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Add caption..',
                      hintStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 17.0,
                      ),
                      prefixIcon: const Icon(
                        Icons.add_photo_alternate,
                        color: Colors.white,
                        size: 27.0,
                      ),
                      suffixIcon: CircleAvatar(
                        radius: 20.0,
                        backgroundColor: Colors.tealAccent[700],
                        child: IconButton(
                          onPressed: () async =>
                              BlocProvider.of<ChatsCubit>(context)
                                  .sendFileMessage(
                            context,
                            receiverId: widget.path['receiverId'],
                            file: File(widget.path['path']),
                            senderUserData:
                                await BlocProvider.of<ChatsCubit>(context)
                                    .getUserData(),
                            messageEnum: MessageEnum.image,
                          ),
                          icon: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 27.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
