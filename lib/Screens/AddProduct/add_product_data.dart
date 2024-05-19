import 'dart:io';
import 'package:decoar/Providers/User.dart';
import 'package:file_picker/file_picker.dart';
import 'package:decoar/Screens/AddProduct/input.dart';
import 'package:decoar/Screens/AddProduct/text_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

import '../../APICalls/inventry.dart';

enum Placement { wall, floor }

class AddProductData extends StatefulWidget {
  var scrollController;
  List<File> imageList;

  AddProductData(
      {Key? key, required this.scrollController, required this.imageList})
      : super(key: key);

  @override
  _AddProductDataState createState() => _AddProductDataState();
}

class _AddProductDataState extends State<AddProductData> {
  var titleController = TextEditingController();
  var descriptionController = TextEditingController();
  var avabilityController = TextEditingController();
  var altTextController = TextEditingController();
  var priceController = TextEditingController();
  var catagoryController = TextEditingController();
  var shippingInfoController = TextEditingController();
  var shippingPriceController = TextEditingController();
  Placement? placement;
  File? model = null;
  List tags = [];
  Color backgroundModelColor = Colors.transparent;
  String? userId;

  void fetchUserId(context) {
    userId ??= Provider.of<UserProvider>(context).user?.userId;
  }

  @override
  Widget build(BuildContext context) {
    fetchUserId(context);
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.only(top: 10),
      child: SingleChildScrollView(
        controller: widget.scrollController,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      'Details',
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                          left: 80, right: 80, bottom: 10, top: 10),
                      child: Divider()),
                ],
              ),
              Input(
                  textEditingController: titleController,
                  hint: "Title",
                  label: "Title"),
              Input(
                  textEditingController: descriptionController,
                  hint: "Description",
                  label: "Description",
                  maxLines: 3),
              Input(
                  textEditingController: priceController,
                  hint: "Price",
                  label: "Price",
                  keyboardType: TextInputType.number),
              Input(
                  textEditingController: avabilityController,
                  hint: "Avability",
                  label: "Avability",
                  keyboardType: TextInputType.number),
              Input(
                  textEditingController: catagoryController,
                  hint: "Catagory",
                  label: "Catagory"),
              Input(
                  textEditingController: shippingPriceController,
                  hint: "Shipping Price",
                  label: "Shipping Price",
                  keyboardType: TextInputType.number),
              Input(
                  textEditingController: shippingInfoController,
                  hint: "Shipping Info",
                  label: "Shipping Info"),
              TextListWidget(textList: tags),
              ElevatedButton(
                onPressed: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles();
                  if (result != null) {
                    setState(() {
                      model = File(result.files.single.path!);
                    });
                  }
                },
                child: const Text('Add Model'),
              ),
              SizedBox(height: 10),
              Visibility(
                  visible: model != null,
                  child: Text(model != null ? model!.path : "")),
              SizedBox(height: 10),
              Input(
                  textEditingController: altTextController,
                  hint: "describe your model",
                  label: "alternative model text"),
              const Text("Placement of product:"),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile(
                        title: Text(Placement.floor.name),
                        value: Placement.floor,
                        groupValue: placement,
                        onChanged: (val) {
                          setState(() {
                            placement = val;
                          });
                        }),
                  ),
                  Expanded(
                    child: RadioListTile(
                        title: Text(Placement.wall.name),
                        value: Placement.wall,
                        groupValue: placement,
                        onChanged: (val) {
                          setState(() {
                            placement = val;
                          });
                        }),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: 500,
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "slide down to close",
                              style: TextStyle(fontSize: 10),
                            ),
                            ColorPicker(
                              pickerColor: backgroundModelColor,
                              onColorChanged: (val) {
                                setState(() {
                                  backgroundModelColor = val;
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Text("set background color "),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  var result = await uploadProduct({
                    'title': titleController.text,
                    'price': priceController.text,
                    'availability': avabilityController.text,
                    'category': catagoryController.text,
                    'description': descriptionController.text,
                    'shippingInfo': shippingInfoController.text,
                    'shippingPrice': shippingPriceController.text,
                    'tags': tags,
                    "userId": userId,
                    'alternativeModelText': altTextController.text,
                    'placement': placement,
                    'backgroundModelColor': backgroundModelColor,
                  }, widget.imageList, model);

                  final scaffold = ScaffoldMessenger.of(context);
                  if (result) {
                    scaffold.showSnackBar(
                      const SnackBar(
                        content: Text('Product added successfully!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    Navigator.pop(context);
                  } else {
                    scaffold.showSnackBar(
                      const SnackBar(
                        content:
                            Text('Failed to add product. Please try again.'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                child: Text('Upload'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
