import 'dart:typed_data';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

final messengerKey = GlobalKey<ScaffoldMessengerState>();

const OutlineInputBorder textFieldFoucedBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(20)),
  borderSide: BorderSide(
    color: Colors.grey,
    width: 2,
  ),
);

const OutlineInputBorder textFieldunabledBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(20)),
  borderSide: BorderSide(
    color: Colors.grey,
    width: 1,
  ),
);

String? Function(String?) emailValidator = (email) =>
email != null && !EmailValidator.validate(email)
    ? "*Enter a valid email"
    : null;

String? Function(String?) passwordValidator = (password) =>
password != null && password.length < 6 ? "Enter min. 6 charactor" : null;

void showSnackBar(String? text) {
  if (text == null) return;

  final snackBar = SnackBar(
    content: Text(text),
    backgroundColor: Colors.red,
  );

  messengerKey.currentState!
    ..removeCurrentSnackBar()
    ..showSnackBar(snackBar);
}

Future<bool> permissions(Permission type) async {
  PermissionStatus permission = await type.status;
  if (permission.isGranted) {
    return true;
  } else if (permission.isDenied) {
    permission = await type.request();
    if (permission.isGranted) return true;
    return false;
  } else {
    openAppSettings();
    return await type.status.isGranted;
  }
}

Future<Uint8List?> pickImage(ImageSource source) async {
  bool status = source == ImageSource.gallery
      ? await permissions(Permission.storage)
      : await permissions(Permission.camera);
  if (status) {
    final ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: source);
    if (file != null) {
      return await file.readAsBytes();
    }
  }
  return null;
}

TextFormField profileTextField(
    {required String hint,
      required bool enabled,
      required TextEditingController controller}) {
  return TextFormField(
    enabled: enabled,
    controller: controller,
    decoration: InputDecoration(
      hintText: hint,
    ),
  );
}

showOptionsDialog(
    BuildContext context, void Function(Uint8List? file) callback) {
  showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      children: [
        SimpleDialogOption(
          onPressed: () async {
            Navigator.of(context).pop();
            callback(await pickImage(ImageSource.gallery));
          },
          child: const Row(
            children: [
              Icon(Icons.image),
              Padding(
                padding: EdgeInsets.all(7.0),
                child: Text(
                  'Gallery',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
        SimpleDialogOption(
          onPressed: () async {
            Navigator.of(context).pop();
            callback(await pickImage(ImageSource.camera));
          },
          child: const Row(
            children: [
              Icon(Icons.camera_alt),
              Padding(
                padding: EdgeInsets.all(7.0),
                child: Text(
                  'Camera',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
        SimpleDialogOption(
          onPressed: () => Navigator.of(context).pop(),
          child: const Row(
            children: [
              Icon(Icons.cancel),
              Padding(
                padding: EdgeInsets.all(7.0),
                child: Text(
                  'Cancel',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}