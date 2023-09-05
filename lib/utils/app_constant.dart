import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class Constant {
  Constant._(); // Private constructor

  static Constant _instance = Constant._(); // Singleton instance
  static Constant get instance => _instance; // Getter for the instance
  pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();

    XFile? _file = await _imagePicker.pickImage(source: source);
    if (_file != null) {
      return await _file.readAsBytes();
    } else {
      print('No image selected!');
    }
  }

  showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
