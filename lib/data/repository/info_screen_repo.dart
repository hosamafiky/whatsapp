import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../../helpers/firebase_database_helper/firebase_database_helper.dart';

class InfoScreenRepository {
  Future<UserModel?> getUserData() async {
    Map<String, dynamic>? data = await FirebaseDatabaseHelper()
        .getUserData(FirebaseAuth.instance.currentUser?.uid);
    return UserModel.fromMap(data!);
  }
}
