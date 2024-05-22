import 'dart:convert';
import 'package:decoar/varsiables.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<Map<String, dynamic>>> _fetchData() async {
  final response = await http.get(Uri.parse(url + 'admin/users/'));
  if (response.statusCode == 200) {
    return List<Map<String, dynamic>>.from(json.decode(response.body));
  } else {
    return [];
  }
}

class AllUsers extends StatefulWidget {
  const AllUsers({Key? key}) : super(key: key);

  @override
  _AllUsersState createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  List<Map<String, dynamic>> _data = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    setState(() {
      _isLoading = true;
    });
    _data = await _fetchData();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _isLoading
                ? CircularProgressIndicator()
                : Expanded(
                    child: ListView.builder(
                      itemCount: _data.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> item = _data[index];
                        print(item);
                        return Container(
                          margin: const EdgeInsets.all(8.0),
                          child: ListTile(
                            onTap: () {
                              Navigator.pushNamed(context, "/searchedUserAdmin",
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
