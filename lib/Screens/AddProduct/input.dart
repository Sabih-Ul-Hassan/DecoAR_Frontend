import 'dart:io';
import 'package:flutter/material.dart';

class Input extends StatefulWidget {
  final TextEditingController textEditingController;
  String hint;
  String label;
  int maxLines;
  var keyboardType;
  var suffixIcon;
  Input(
      {required this.textEditingController,
      required this.hint,
      required this.label,
      this.keyboardType = TextInputType.text,
      this.maxLines = 1,
      this.suffixIcon});

  @override
  _InputState createState() => _InputState();
}

class _InputState extends State<Input> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: TextField(
          controller: widget.textEditingController,
          decoration: InputDecoration(
              label: Text(widget.label),
              hintText: widget.hint,
              suffixIcon: widget.suffixIcon,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(width: 3))),
          maxLines: widget.maxLines,
          keyboardType: widget.keyboardType,
        ));
  }
}
