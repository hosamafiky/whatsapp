import 'dart:io';

import '../../data/models/user_model.dart';

abstract class InfoState {}

class InfoInitial extends InfoState {}

class InfoLoading extends InfoState {}

class InfoPickImageSuccess extends InfoState {
  final File? file;

  InfoPickImageSuccess(this.file);
}

class InfoPickImageError extends InfoState {
  final String error;

  InfoPickImageError(this.error);
}

class InfoSaveUserDataSuccess extends InfoState {}

class InfoSaveUserDataError extends InfoState {
  final String error;

  InfoSaveUserDataError(this.error);
}

class InfoUserDataSuccessState extends InfoState {
  final UserModel userModel;

  InfoUserDataSuccessState(this.userModel);
}

class InfoUserDataErrorState extends InfoState {
  final String error;

  InfoUserDataErrorState(this.error);
}
