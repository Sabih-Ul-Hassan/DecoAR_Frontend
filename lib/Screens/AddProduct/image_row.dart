import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageRow extends StatefulWidget {
  final List imageList;
  final String imgType;

  const ImageRow({required this.imageList, this.imgType = "file"});

  @override
  _ImageRowState createState() => _ImageRowState();
}

class _ImageRowState extends State<ImageRow> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: widget.imageList.asMap().entries.map((entry) {
          final int index = entry.key;
          var image = entry.value;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                widget.imgType == 'file'
                    ? Image.file(
                        image,
                        width: 350.0, // Set the desired width of each image
                        height: 350.0, // Set the desired height of each image
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        image as String,
                        width: 350.0, // Set the desired width of each image
                        height: 350.0, // Set the desired height of each image
                        fit: BoxFit.cover,
                      ),
                Visibility(
                  visible: widget.imgType == 'file',
                  child: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      // Remove the image from the list
                      setState(() {
                        widget.imageList.removeAt(index);
                      });
                    },
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
