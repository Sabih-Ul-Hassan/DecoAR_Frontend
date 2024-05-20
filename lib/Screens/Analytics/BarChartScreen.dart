import 'dart:convert';
import 'package:decoar/APICalls/Analytics.dart';
import 'package:decoar/Providers/User.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

class BarChartFromApi extends StatefulWidget {
  const BarChartFromApi({Key? key}) : super(key: key);

  @override
  State<BarChartFromApi> createState() => _BarChartFromApiState();
}

class _BarChartFromApiState extends State<BarChartFromApi> {
  late String _selectedValue;
  late Future<List<List<Map<String, dynamic>>>> _apiDataFuture;
  late String userId;

  @override
  void initState() {
    super.initState();
    _selectedValue = 'allTime';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userId = Provider.of<UserProvider>(context).user!.userId;

    _apiDataFuture = getCharts(_selectedValue, userId);
  }

  @override
  Widget build(BuildContext context) {
    const barWidth = 20.0;
    const spacing = 20.0;
    const extraPadding = 20.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bar Chart from API Data'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            DropdownButton<String>(
              value: _selectedValue,
              onChanged: (newValue) {
                setState(() {
                  _selectedValue = newValue!;
                  _apiDataFuture = getCharts(_selectedValue, userId);
                });
              },
              items: <String>['thisMonth', 'thisYear', 'thisWeek', 'allTime']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            FutureBuilder<List<List<Map<String, dynamic>>>>(
              future: _apiDataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text('No data available'),
                  );
                } else {
                  final apiData = snapshot.data![0];
                  final orders = snapshot.data![1];
                  final cancelled = snapshot.data![2];
                  final maxYValue = apiData
                      .map((e) => double.parse(e["value"].toString()))
                      .reduce((a, b) => a > b ? a : b);

                  final totalBarWidth = apiData.length * (barWidth + spacing);
                  final chartWidth = totalBarWidth + extraPadding;
                  final totalBarWidth1 = orders.length * (barWidth + spacing);
                  final chartWidth1 = totalBarWidth1 + extraPadding;
                  final totalBarWidth2 =
                      cancelled.length * (barWidth + spacing);
                  final chartWidth2 = totalBarWidth2 + extraPadding;

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Revenue Chart",
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                          Container(
                            width: chartWidth > 130 ? chartWidth : 130,
                            height: 300,
                            padding: const EdgeInsets.only(right: 10, top: 20),
                            child: BarChart(
                              BarChartData(
                                minY: 0,
                                maxY: maxYValue,
                                gridData: const FlGridData(show: false),
                                borderData: FlBorderData(show: false),
                                titlesData: FlTitlesData(
                                    show: true,
                                    topTitles: const AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    rightTitles: const AxisTitles(
                                        sideTitles:
                                            SideTitles(showTitles: false)),
                                    bottomTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) {
                                        return Text(apiData[value.toInt() - 1]
                                                ["name"]
                                            .toString()
                                            .substring(
                                                0,
                                                _selectedValue == "thisYear"
                                                    ? 3
                                                    : _selectedValue ==
                                                            "allTime"
                                                        ? 4
                                                        : _selectedValue ==
                                                                "thisMonth"
                                                            ? null
                                                            : null));
                                      },
                                    ))),
                                barGroups: apiData
                                    .asMap()
                                    .map((i, e) => MapEntry(
                                        i + 1,
                                        BarChartGroupData(
                                          x: i + 1,
                                          barRods: [
                                            BarChartRodData(
                                              toY: double.parse(
                                                  e["value"].toString()),
                                              width: barWidth,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            )
                                          ],
                                          barsSpace: spacing,
                                        )))
                                    .values
                                    .toList(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Total Orders Chart",
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                          Container(
                            width: chartWidth1 > 130 ? chartWidth1 : 130,
                            height: 300,
                            padding: const EdgeInsets.only(right: 10, top: 20),
                            child: BarChart(
                              BarChartData(
                                minY: 0,
                                maxY: maxYValue,
                                gridData: const FlGridData(show: false),
                                borderData: FlBorderData(show: false),
                                titlesData: FlTitlesData(
                                    show: true,
                                    topTitles: const AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    rightTitles: const AxisTitles(
                                        sideTitles:
                                            SideTitles(showTitles: false)),
                                    bottomTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) {
                                        return Text(orders[value.toInt() - 1]
                                                ["name"]
                                            .toString()
                                            .substring(
                                                0,
                                                _selectedValue == "thisYear"
                                                    ? 3
                                                    : _selectedValue ==
                                                            "allTime"
                                                        ? 4
                                                        : _selectedValue ==
                                                                "thisMonth"
                                                            ? null
                                                            : null));
                                      },
                                    ))),
                                barGroups: orders
                                    .asMap()
                                    .map((i, e) => MapEntry(
                                        i + 1,
                                        BarChartGroupData(
                                          x: i + 1,
                                          barRods: [
                                            BarChartRodData(
                                              toY: double.parse(
                                                  e["value"].toString()),
                                              width: barWidth,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            )
                                          ],
                                          barsSpace: spacing,
                                        )))
                                    .values
                                    .toList(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Cancelled Orders Chart",
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                          Container(
                            width: chartWidth2 > 130 ? chartWidth2 : 130,
                            height: 300,
                            padding: const EdgeInsets.only(right: 10, top: 20),
                            child: BarChart(
                              BarChartData(
                                minY: 0,
                                maxY: maxYValue,
                                gridData: const FlGridData(show: false),
                                borderData: FlBorderData(show: false),
                                titlesData: FlTitlesData(
                                    show: true,
                                    topTitles: const AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    rightTitles: const AxisTitles(
                                        sideTitles:
                                            SideTitles(showTitles: false)),
                                    bottomTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) {
                                        return Text(cancelled[value.toInt() - 1]
                                                ["name"]
                                            .toString()
                                            .substring(
                                                0,
                                                _selectedValue == "thisYear"
                                                    ? 3
                                                    : _selectedValue ==
                                                            "allTime"
                                                        ? 4
                                                        : _selectedValue ==
                                                                "thisMonth"
                                                            ? null
                                                            : null));
                                      },
                                    ))),
                                barGroups: cancelled
                                    .asMap()
                                    .map((i, e) => MapEntry(
                                        i + 1,
                                        BarChartGroupData(
                                          x: i + 1,
                                          barRods: [
                                            BarChartRodData(
                                              toY: double.parse(
                                                  e["value"].toString()),
                                              width: barWidth,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            )
                                          ],
                                          barsSpace: spacing,
                                        )))
                                    .values
                                    .toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
