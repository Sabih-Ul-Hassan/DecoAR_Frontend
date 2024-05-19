import 'dart:async';

import 'package:decoar/APICalls/Analytics.dart';
import 'package:decoar/Screens/Analytics/ExcelView.dart';
import 'package:decoar/Screens/Analytics/FilterSheetForm.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  _AnalyticsScreenState createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  bool graphs = false;

  void manageboxes() {
    if (!Hive.isBoxOpen('sheet_filter_criteria')) {
      Hive.openBox('sheet_filter_criteria').then((value) => setState(() {}));
    }
    if (!Hive.isBoxOpen('_timeFilterBox')) {
      Hive.openBox('_timeFilterBox').then((value) => setState(() {}));
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    manageboxes();
  }

  @override
  Widget build(BuildContext context) {
    if (!Hive.isBoxOpen('sheet_filter_criteria'))
      Hive.openBox('sheet_filter_criteria');
    if (!Hive.isBoxOpen('_timeFilterBox')) Hive.openBox('_timeFilterBox');
    return Scaffold(
      body: Analytics(),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          graphs = !graphs;
        },
        child: Icon(Icons.bar_chart_outlined),
      ),
    );
  }
}
