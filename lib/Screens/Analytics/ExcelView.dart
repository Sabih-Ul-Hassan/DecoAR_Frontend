import 'dart:convert';
import 'dart:io';

import 'package:decoar/APICalls/Analytics.dart';
import 'package:decoar/Providers/User.dart';
import 'package:decoar/Screens/Analytics/FilterSheetForm.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../varsiables.dart';

class Analytics extends StatefulWidget {
  Analytics({Key? key}) : super(key: key);

  @override
  _AnalyticsState createState() => _AnalyticsState();
}

class _AnalyticsState extends State<Analytics> {
  late String userId;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    userId = Provider.of<UserProvider>(context).user!.userId;
    _data = loadFilterAnalyticsData(userId);
    reload = (String userId_) {
      _data = loadFilterAnalyticsData(userId_);
    };
  }

  late Future<List<Map<String, dynamic>>> _data;

  bool filterForm = false;

  @override
  void initState() {
    super.initState();
  }

  late Function reload;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(' '),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            filterForm = !filterForm;
          });
        },
        child: Icon(Icons.filter_alt),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return Stack(children: [
              Center(child: Text("No data to display")),
              IgnorePointer(
                ignoring: !filterForm,
                child: AnimatedOpacity(
                  opacity: filterForm ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 500),
                  child: FilterSheetForm(
                    reload: reload,
                  ),
                ),
              )
            ]);
          } else {
            return Stack(children: [
              displayGrid(snapshot.data!),
              IgnorePointer(
                ignoring: !filterForm,
                child: AnimatedOpacity(
                  opacity: filterForm ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 500),
                  child: FilterSheetForm(
                    reload: reload,
                  ),
                ),
              )
            ]);
          }
        },
      ),
    );
  }

  String camelCaseToWords(String input) {
    RegExp regExp = RegExp(r'(?<=[a-z])[A-Z]');
    String result = input.replaceAllMapped(regExp, (Match match) {
      return ' ${match.group(0)}';
    });
    result = result.substring(0, 1).toUpperCase() + result.substring(1);
    return result;
  }

  Widget displayGrid(List<Map<String, dynamic>> data) {
    List<DataRow> rows = [];
    List<DataColumn> columns = [];

    Set<String> keys = data.expand((item) => item.keys).toSet();

    keys.forEach((key) {
      columns.add(DataColumn(label: Text(camelCaseToWords(key))));
    });

    data.forEach((item) {
      List<DataCell> cells = [];
      keys.forEach((key) {
        cells.add(
            DataCell(Text(item.containsKey(key) ? item[key].toString() : "")));
      });
      rows.add(DataRow(cells: cells));
    });

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          color: Colors.white,
          child: DataTable(
            columns: columns,
            rows: rows,
          ),
        ),
      ),
    );
  }
}
