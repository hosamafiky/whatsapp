import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../presentation/widgets/auth_widgets/error_dialog.dart';
import '../presentation/widgets/auth_widgets/loading_dialog.dart';

void showErrorDialog(BuildContext context, String error) {
  showDialog(
    context: context,
    builder: (context) => ErrorDialog(error: error),
  );
}

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const LoadingDialog(),
  );
}

Future<File?> pickFileFromGallery(BuildContext context) async {
  File? image;
  ImagePicker().pickImage(source: ImageSource.gallery).then((value) {
    if (value != null) {
      image = File(value.path);
    }
    return image;
  }).catchError((error) {
    showErrorDialog(context, error.toString());
    return null;
  });
  return null;
}
