import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerDraggableProdcutDetails extends StatelessWidget {
  ShimmerDraggableProdcutDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      minChildSize: 0.46,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: EdgeInsets.all(10),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Shimmer.fromColors(
                baseColor: Colors.white,
                highlightColor: Colors.grey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 20,
                      width: double.infinity,
                      color: Colors.yellow,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      height: 20,
                      width: double.infinity,
                      color: Colors.yellow,
                    ),
                    Divider(
                      height: 30,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      height: 20,
                      width: double.infinity,
                      color: Colors.yellow,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      height: 20,
                      width: double.infinity,
                      color: Colors.yellow,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      height: 20,
                      width: double.infinity,
                      color: Colors.yellow,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      height: 20,
                      width: double.infinity,
                      color: Colors.yellow,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      height: 20,
                      width: double.infinity,
                      color: Colors.yellow,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }
}
