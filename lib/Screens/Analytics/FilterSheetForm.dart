import 'package:decoar/Providers/User.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

class FilterSheetForm extends StatefulWidget {
  Function reload;

  FilterSheetForm({Key? key, required this.reload}) : super(key: key);

  @override
  _FilterSheetFormState createState() => _FilterSheetFormState();
}

class _FilterSheetFormState extends State<FilterSheetForm> {
  String? category;
  int? minPrice;
  int? maxPrice;
  String? selectedDate;
  String? sortBy;

  List<String> sortOptions = ['most_selling', 'most_revenue'];
  List<String> dateOptions = [
    'last_week',
    'last_month',
    'last_year',
    'all_times'
  ];
  List<String> categories = ['sculpture', 'painting', 'calligraphy'];

  late Box _filterBox;
  late Box _timeFilterBox;
  late String userId;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    setState(() {
      userId = Provider.of<UserProvider>(context).user!.userId;
    });
  }

  @override
  void initState() {
    super.initState();

    _filterBox = Hive.box('sheet_filter_criteria');
    _timeFilterBox = Hive.box('_timeFilterBox');
    setState(() {
      category = _filterBox.get('category', defaultValue: null);
      minPrice = _filterBox.get('minPrice', defaultValue: null);
      maxPrice = _filterBox.get('maxPrice', defaultValue: null);
      selectedDate = _filterBox.get('date', defaultValue: 'all_times');
      sortBy = _filterBox.get('sortBy', defaultValue: null);
      minPController = TextEditingController(
          text: minPrice != null ? minPrice?.toString() : "0");
      maxPController = TextEditingController(
          text: maxPrice != null ? maxPrice?.toString() : "0");
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  late TextEditingController minPController;
  late TextEditingController maxPController;

  void applyFilter() {
    _timeFilterBox.put('category', category);
    _timeFilterBox.put('minPrice', minPrice);
    _timeFilterBox.put('maxPrice', maxPrice);
    _timeFilterBox.put('date', selectedDate);
    _timeFilterBox.put('sortBy', sortBy);
    widget.reload(userId);
  }

  void saveFilter() {
    _filterBox.put('category', category);
    _filterBox.put('minPrice', minPrice);
    _filterBox.put('maxPrice', maxPrice);
    _filterBox.put('date', selectedDate);
    _filterBox.put('sortBy', sortBy);
    widget.reload();
  }

  void clearFilter() {
    setState(() {
      category = null;
      minPrice = null;
      maxPrice = null;
      selectedDate = 'all_times';
      sortBy = null;
    });
    minPController.text = "0";
    maxPController.text = "0";
    _filterBox.clear();
    _timeFilterBox.clear();
    widget.reload();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.maxFinite,
      padding: EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 0.8),
        borderRadius: BorderRadius.circular(15),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Min Price',
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  minPrice = int.tryParse(minPController.text);
                });
              },
              controller: minPController,
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Max Price',
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  maxPrice = int.tryParse(maxPController.text);
                });
              },
              controller: maxPController,
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: category,
              decoration: InputDecoration(
                labelText: 'Category',
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
              items: categories.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  category = value;
                });
              },
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: selectedDate,
              decoration: InputDecoration(
                labelText: 'Date',
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
              items: dateOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  selectedDate = value;
                });
              },
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: sortBy,
              decoration: InputDecoration(
                labelText: 'Sort By',
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
              items: sortOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  sortBy = value;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: applyFilter,
              child: Text('Apply Filter'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: saveFilter,
              child: Text('Save'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: clearFilter,
              child: Text('Clear'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
