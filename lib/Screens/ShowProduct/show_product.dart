import 'dart:io';
import 'package:decoar/APICalls/inventry.dart';
import 'package:decoar/Screens/AddProduct/image_row.dart';
import 'package:decoar/Screens/ModelViewer/model_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shimmer/shimmer.dart';
import "../../varsiables.dart";
import 'draggable_prodcut_details.dart';
import 'shimmer_draggable_prodcut_details.dart';

class ShowProduct extends StatefulWidget {
  String id;
  ShowProduct({Key? key, required this.id}) : super(key: key);

  @override
  State<ShowProduct> createState() => _ShowProductState();
}

class _ShowProductState extends State<ShowProduct> {
  late Future<Map<String, dynamic>> item;
  bool showingModel = true;

  Future<bool> delete(BuildContext context, String id) async {
    bool deleted = await deleteProductById(id);
    if (deleted) {
      return true;
    } else
      return false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    load();
  }

  Future<void> load() async {
    item = fetchProductById(widget.id);
  }

  var bgclr = null;
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("data"),
      ),
      backgroundColor: bgclr != null
          ? Color(int.parse(bgclr, radix: 16) + 0xFF000000)
          : Colors.grey.shade300,
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => showingModel = !showingModel),
        shape: CircleBorder(),
        child: Icon(Icons.switch_right_rounded),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: item,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Stack(
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.white,
                  highlightColor: Colors.grey,
                  child: Container(
                    height: 350,
                    color: Colors.red,
                  ),
                ),
                ShimmerDraggableProdcutDetails()
              ],
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            Map<String, dynamic> item = snapshot.data!;
            item['backgroundModelColor'] != "0"
                ? bgclr = item['backgroundModelColor']
                : null;
            return Stack(
              children: [
                Visibility(
                    visible: showingModel,
                    child: ModelWidget(
                        item: item,
                        poster: "${url}uploads/${item['images'][0]}")),
                Visibility(
                  visible: !showingModel,
                  child: ImageRow(
                    imageList:
                        item['images'].map((x) => "${url}uploads/$x").toList(),
                    imgType: "urls",
                  ),
                ),
                DraggableProdcutDetails(
                  item: item,
                  delete: delete,
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
