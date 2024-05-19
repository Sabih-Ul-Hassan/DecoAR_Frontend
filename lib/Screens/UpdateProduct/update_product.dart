import 'package:decoar/Screens/UpdateProduct/add_product_update_data.dart';
import 'package:flutter/material.dart';

class UpdateProduct extends StatefulWidget {
  Map item;
  UpdateProduct({Key? key, required this.item}) : super(key: key);

  @override
  _UpdateProductState createState() => _UpdateProductState();
}

class _UpdateProductState extends State<UpdateProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("data"),
      ),
      backgroundColor: Colors.grey.shade300,
      body: Stack(
        children: [
          // ImagesSelector(imageList: ),
          DraggableScrollableSheet(
            initialChildSize: 1,
            maxChildSize: 1,
            minChildSize: 1,
            builder: (context, scrollController) => AddProductUpdateData(
                scrollController: scrollController, item: widget.item),
          ),
        ],
      ),
    );
  }
}
