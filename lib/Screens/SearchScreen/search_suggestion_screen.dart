import 'package:flutter/material.dart';
import '../../APICalls/search.dart';

class SearchSuggestionScreen extends StatefulWidget {
  // late TextEditingController searchController = TextEditingController();
  SearchSuggestionScreen({
    Key? key,
    //required TextEditingController searchController
  }) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchSuggestionScreen> {
  TextEditingController _searchController = TextEditingController();
  List<String> suggestions = [];
  String selectedSuggestion = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ara"),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Column(
          children: [
            Container(
              height: 45,
              child: TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  filled: true,
                  prefixIcon: Icon(Icons.search),
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: BorderSide(width: 3),
                  ),
                ),
                onChanged: (value) async {
                  suggestions =
                      await fetchProductSuggestions(_searchController.text);
                  setState(() {});
                },
                onEditingComplete: () async {
                  if (Navigator.of(context).canPop())
                    Navigator.of(context).popAndPushNamed('/searchScreen',
                        arguments: _searchController.text);
                  else
                    Navigator.of(context).pushNamed('/searchScreen',
                        arguments: _searchController.text);
                },
              ),
            ),
            Expanded(
              child: ListView(
                children: suggestions
                    .map((title) => Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        margin: const EdgeInsets.fromLTRB(5, 10, 5, 0),
                        padding: const EdgeInsets.all(1),
                        child: ListTile(
                          style: ListTileStyle.drawer,
                          title: Text(title),
                          onTap: () {
                            // Set selected suggestion and call API to get details
                            setState(() {
                              selectedSuggestion = title;
                            });
                            //fetchDetails(selectedSuggestion);
                          },
                        )))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
