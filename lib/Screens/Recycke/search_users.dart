import 'dart:convert';

import 'package:decoar/varsiables.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<Map<String, dynamic>>> _fetchData(String query) async {
  print('search/users/' + query);
  final response = await http.get(Uri.parse(url + 'search/users/' + query));

  if (response.statusCode == 200) {
    return List<Map<String, dynamic>>.from(json.decode(response.body));
  } else {
    return [];
  }
}

class SearchUsers extends StatefulWidget {
  const SearchUsers({Key? key}) : super(key: key);

  @override
  _SearchUsersState createState() => _SearchUsersState();
}

class _SearchUsersState extends State<SearchUsers> {
  List<Map<String, dynamic>> _data = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SearchAppBar(
              api: (text) async {
                setState(() {
                  _isLoading = true;
                });
                _data = await _fetchData(text);
                setState(() {
                  _isLoading = false;
                });
              },
              controller: controller,
            ),
            SizedBox(height: 10),
            _isLoading
                ? CircularProgressIndicator()
                : Expanded(
                    child: ListView.builder(
                      itemCount: _data.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> item = _data[index];
                        return Container(
                          margin: const EdgeInsets.all(8.0),
                          child: ListTile(
                            onTap: () {
                              Navigator.pushNamed(context, "/searchedUser",
                                  arguments: item["_id"]);
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            tileColor: Colors.white,
                            contentPadding: EdgeInsets.all(16.0),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  url + "uploads/" + item["picture"]),
                            ),
                            title: Text(item['name']),
                            subtitle: Text(item["email"]),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class SearchAppBar extends StatelessWidget {
  late Function(String) api;
  late TextEditingController controller;
  SearchAppBar({Key? key, required this.api, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      flexibleSpace: Padding(
        padding: const EdgeInsets.fromLTRB(2, 8, 2, 8),
        child: SizedBox(
          height: 45,
          child: TextField(
            controller: controller,
            onChanged: api,
            decoration: InputDecoration(
              filled: true,
              prefixIcon: Icon(Icons.search),
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100),
                borderSide: BorderSide(width: 5, color: Colors.grey),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
