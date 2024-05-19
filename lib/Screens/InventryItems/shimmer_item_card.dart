import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerItemCard extends StatelessWidget {
  const ShimmerItemCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: 150,
              width: double.infinity,
              color: Colors.yellow,
            ),
            Container(
              height: 20,
              width: double.infinity,
              color: Colors.yellow,
            ),
            Container(
              height: 20,
              width: double.infinity,
              color: Colors.yellow,
            ),
            Container(
              height: 20,
              width: double.infinity,
              color: Colors.yellow,
            ),
          ],
        ),
        baseColor: Colors.white,
        highlightColor: Colors.grey);
  }
}
