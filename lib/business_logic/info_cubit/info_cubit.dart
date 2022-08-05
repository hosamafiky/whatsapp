import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/models/user_model.dart';
import '../../data/repository/info_screen_repo.dart';
import '../../helpers/firebase_database_helper/firebase_database_helper.dart';
import '../../helpers/firebase_storage_helper/firebase_storage_helper.dart';
import 'info_state.dart';

class InfoCubit extends Cubit<InfoState> {
  InfoCubit() : super(InfoInitial());

  static InfoCubit get(BuildContext context) => BlocProvider.of(context);

  void pickImageFromGallery() {
    ImagePicker().pickImage(source: ImageSource.gallery).then((value) {
      if (value != null) {
        ImageCropper().cropImage(
          sourcePath: value.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false,
            ),
            IOSUiSettings(
              title: 'Cropper',
            ),
          ],
        ).then((value) {
          if (value != null) {
            emit(InfoPickImageSuccess(File(value.path)));
          }
        });
      }
    }).catchError((error) {
      emit(InfoPickImageError(error.toString()));
    });
  }

  void pickImageFromCamera() {
    ImagePicker().pickImage(source: ImageSource.camera).then((value) async {
      if (value != null) {
        ImageCropper().cropImage(
          sourcePath: value.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false,
              hideBottomControls: true,
            ),
            IOSUiSettings(
              title: 'Cropper',
            ),
          ],
        ).then((value) {
          if (value != null) {
            emit(InfoPickImageSuccess(File(value.path)));
          }
        });
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
