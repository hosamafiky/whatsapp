import 'package:firebase_auth/firebase_auth.dart';
import 'package:whatsapp_clone/data/models/user_model.dart';
import 'package:whatsapp_clone/helpers/firebase_database_helper/firebase_database_helper.dart';

class InfoScreenRepository {
  Future<UserModel?> getUserData() async {
    Map<String, dynamic>? data = await FirebaseDatabaseHelper()
        .getUserData(FirebaseAuth.instance.currentUser?.uid);
    return UserModel.fromMap(data!);
  }
}
