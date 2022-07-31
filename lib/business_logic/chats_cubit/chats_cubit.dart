// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_clone/business_logic/chats_cubit/chats_state.dart';
import 'package:whatsapp_clone/data/models/chat_model.dart';
import 'package:whatsapp_clone/data/models/message_model.dart';
import 'package:whatsapp_clone/data/models/user_model.dart';
import 'package:whatsapp_clone/helpers/firebase_database_helper/firebase_database_helper.dart';
import 'package:whatsapp_clone/helpers/firebase_storage_helper/firebase_storage_helper.dart';
import 'package:whatsapp_clone/utils/enums/message_enum.dart';
import 'package:whatsapp_clone/utils/utils.dart';

class ChatsCubit extends Cubit<ChatsState> {
  ChatsCubit() : super(ChatsInitial());

  static ChatsCubit get(BuildContext context) => BlocProvider.of(context);

  List<UserModel> appUsers = [];
  List<Contact> finalContacts = [];
  List<Contact> validContacts = [];
  List<UserModel> validUsers = [];

  Future<UserModel> getUserData() async {
    var data = await FirebaseDatabaseHelper()
        .getUserData(FirebaseAuth.instance.currentUser!.uid);
    return UserModel.fromMap(data!);
  }

  void setUserData(bool isOnline) async {
    await FirebaseDatabaseHelper().updateUserData(isOnline);
  }

  void getUsers() async {
    var data = await FirebaseFirestore.instance.collection('users').get();
    List<UserModel> usersData = [];
    usersData = [];
    for (var element in data.docs) {
      usersData.add(UserModel.fromMap(element.data()));
    }
    appUsers = usersData;
    emit(ChatsGetAppUsersSuccessState());
  }

  void getContacts({bool? isRefresh}) async {
    try {
      emit(ChatsGetContactsLoadingState());
      if (await FlutterContacts.requestPermission()) {
        List<Contact> allContacts = await FlutterContacts.getContacts(
          withProperties: true,
          withPhoto: true,
        );
        List<Contact> contacts = [];
        List<UserModel> users = [];
        finalContacts = allContacts;
        for (var contact in finalContacts) {
          final phone = contact.phones
              .firstWhere((contact) => contact.normalizedNumber.contains('+'));
          for (var user in appUsers) {
            if (phone.normalizedNumber == user.phoneNumber) {
              users.add(user);
            }
            if (phone.normalizedNumber != user.phoneNumber) {
              contacts.add(contact);
            }
          }
        }
        contacts.removeWhere((item) {
          final phone = item.phones
              .firstWhere((element) => element.normalizedNumber.contains('+'));
          for (int i = 0; i < users.length; i++) {
            if (phone.normalizedNumber == users[i].phoneNumber) {
              return true;
            }
          }
          return false;
        });

        validContacts = contacts;
        validUsers = users;
        if (isRefresh != null) {
          emit(ChatsRefreshContactsSuccessState(
            users,
            contacts.toSet().toList(),
          ));
        } else {
          emit(ChatsGetContactsSuccessState(
            users,
            contacts.toSet().toList(),
          ));
        }
      }
    } catch (error) {
      emit(ChatsGetContactsErrorState(error.toString()));
    }
  }

  bool isSearchIconTapped = false;

  void searchTapped() {
    isSearchIconTapped = !isSearchIconTapped;
    emit(ChatsContactSearchIconPressedState());
  }

  void searchContact(String query) {
    final contactsSuggestions = validContacts
        .where((contact) =>
            contact.displayName.contains(RegExp(query, caseSensitive: false)))
        .toList();
    final usersSuggestions = validUsers
        .where(
            (user) => user.name.contains(RegExp(query, caseSensitive: false)))
        .toList();

    emit(ChatsContactSearchSuccessState(
      contactsSuggestions.toSet().toList(),
      usersSuggestions,
    ));
  }

  void selectContact(
    UserModel selectedUser,
    BuildContext context,
  ) async {
    try {
      emit(ChatsContactFoundState(selectedUser));
    } catch (error) {
      emit(ChatsGetContactsErrorState(error.toString()));
    }
  }

  Stream<UserModel> listenUserData(String uid) {
    return FirebaseDatabaseHelper().getUserDataStream(uid);
  }

  void _saveMessageToMessagesSubcollection({
    required String receiverUserId,
    required String text,
    required String messageId,
    required DateTime timeSent,
    required String userName,
    required String receiverUserName,
    required MessageEnum messageType,
  }) async {
    final Message message = Message(
      senderId: FirebaseAuth.instance.currentUser!.uid,
      receiverId: receiverUserId,
      text: text,
      timeSent: timeSent,
      type: messageType,
      messageId: messageId,
      isSeen: false,
    );

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('chats')
        .doc(receiverUserId)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());

    await FirebaseFirestore.instance
        .collection('users')
        .doc(receiverUserId)
        .collection('chats')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());
  }

  void _saveDataToChatsSubcollection(
    UserModel senderUserData,
    UserModel receiverUserData,
    String text,
    DateTime timeSent,
    String receiverUId,
  ) async {
    var receiverChatContact = Chat(
      name: senderUserData.name,
      image: senderUserData.profilePicture,
      contactId: senderUserData.uId,
      lastMessage: text,
      timeSent: timeSent,
    );

    await FirebaseFirestore.instance
        .collection('users')
        .doc(receiverUId)
        .collection('chats')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set(receiverChatContact.toMap());

    var senderChatContact = Chat(
      name: receiverUserData.name,
      image: receiverUserData.profilePicture,
      contactId: receiverUserData.uId,
      lastMessage: text,
      timeSent: timeSent,
    );

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('chats')
        .doc(receiverUId)
        .set(senderChatContact.toMap());
  }

  void sendMessage(
    BuildContext context, {
    required String message,
    required String receiverId,
    required UserModel senderUserData,
  }) async {
    try {
      var timeSent = DateTime.now();
      UserModel receiverUserData = UserModel.fromMap(
          (await FirebaseDatabaseHelper().getUserData(receiverId))!);
      var messageId = const Uuid().v1();
      _saveDataToChatsSubcollection(
        senderUserData,
        receiverUserData,
        message,
        timeSent,
        receiverId,
      );

      _saveMessageToMessagesSubcollection(
        receiverUserId: receiverId,
        text: message,
        messageId: messageId,
        timeSent: timeSent,
        userName: senderUserData.name,
        receiverUserName: receiverUserData.name,
        messageType: MessageEnum.text,
      );
      getMessages(receiverId);
      emit(ChatsSendMessageSuccessState());
    } catch (error) {
      showErrorDialog(context, error.toString());
      emit(ChatsSendMessageErrorState(error.toString()));
    }
  }

  List<Chat> recentChats = [];
  void getChats() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('chats')
        .orderBy("timeSent", descending: true)
        .get()
        .then((value) async {
      List<Chat> chats = [];
      for (var doc in value.docs) {
        var chat = Chat.fromMap(doc.data());
        var userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(chat.contactId)
            .get();
        var user = UserModel.fromMap(userData.data()!);
        chats.add(Chat(
          name: user.name,
          image: user.profilePicture,
          contactId: chat.contactId,
          lastMessage: chat.lastMessage,
          timeSent: chat.timeSent,
        ));
      }
      recentChats = chats;
      emit(ChatContactsLoadedSuccess());
    });
  }

  Stream<List<Chat>> getChatsStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("chats")
        .orderBy("timeSent", descending: true)
        .snapshots()
        .asyncMap((event) async {
      List<Chat> messages = [];
      for (var doc in event.docs) {
        var chat = Chat.fromMap(doc.data());
        var userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(chat.contactId)
            .get();
        var user = UserModel.fromMap(userData.data()!);
        messages.add(Chat(
          name: user.name,
          image: user.profilePicture,
          contactId: chat.contactId,
          lastMessage: chat.lastMessage,
          timeSent: chat.timeSent,
        ));
      }
      return messages;
    });
  }

  List<Message> recentMessages = [];

  void getMessages(String receiverId) async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('chats')
        .doc(receiverId)
        .collection("messages")
        .orderBy("timeSent")
        .get()
        .then((value) {
      List<Message> messages = [];
      for (var element in value.docs) {
        messages.add(Message.fromMap(element.data()));
      }
      recentMessages = messages;
      emit(ChatMessagesLoadedSuccess());
    });
  }

  Stream<List<Message>> getMessagesStream(String receiverId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('chats')
        .doc(receiverId)
        .collection("messages")
        .orderBy("timeSent")
        .snapshots()
        .asyncMap((event) async {
      List<Message> messages = [];
      for (var doc in event.docs) {
        var message = Message.fromMap(doc.data());
        messages.add(message);
      }
      return messages;
    });
  }

  void sendFileMessage(
    BuildContext context, {
    required String receiverId,
    required File file,
    required UserModel senderUserData,
    required MessageEnum messageEnum,
  }) async {
    try {
      var timeSent = DateTime.now();
      var messageId = const Uuid().v1();

      String fileUrl =
          await FirebaseStorageHelper().uploadFileToFirestoreDatabase(
        path:
            'chats/${messageEnum.type}/${senderUserData.uId}/$receiverId/$messageId',
        file: file,
      );

      UserModel receiverUserData = UserModel.fromMap(
          (await FirebaseDatabaseHelper().getUserData(receiverId))!);

      String contactMessage;

      switch (messageEnum) {
        case MessageEnum.image:
          contactMessage = '📷 Photo';
          break;
        case MessageEnum.video:
          contactMessage = '📸 Video';
          break;
        case MessageEnum.audio:
          contactMessage = '🎵 Audio';
          break;

        case MessageEnum.gif:
          contactMessage = 'GIF';
          break;
        default:
          contactMessage = 'GIF';
      }

      _saveDataToChatsSubcollection(
        senderUserData,
        receiverUserData,
        contactMessage,
        timeSent,
        receiverId,
      );

      _saveMessageToMessagesSubcollection(
        receiverUserId: receiverId,
        text: fileUrl,
        messageId: messageId,
        timeSent: timeSent,
        userName: senderUserData.name,
        receiverUserName: receiverUserData.name,
        messageType: messageEnum,
      );
      getMessages(receiverId);
      emit(ChatsSendMessageSuccessState());
    } catch (error) {
      showErrorDialog(context, error.toString());
      emit(ChatsSendMessageErrorState(error.toString()));
    }
  }
}
