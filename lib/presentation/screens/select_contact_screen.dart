import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:whatsapp_clone/business_logic/chats_cubit/chats_cubit.dart';
import 'package:whatsapp_clone/business_logic/chats_cubit/chats_state.dart';
import 'package:whatsapp_clone/constants/palette.dart';
import 'package:whatsapp_clone/data/models/user_model.dart';
import 'package:whatsapp_clone/presentation/screens/single_chat_screen.dart';
import 'package:whatsapp_clone/presentation/widgets/auth_widgets/custom_form_field.dart';

import '../widgets/chats_widgets/button_card.dart';
import '../widgets/chats_widgets/contact_card.dart';
import 'new_group_screen.dart';

class SelectContactScreen extends StatefulWidget {
  static const String routeName = '/select-contact';
  final Map<String, dynamic> lists;
  const SelectContactScreen(this.lists, {Key? key}) : super(key: key);

  @override
  State<SelectContactScreen> createState() => _SelectContactScreenState();
}

class _SelectContactScreenState extends State<SelectContactScreen> {
  List<Contact> searchedContacts = [];
  List<UserModel> searchedUsers = [];
  FocusNode focusNode = FocusNode();

  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<Contact> contacts = widget.lists['contacts'];
    List<UserModel> users = widget.lists['users'];
    return BlocConsumer<ChatsCubit, ChatsState>(
      listener: (context, state) {
        if (state is ChatsContactFoundState) {
          Navigator.pushNamed(
            context,
            SingleChatScreen.routeName,
            arguments: {
              'name': state.userModel.name,
              'uId': state.userModel.uId,
              'image': state.userModel.profilePicture,
            },
          );
        } else if (state is ChatsContactSearchSuccessState) {
          searchedContacts = state.contacts;
          searchedUsers = state.users;
        } else if (state is ChatsRefreshContactsSuccessState) {
          contacts = state.contacts;
          users = state.users;
        }
      },
      builder: (context, state) {
        var cubit = ChatsCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                if (cubit.isSearchIconTapped) {
                  setState(() {
                    cubit.isSearchIconTapped = false;
                  });
                } else {
                  Navigator.pop(context);
                }
              },
              icon: const Icon(Icons.arrow_back),
            ),
            title: cubit.isSearchIconTapped
                ? CustomFormField(
                    focusNode: focusNode,
                    controller: searchController,
                    hintText: 'Search...',
                    textAlign: TextAlign.start,
                    wantBorder: false,
                    keyboardType: TextInputType.text,
                    hintTextColor: Colors.grey[200]!,
                    textColor: Colors.white70,
                    autofocus: true,
                    onChanged: (value) {
                      if (value!.isEmpty) {
                        setState(() {
                          searchedContacts = [];
                        });
                      } else {
                        cubit.searchContact(value);
                      }
                    },
                    onFieldSubmitted: (value) {
                      cubit.searchTapped();
                    },
                  )
                : const Text(
                    'Select contact',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            actions: !cubit.isSearchIconTapped
                ? [
                    IconButton(
                      onPressed: () => cubit.searchTapped(),
                      icon: const Icon(
                        Icons.search,
                        size: 26.0,
                      ),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'Refresh') {
                          BlocProvider.of<ChatsCubit>(context)
                              .getContacts(isRefresh: true);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'Invite a friend',
                          child: Text('Invite a friend'),
                        ),
                        const PopupMenuItem(
                          value: 'Contacts',
                          child: Text('Contacts'),
                        ),
                        const PopupMenuItem(
                          value: 'Refresh',
                          child: Text('Refresh'),
                        ),
                        const PopupMenuItem(
                          value: 'Help',
                          child: Text('Help'),
                        ),
                      ],
                    ),
                  ]
                : [],
          ),
          body: Stack(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: searchController.text.isEmpty
                    ? SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () => Navigator.pushNamed(
                                  context, NewGroupScreen.routeName),
                              child: const ButtonCard(
                                text: 'New group',
                                icon: Icons.group,
                              ),
                            ),
                            InkWell(
                              onTap: () {},
                              child: const ButtonCard(
                                text: 'New contact',
                                icon: Icons.person_add,
                              ),
                            ),
                            if (users.isNotEmpty) ...[
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
                                child: Text(
                                  'Contacts on WhatsApp',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: users.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () => cubit.selectContact(
                                      users[index],
                                      context,
                                    ),
                                    child: UserCard(
                                      users[index],
                                    ),
                                  );
                                },
                              ),
                            ],
                            if (contacts.isNotEmpty) ...[
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
                                child: Text(
                                  'Invite to WhatsApp',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: contacts.length,
                                itemBuilder: (context, index) {
                                  return ContactCard(contacts[index]);
                                },
                              ),
                            ],
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (searchedContacts.isNotEmpty ||
                                searchedUsers.isNotEmpty) ...[
                              if (searchedUsers.isNotEmpty) ...[
                                const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Text(
                                    'Contacts on WhatsApp',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: searchedUsers.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () => cubit.selectContact(
                                          searchedUsers[index], context),
                                      child: UserCard(searchedUsers[index]),
                                    );
                                  },
                                ),
                              ],
                              if (searchedContacts.isNotEmpty) ...[
                                const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Text(
                                    'Invite to WhatsApp',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: searchedContacts.length,
                                  itemBuilder: (context, index) {
                                    return ContactCard(searchedContacts[index]);
                                  },
                                ),
                              ],
                              InkWell(
                                onTap: () => Navigator.pushNamed(
                                    context, NewGroupScreen.routeName),
                                child: const ButtonCard(
                                    text: 'New group', icon: Icons.group),
                              ),
                              InkWell(
                                onTap: () {},
                                child: const ButtonCard(
                                    text: 'New contact',
                                    icon: Icons.person_add),
                              ),
                            ],
                            if (searchedContacts.isEmpty &&
                                searchedUsers.isEmpty) ...[
                              Container(
                                height: 100.0,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15.0,
                                  horizontal: 22.0,
                                ),
                                child: Center(
                                  child: Text(
                                    'No results found for \'${searchController.text}\'',
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black45,
                                    ),
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
                                child: Text(
                                  'More',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () => Navigator.pushNamed(
                                    context, NewGroupScreen.routeName),
                                child: const ButtonCard(
                                  text: 'New group',
                                  icon: Icons.group,
                                ),
                              ),
                              InkWell(
                                onTap: () {},
                                child: const ButtonCard(
                                  text: 'New contact',
                                  icon: Icons.person_add,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
              ),
              if (state is ChatsGetContactsLoadingState)
                const Center(
                    child: CircularProgressIndicator(
                  color: Palette.tabColor,
                )),
            ],
          ),
        );
      },
    );
  }
}
