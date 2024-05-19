import 'package:decoar/Screens/AddProduct/input.dart';
import 'package:decoar/Screens/ShowProduct/tags.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TextListWidget extends StatefulWidget {
  List textList;
  TextListWidget({required this.textList});
  @override
  _TextListWidgetState createState() => _TextListWidgetState();
}

class _TextListWidgetState extends State<TextListWidget> {
  TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed
    _textEditingController.dispose();
    super.dispose();
  }

  void _addTextToList() {
    String enteredText = _textEditingController.text.trim();
    if (enteredText.isNotEmpty) {
      setState(() {
        widget.textList.add(enteredText);
        _textEditingController.clear();
      });
    }
  }

  void _removeTextFromList(int index) {
    setState(() {
      widget.textList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Input(
          textEditingController: _textEditingController,
          hint: "tag",
          label: 'tag',
          suffixIcon: IconButton(
            icon: Icon(Icons.check),
            onPressed: _addTextToList,
          ),
        ),
        SizedBox(height: 16.0),
        widget.textList.length > 0 ? Text('Tags:') : SizedBox(height: 0),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.textList.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(widget.textList[index]),
                  onDismissed: (direction) {
                    _removeTextFromList(index);
                  },
                  background: Container(
                    color: Colors.red,
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 16.0),
                  ),
                  child: ListTile(
                    title: Text(widget.textList[index]),
                  ),
                );
              },
            )),
      ],
    );
  }
}
