import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePickerWidget extends StatefulWidget {
  const UserImagePickerWidget(
    
    {Key? key,required this.pickProfileImage,}
  ) : super(key: key);

  final void Function(File file) pickProfileImage;

  @override
  State<UserImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<UserImagePickerWidget> {
  
  File? _pickedImage;
  
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 10, maxWidth: 200);
    setState(() {
      _pickedImage = File(image!.path);
    });
    widget.pickProfileImage(_pickedImage!);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _pickImage,
      child: CircleAvatar(
        radius: 35,
        backgroundImage: _pickedImage != null ? FileImage(_pickedImage!) : null,
      ),
    );
  }
}
