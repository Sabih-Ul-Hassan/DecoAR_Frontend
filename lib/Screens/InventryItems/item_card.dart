import 'package:decoar/varsiables.dart';
import 'package:flutter/material.dart';

class ItemCard extends StatelessWidget {
  Map item;
  ItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        // boxShadow: [
        //   BoxShadow(
        //       color: Colors.black,
        //       offset: Offset(0, 2),
        //       spreadRadius: 0,
        //       blurStyle: BlurStyle.normal,
        //       blurRadius: 5)
        // ]
      ),
      child: Column(children: [
        Expanded(
            child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12)),
                child: Image.network(
                  url + "uploads/" + item['image'],
                  fit: BoxFit.fill,
                ))),
        Padding(
            padding: EdgeInsets.only(right: 5, bottom: 5, left: 5),
            child: Column(children: [
              Row(children: [
                Flexible(
                  child: Text(item['title'],
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis),
                )
              ]),
              Row(children: [
                Text(item['category'],
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w400))
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(item['price'].toString() + " Rs",
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w400)),
                Text(item['availability'].toString() + " Left",
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w400))
              ]),
            ])),
      ]),
    );
  }
}

class PropValRow extends StatelessWidget {
  var prop;
  var value;
  PropValRow({this.prop, this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          prop,
          style: TextStyle(fontSize: 14),
        ),
        Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500))
      ],
    );
  }
}
