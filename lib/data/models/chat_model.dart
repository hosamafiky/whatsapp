// ignore_for_file: public_member_api_docs, sort_constructors_first
class Chat {
  final String name;
  final String image;
  final String contactId;
  final String lastMessage;
  final DateTime timeSent;
  Chat({
    required this.name,
    required this.image,
    required this.contactId,
    required this.lastMessage,
    required this.timeSent,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'image': image,
      'contactId': contactId,
      'lastMessage': lastMessage,
      'timeSent': timeSent.millisecondsSinceEpoch,
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      name: map['name'] as String,
      image: map['image'] as String,
      contactId: map['contactId'] as String,
      lastMessage: map['lastMessage'] as String,
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent'] as int),
    );
  }
}
