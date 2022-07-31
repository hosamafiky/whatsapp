// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:whatsapp_clone/utils/enums/message_enum.dart';

class Message {
  final String senderId;
  final String receiverId;
  final String text;
  final DateTime timeSent;
  final MessageEnum type;
  final String messageId;
  final bool isSeen;

  Message({
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.timeSent,
    required this.type,
    required this.messageId,
    required this.isSeen,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'type': type.type,
      'messageId': messageId,
      'isSeen': isSeen,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['senderId'] as String,
      receiverId: map['receiverId'] as String,
      text: map['text'] as String,
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent'] as int),
      type: (map['type'] as String).toEnum(),
      messageId: map['messageId'] as String,
      isSeen: map['isSeen'] as bool,
    );
  }
}
