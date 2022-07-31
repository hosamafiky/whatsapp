import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp_clone/business_logic/info_cubit/info_cubit.dart';
import 'package:whatsapp_clone/business_logic/info_cubit/info_state.dart';
import 'package:whatsapp_clone/constants/palette.dart';
import 'package:whatsapp_clone/data/models/user_model.dart';
import 'package:whatsapp_clone/presentation/screens/layouts/mobile_screen_layout.dart';
import 'package:whatsapp_clone/utils/utils.dart';

class UserInformationScreen extends StatefulWidget {
  static const String routeName = '/user-information';
  final bool isFirst;
  const UserInformationScreen({Key? key, this.isFirst = true})
      : super(key: key);

  @override
  State<UserInformationScreen> createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends State<UserInformationScreen> {
  final nameController = TextEditingController();
  final statusController = TextEditingController();
  bool isNameEditable = false;
  bool isStatusEditable = false;
  File? profilePicture;
  UserModel? currentUser;

  @override
  void initState() {
    super.initState();
    InfoCubit.get(context).getUserData();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InfoCubit, InfoState>(
      listener: (context, state) {
        if (state is InfoPickImageSuccess) {
          profilePicture = state.file;
        } else if (state is InfoPickImageError) {
          showErrorDialog(context, state.error);
        } else if (state is InfoSaveUserDataError) {
          showErrorDialog(context, state.error);
        } else if (state is InfoUserDataSuccessState) {
          currentUser = state.userModel;
        } else if (state is InfoSaveUserDataSuccess) {
          if (widget.isFirst) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              MobileScreenLayout.routeName,
              (route) => false,
            );
          }
        }
      },
      builder: (context, state) {
        var cubit = InfoCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFFEEEEEE),
            elevation: 1.0,
            iconTheme: const IconThemeData(color: Colors.black45),
            actionsIconTheme: const IconThemeData(color: Colors.black45),
            title: const Text(
              'Profile & status',
              style: TextStyle(color: Colors.black45),
            ),
            automaticallyImplyLeading: !widget.isFirst,
            actions: [
              IconButton(
                onPressed: () {
                  cubit.saveUserData(
                    name: nameController.text.isEmpty
                        ? currentUser != null
                            ? currentUser!.name
                            : 'User'
                        : nameController.text,
                    status: statusController.text.isEmpty
                        ? currentUser != null
                            ? currentUser!.status
                            : 'Hey there, i\'m using whatsapp'
                        : statusController.text,
                    file: profilePicture,
                    context: context,
                  );
                  setState(() {
                    isNameEditable = false;
                    isStatusEditable = false;
                  });
                },
                icon: const Icon(Icons.check),
              ),
            ],
          ),
          body: Stack(
            children: [
              SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 30.0),
                      Stack(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage: profilePicture != null
                                ? FileImage(profilePicture!) as ImageProvider
                                : currentUser != null
                                    ? NetworkImage(currentUser!.profilePicture)
                                    : const NetworkImage(
                                        'https://www.pngitem.com/pimgs/m/421-4212617_person-placeholder-image-transparent-hd-png-download.png'),
                            radius: 74.0,
                          ),
                          if (profilePicture == null && currentUser == null)
                            CircleAvatar(
                              backgroundColor: Colors.black26,
                              radius: 74.0,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    PopupMenuButton(
                                      onSelected: (value) {
                                        if (value == 1) {
                                          cubit.pickImageFromCamera();
                                        } else if (value == 2) {
                                          cubit.pickImageFromGallery();
                                        } else {}
                                      },
                                      itemBuilder: (context) => [
                                        const PopupMenuItem(
                                          value: 1,
                                          child: Text('Take photo'),
                                        ),
                                        const PopupMenuItem(
                                          value: 2,
                                          child: Text('Upload photo'),
                                        ),
                                        const PopupMenuItem(
                                          value: 3,
                                          child: Text('Remove photo'),
                                        ),
                                      ],
                                      icon: const Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const Text(
                                      'ADD PROFILE PHOTO',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          if (profilePicture != null || currentUser != null)
                            Positioned(
                              bottom: 10.0,
                              right: 10.0,
                              child: CircleAvatar(
                                radius: 16.0,
                                backgroundColor: Palette.tabColor,
                                child: PopupMenuButton(
                                  onSelected: (value) {
                                    if (value == 1) {
                                      cubit.pickImageFromCamera();
                                    } else if (value == 2) {
                                      cubit.pickImageFromGallery();
                                    } else {}
                                  },
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(
                                      value: 1,
                                      child: Text('Take photo'),
                                    ),
                                    const PopupMenuItem(
                                      value: 2,
                                      child: Text('Upload photo'),
                                    ),
                                    const PopupMenuItem(
                                      value: 3,
                                      child: Text('Remove photo'),
                                    ),
                                  ],
                                  icon: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 17.0,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      Container(
                        width: double.infinity,
                        color: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Your Name',
                              style: TextStyle(
                                color: Palette.tabColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: nameController,
                                    readOnly: !isNameEditable,
                                    decoration: InputDecoration(
                                      hintText: currentUser != null
                                          ? currentUser!.name
                                          : 'Test',
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => !isNameEditable
                                      ? setState(() {
                                          isNameEditable = true;
                                          nameController.text =
                                              currentUser != null
                                                  ? currentUser!.name
                                                  : 'Test';
                                        })
                                      : setState(() {
                                          isNameEditable = false;
                                          nameController.text = '';
                                        }),
                                  icon: Icon(
                                    !isNameEditable ? Icons.edit : Icons.clear,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Container(
                        width: double.infinity,
                        color: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Status',
                              style: TextStyle(
                                color: Palette.tabColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: statusController,
                                    readOnly: !isStatusEditable,
                                    decoration: InputDecoration(
                                      hintText: currentUser != null
                                          ? currentUser!.status
                                          : 'Hey there, i\'m using whatsapp',
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => !isStatusEditable
                                      ? setState(() {
                                          isStatusEditable = true;
                                          statusController.text =
                                              currentUser != null
                                                  ? currentUser!.status
                                                  : 'Test';
                                        })
                                      : setState(() {
                                          isStatusEditable = false;
                                          statusController.text = '';
                                        }),
                                  icon: Icon(
                                    !isStatusEditable
                                        ? Icons.edit
                                        : Icons.clear,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (state is InfoLoading)
                const Center(
                  child: CircularProgressIndicator(
                    color: Palette.tabColor,
                  ),
                )
            ],
          ),
        );
      },
    );
  }
}
