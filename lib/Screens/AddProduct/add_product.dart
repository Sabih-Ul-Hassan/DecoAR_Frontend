import 'dart:io';
import 'package:decoar/Screens/AddProduct/add_product_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:decoar/Screens/AddProduct/images_selector.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  List<File> _imageList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("data"),
      ),
      body: Stack(
        children: [
          ImagesSelector(imageList: _imageList),
          DraggableScrollableSheet(
            initialChildSize: 0.5,
            maxChildSize: 0.95,
            minChildSize: 0.37,
            builder: (context, scrollController) => AddProductData(
                scrollController: scrollController, imageList: _imageList),
          ),
        ],
      ),
    );
  }
}
