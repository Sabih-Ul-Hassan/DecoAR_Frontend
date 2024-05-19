import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:decoar/Screens/AddProduct/image_row.dart';

class ImagesSelector extends StatefulWidget {
  final List<File> imageList;

  ImagesSelector({required this.imageList});

  @override
  _ImagesSelectorState createState() => _ImagesSelectorState();
}

class _ImagesSelectorState extends State<ImagesSelector> {
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      widget.imageList.add(File(pickedFile.path));
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Visibility(
            child: SizedBox(height: 350), visible: widget.imageList.isEmpty),
        ImageRow(imageList: widget.imageList),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.gallery),
              child: Text('Add from Gallery'),
            ),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.camera),
              child: Text('Add from Camera'),
            ),
          ],
        ),
      ],
    );
  }
}
