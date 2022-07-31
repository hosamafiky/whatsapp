import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whatsapp_clone/data/models/user_model.dart';

class FirebaseDatabaseHelper {
  Future<void> storeUserData({
    required String uId,
    required Map<String, dynamic> data,
  }) async {
    await FirebaseFirestore.instance.collection('users').doc(uId).set(data);
  }

  Future<void> updateUserData(bool isOnline) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'isOnline': isOnline,
    });
  }

  Future<Map<String, dynamic>?> getUserData(String? uid) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return snapshot.data();
  }

  Stream<UserModel> getUserDataStream(String uid) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((event) => UserModel.fromMap(event.data()!));
  }
}
