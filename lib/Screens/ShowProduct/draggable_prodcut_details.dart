import 'package:decoar/APICalls/reviews.dart';
import 'package:decoar/Classes/User.dart';
import 'package:decoar/Hive/CartHIve.dart';
import 'package:decoar/Providers/User.dart';
import 'package:decoar/Screens/ShowProduct/tags.dart';
import 'package:decoar/Screens/WishLits/AddToList.dart';
import 'package:decoar/varsiables.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'add_item_bottom_sheet.dart';
import 'edit_review_form.dart';
import 'review_form.dart';
import 'review_tile.dart';
import 'reviews_bottom_sheet.dart';

class DraggableProdcutDetails extends StatefulWidget {
  Map item;
  Function delete;
  DraggableProdcutDetails({Key? key, required this.item, required this.delete})
      : super(key: key);

  @override
  State<DraggableProdcutDetails> createState() =>
      _DraggableProdcutDetailsState();
}

class _DraggableProdcutDetailsState extends State<DraggableProdcutDetails> {
  String? userId;

  String? userType;

  void fetchUserId(context) {
    User? user = Provider.of<UserProvider>(context).user;
    userId ??= user?.userId;
    userType = user?.userType;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    fetchUserId(context);
  }

  void _showWishlistBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return AddToList(userId: userId!, item: {
          '_id': widget.item['_id'],
          "imageUrl": widget.item['images'][0],
          "title": widget.item['title']
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      minChildSize: 0.46,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: EdgeInsets.all(10),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.item['title'],
                        style: TextStyle(fontSize: 20),
                        maxLines: null,
                        softWrap: true,
                      ),
                      const Divider(
                        height: 30,
                      ),
                      Row(children: [
                        IconButton(
                          icon: Icon(Icons.shopping_cart),
                          onPressed: () async {
                            bool exists = await checkIfItemExistsInCart(
                                userId!, widget.item["_id"]);
                            if (exists) {
                              const snackBar = SnackBar(
                                content: Text('Item already exists in cart.'),
                                duration: Duration(seconds: 1),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else {
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return AddItemBottomSheet(
                                    availability: widget.item['availability'],
                                    item: widget.item,
                                    userId: userId!,
                                    price: widget.item['price'] is int
                                        ? widget.item['price']
                                        : int.parse(widget.item['price']),
                                  );
                                },
                              );
                            }
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.favorite_border),
                          onPressed: () {
                            _showWishlistBottomSheet(context);
                          },
                        )
                      ])
                    ],
                  ),
                  const Divider(
                    height: 30,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Category : " + widget.item['category'],
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400),
                        maxLines: null,
                        softWrap: true,
                      ),
                      Row(children: [
                        Text(
                          "(${widget.item['reviews']} ratings)",
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                        ...List.generate(
                            5,
                            (index) => Icon(
                                  index > widget.item['averageRating'] &&
                                          index ==
                                              widget.item['averageRating']
                                                  .ceil()
                                      ? Icons.star_half
                                      : Icons.star,
                                  color: index < widget.item['averageRating'] ||
                                          index ==
                                                  widget.item['averageRating']
                                                      .ceil() &&
                                              index !=
                                                  widget.item['averageRating']
                                      ? Colors.yellow
                                      : Colors.grey,
                                ))
                      ])
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    widget.item['description'],
                    style: const TextStyle(fontSize: 16),
                    maxLines: null,
                    softWrap: true,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text("${widget.item['availability']} Items Left",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(
                    height: 15,
                  ),
                  Text("${widget.item['price']} Rs",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(
                    height: 15,
                  ),
                  Text("${widget.item['shippingPrice']} Rs Shipping",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    widget.item['shippingInfo'],
                    style: TextStyle(fontSize: 16),
                    maxLines: null,
                    softWrap: true,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Tags(tags: widget.item['tags']),
                  const SizedBox(
                    height: 25,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return Container(
                              constraints: BoxConstraints(
                                maxHeight:
                                    MediaQuery.of(context).size.height * 0.9,
                              ),
                              child: ReviewsBottomSheet(item: widget.item));
                        },
                      );
                    },
                    child: Text('${widget.item['reviews']} Reviews'),
                  ),
                  Visibility(
                    visible: userType != 'user',
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            await Navigator.pushNamed(context, '/updateProduct',
                                arguments: widget.item);
                            Navigator.pop(context, true);
                          },
                          child: Text('Update'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            bool result = await widget.delete(
                                context, widget.item['_id']);
                            final scaffold = ScaffoldMessenger.of(context);
                            if (result) {
                              scaffold.showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Product deleted successfully!'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                              Navigator.pop(context, true);
                            } else {
                              scaffold.showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Failed to delete product. Please try again.'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                          child: Text('Delete'),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ));
      },
    );
  }
}
