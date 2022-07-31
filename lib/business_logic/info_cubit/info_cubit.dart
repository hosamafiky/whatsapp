import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp_clone/business_logic/info_cubit/info_state.dart';
import 'package:whatsapp_clone/data/models/user_model.dart';
import 'package:whatsapp_clone/data/repository/info_screen_repo.dart';
import 'package:whatsapp_clone/helpers/firebase_database_helper/firebase_database_helper.dart';
import 'package:whatsapp_clone/helpers/firebase_storage_helper/firebase_storage_helper.dart';

class InfoCubit extends Cubit<InfoState> {
  InfoCubit() : super(InfoInitial());

  static InfoCubit get(BuildContext context) => BlocProvider.of(context);

  void pickImageFromGallery() {
    ImagePicker().pickImage(source: ImageSource.gallery).then((value) {
      emit(InfoPickImageSuccess(File(value!.path)));
    }).catchError((error) {
      emit(InfoPickImageError(error.toString()));
    });
  }

  void pickImageFromCamera() {
    ImagePicker().pickImage(source: ImageSource.camera).then((value) {
      if (value != null) {
        emit(InfoPickImageSuccess(File(value.path)));
      }
    }).catchError((error) {
      emit(InfoPickImageError(error.toString()));
    });
  }

  void getUserData() {
    emit(InfoLoading());
    InfoScreenRepository().getUserData().then((value) {
      emit(InfoUserDataSuccessState(value!));
    }).catchError((error) {
      emit(InfoUserDataErrorState(error.toString()));
    });
  }

  void saveUserData({
    required String name,
    required String status,
    required File? file,
    required BuildContext context,
  }) async {
    try {
      emit(InfoLoading());
      String uId = FirebaseAuth.instance.currentUser!.uid;
      var currentUserData = await FirebaseDatabaseHelper().getUserData(uId);
      String profilePictureUrl =
          'https://www.pngitem.com/pimgs/m/421-4212617_person-placeholder-image-transparent-hd-png-download.png';
      if (currentUserData != null) {
        UserModel currentUserModel = UserModel.fromMap(currentUserData);
        profilePictureUrl = currentUserModel.profilePicture;
      }
      if (file != null) {
        profilePictureUrl =
            await FirebaseStorageHelper().uploadFileToFirestoreDatabase(
          path: 'profilePictures/$uId',
          file: file,
        );
      }

      var user = UserModel(
        uId: uId,
        name: name,
        status: status,
        profilePicture: profilePictureUrl,
        isOnline: true,
        phoneNumber: FirebaseAuth.instance.currentUser!.phoneNumber!,
        groupId: [],
      );

      await FirebaseDatabaseHelper()
          .storeUserData(uId: uId, data: user.toMap())
          .then((value) {
        emit(InfoSaveUserDataSuccess());
      });
    } catch (error) {
      emit(InfoSaveUserDataError(error.toString()));
    }
  }
}
