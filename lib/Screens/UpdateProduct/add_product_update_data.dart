import 'dart:io';
import 'package:decoar/APICalls/inventry.dart';
import 'package:decoar/Screens/AddProduct/input.dart';
import 'package:decoar/Screens/AddProduct/text_list_widget.dart';
import 'package:decoar/varsiables.dart';
import 'package:flutter/material.dart';

class AddProductUpdateData extends StatefulWidget {
  var scrollController;
  List<File> imageList;
  Map item;
  AddProductUpdateData(
      {Key? key,
      required this.scrollController,
      this.imageList = const [],
      required this.item})
      : super(key: key);

  @override
  _AddProductDataState createState() => _AddProductDataState();
}

class _AddProductDataState extends State<AddProductUpdateData> {
  var titleController = TextEditingController();
  var descriptionController = TextEditingController();
  var avabilityController = TextEditingController();
  var priceController = TextEditingController();
  var catagoryController = TextEditingController();
  var shippingInfoController = TextEditingController();
  var shippingPriceController = TextEditingController();
  List tags = [];

  @override
  void initState() {
    super.initState();

    titleController.text = widget.item['title'] ?? '';
    descriptionController.text = widget.item['description'] ?? '';
    avabilityController.text = widget.item['availability']?.toString() ?? '';
    priceController.text = widget.item['price']?.toString() ?? '';
    catagoryController.text = widget.item['category'] ?? '';
    shippingInfoController.text = widget.item['shippingInfo'] ?? '';
    shippingPriceController.text =
        widget.item['shippingPrice']?.toString() ?? '';
    tags = List.from(widget.item['tags'] ?? []);
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(top: 10),
      child: SingleChildScrollView(
        controller: widget.scrollController,
        child: Column(
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 30, top: 10),
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
                var result = await updateProduct(widget.item['_id'], {
                  'title': titleController.text,
                  'price': priceController.text,
                  'availability': avabilityController.text,
                  'category': catagoryController.text,
                  'description': descriptionController.text,
                  'shippingInfo': shippingInfoController.text,
                  'shippingPrice': shippingPriceController.text,
                  'tags': tags,
                });

                final scaffold = ScaffoldMessenger.of(context);
                if (result) {
                  scaffold.showSnackBar(
                    SnackBar(
                      content: Text('Product updated successfully!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  Navigator.pop(context);
                } else {
                  scaffold.showSnackBar(
                    SnackBar(
                      content: Text(
                          'Failed to update the product. Please try again.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
