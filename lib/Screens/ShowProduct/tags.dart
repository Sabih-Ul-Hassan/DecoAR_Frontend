import 'package:flutter/material.dart';

class Tags extends StatelessWidget {
  final List tags;

  Tags({required this.tags});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0, // Adjust the spacing between texts
      runSpacing: 8.0, // Adjust the spacing between lines
      children: tags.map((text) {
        return Chip(
          label: Text(text),
          // You can customize the Chip appearance here
        );
      }).toList(),
    );
  }
}
