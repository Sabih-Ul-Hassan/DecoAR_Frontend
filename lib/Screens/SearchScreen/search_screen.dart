import 'package:flutter/material.dart';

class SearchSuggestion extends StatefulWidget {
  const SearchSuggestion({super.key});

  @override
  State<SearchSuggestion> createState() => _SearchSuggestionState();
}

class _SearchSuggestionState extends State<SearchSuggestion> {
  TextEditingController _searchController = TextEditingController();
  List<String> suggestions = [];
  String selectedSuggestion = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("API Suggestions Demo"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                       
                    },
                    decoration: InputDecoration(
                      hintText: 'Search...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                   
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: suggestions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(suggestions[index]),
                  onTap: () {
                     setState(() {
                      selectedSuggestion = suggestions[index];
                    });
                     },
                  trailing: IconButton(
                    icon: Icon(Icons.arrow_right),
                    onPressed: () {
                       _searchController.text = suggestions[index];
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
