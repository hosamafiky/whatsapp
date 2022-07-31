import 'package:flutter_contacts/contact.dart';
import 'package:whatsapp_clone/data/models/user_model.dart';

abstract class ChatsState {}

class ChatsInitial extends ChatsState {}

class ChatsGetContactsSuccessState extends ChatsState {
  final List<UserModel> users;
  final List<Contact> contacts;

  ChatsGetContactsSuccessState(this.users, this.contacts);
}

class ChatsRefreshContactsSuccessState extends ChatsState {
  final List<UserModel> users;
  final List<Contact> contacts;

  ChatsRefreshContactsSuccessState(this.users, this.contacts);
}

class ChatsGetContactsLoadingState extends ChatsState {}

class ChatsGetAppUsersSuccessState extends ChatsState {}

class ChatsGetContactsErrorState extends ChatsState {
  final String error;

  ChatsGetContactsErrorState(this.error);
}

class ChatsContactFoundState extends ChatsState {
  final UserModel userModel;

  ChatsContactFoundState(this.userModel);
}

class ChatsContactSearchSuccessState extends ChatsState {
  final List<Contact> contacts;
  final List<UserModel> users;

  ChatsContactSearchSuccessState(this.contacts, this.users);
}

class ChatsContactSearchIconPressedState extends ChatsState {}

class ChatsSendMessageSuccessState extends ChatsState {}

class ChatsSendMessageErrorState extends ChatsState {
  final String error;

  ChatsSendMessageErrorState(this.error);
}

class ChatMessagesLoadedSuccess extends ChatsState {}

class ChatContactsLoadedSuccess extends ChatsState {}
