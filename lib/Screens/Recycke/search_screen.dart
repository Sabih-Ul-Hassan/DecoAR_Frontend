import 'package:decoar/APICalls/search.dart';
import 'package:decoar/Screens/InventryItems/item_card.dart';
import 'package:decoar/Screens/Recycke/search_users.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';

class SearchScreen extends StatefulWidget {
  late String query;

  SearchScreen({Key? key, required this.query}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool items = true;
  late Future<List<dynamic>> _productsFuture;
  TextEditingController search = TextEditingController();
  bool _isactionButtonVisible = true;
  late ScrollController _scrollController;
  bool _isfilterVisibile = false;
  void reload(String x) {
    _productsFuture = searchProducts(x);
  }

  late Box _tempFilterBox;
  @override
  void initState() {
    super.initState();
    _productsFuture = searchProducts(widget.query);
    _scrollController = ScrollController();
    _tempFilterBox = Hive.box('temp_filter');
    _scrollController.addListener(_scrollListener);
    search.text = widget.query;
  }

  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      setState(() {
        _isactionButtonVisible = true;
      });
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      setState(() {
        _isactionButtonVisible = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search ${items ? "Items" : "Users"}"),
      ),
      body: !items
          ? SearchUsers()
          : Stack(
              children: [
                ProductsList(
                    scrollController: _scrollController,
                    productsFuture: _productsFuture),
                IgnorePointer(
                  ignoring: !_isfilterVisibile,
                  child: AnimatedOpacity(
                    opacity: _isfilterVisibile ? 1.0 : 0.0,
                    duration: Duration(milliseconds: 500),
                    child: FilterForm(reload: reload, query: widget.query),
                  ),
                )
              ],
            ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (items)
            AnimatedOpacity(
              opacity: _isactionButtonVisible ? 1.0 : 0.0,
              duration: Duration(milliseconds: 500),
              child: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    _isfilterVisibile = !_isfilterVisibile;
                  });
                },
                child: Icon(Icons.filter_alt_rounded),
              ),
            ),
          FloatingActionButton(
              onPressed: () {
                setState(() {
                  items = !items;
                });
              },
              child: Icon(items
                  ? Icons.person_search_rounded
                  : Icons.image_search_sharp))
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class FilterForm extends StatefulWidget {
  late Function reload;
  late String query;
  FilterForm({Key? key, required this.reload, required this.query})
      : super(key: key);

  @override
  State<FilterForm> createState() => _FilterFormState();
}

class _FilterFormState extends State<FilterForm> {
  String? title;
  String? category;
  int? minPrice;
  int? maxPrice;
  String? sortBy;

  List<String> categories = ['sculpture', 'painting', 'calligraphy'];
  List<String> sortOptions = [
    'Price Low to High',
    'Price High to Low',
    'Date Added'
  ];

  late Box _filterBox;

  var _tempFilterBox;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.query);
    minPController = TextEditingController(text: minPrice?.toString());
    maxPController = TextEditingController(text: maxPrice?.toString());
    _filterBox = Hive.box('filter_criteria');
    _tempFilterBox = Hive.box('temp_filter');
    title = widget.query;
    setState(() {
      title = _filterBox.get('title', defaultValue: widget.query);
      minPrice = _filterBox.get('minPrice', defaultValue: null);
      maxPrice = _filterBox.get('maxPrice', defaultValue: null);
      category = _filterBox.get('category', defaultValue: null);
      sortBy = _filterBox.get('sortBy', defaultValue: null);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  late TextEditingController titleController;
  late TextEditingController minPController;
  late TextEditingController maxPController;
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
                labelText: 'Title',
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  title = titleController.text;
                });
              },
              controller: titleController,
            ),
            SizedBox(height: 20),
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
              onPressed: () {
                _filterBox.put('title', title);
                _filterBox.put('minPrice', minPrice);
                _filterBox.put('maxPrice', maxPrice);
                _filterBox.put('category', category);
                _filterBox.put('sortBy', sortBy);
              },
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
              onPressed: () {
                setState(() {
                  title = widget.query;
                  minPrice = null;
                  maxPrice = null;
                  category = null;
                  sortBy = null;
                });
                _filterBox.clear();
              },
              child: Text('Clear'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _tempFilterBox.put('title', title);
                _tempFilterBox.put('minPrice', minPrice);
                _tempFilterBox.put('maxPrice', maxPrice);
                _tempFilterBox.put('category', category);
                _tempFilterBox.put('sortBy', sortBy);
                widget.reload(title);
              },
              child: Text('Apply Filter'),
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

class ProductsList extends StatelessWidget {
  const ProductsList({
    super.key,
    required ScrollController scrollController,
    required Future<List> productsFuture,
  })  : _scrollController = scrollController,
        _productsFuture = productsFuture;

  final ScrollController _scrollController;
  final Future<List> _productsFuture;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        const SliverSearchAppBar(),
        FutureBuilder<List<dynamic>>(
          future: _productsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Display a loading indicator while the data is being fetched
              return const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (snapshot.hasError) {
              // Handle errors
              return SliverFillRemaining(
                child: Center(
                  child: Text('Error: ${snapshot.error}'),
                ),
              );
            } else {
              // Display the data once it's loaded
              List<dynamic> products = snapshot.data ?? [];
              return SliverPadding(
                padding: const EdgeInsets.all(10),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 18.0,
                    mainAxisSpacing: 18.0,
                    childAspectRatio: 0.65,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return GestureDetector(
                          onTap: () => Navigator.of(context).pushNamed(
                              "/product",
                              arguments: products[index]['_id']),
                          child: ItemCard(item: products[index]));
                    },
                    childCount: products.length,
                  ),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}

class SliverSearchAppBar extends StatelessWidget {
  const SliverSearchAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      titleSpacing: 50,
      automaticallyImplyLeading: false,
      floating: true,
      toolbarHeight: 60,
      backgroundColor: Colors.transparent,
      centerTitle: true,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(
          top: 10,
          left: 10.0,
          right: 10.0,
        ),
        title: SizedBox(
          height: 45,
          child: GestureDetector(
            onTap: () =>
                Navigator.of(context).pushNamed('/searchSuggestionScreen'),
            child: AbsorbPointer(
              child: TextField(
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
        ),
      ),
    );
  }
}
