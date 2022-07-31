import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  final String uId;
  final String name;
  final String status;
  final String profilePicture;
  final bool isOnline;
  final String phoneNumber;
  final List<dynamic> groupId;
  UserModel({
    required this.uId,
    required this.name,
    required this.status,
    required this.profilePicture,
    required this.isOnline,
    required this.phoneNumber,
    required this.groupId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uId,
      'name': name,
      'status': status,
      'profilePicture': profilePicture,
      'isOnline': isOnline,
      'phoneNumber': phoneNumber,
      'groupId': groupId,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uId: map['uid'] as String,
      name: map['name'] as String,
      status: map['status'] as String,
      profilePicture: map['profilePicture'] as String,
      isOnline: map['isOnline'] as bool,
      phoneNumber: map['phoneNumber'] as String,
      groupId: List<dynamic>.from((map['groupId'] as List<dynamic>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
