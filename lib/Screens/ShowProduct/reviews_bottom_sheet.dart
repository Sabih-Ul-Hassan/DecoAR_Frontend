import 'package:decoar/APICalls/reviews.dart';
import 'package:decoar/Providers/User.dart';
import 'package:decoar/Screens/ShowProduct/draggable_prodcut_details.dart';
import 'package:decoar/Screens/ShowProduct/review_form.dart';
import 'package:decoar/Screens/ShowProduct/review_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ReviewsBottomSheet extends StatefulWidget {
  final Map item;

  ReviewsBottomSheet({required this.item});

  @override
  _ReviewsBottomSheetState createState() => _ReviewsBottomSheetState();
}

class _ReviewsBottomSheetState extends State<ReviewsBottomSheet> {
  late Future<Map<String, dynamic>> reviews;

  ScrollController reviewScrollController = ScrollController();
  @override
  void initState() {
    super.initState();
  }

  String? userId;

  void fetchUserId(context) {
    userId ??= Provider.of<UserProvider>(context).user?.userId;
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    fetchUserId(context);
    reviews = fetchReviews(widget.item['_id'], userId!);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: FutureBuilder<Map<String, dynamic>>(
        future: reviews,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While data is loading, show shimmer effect
            return Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Column(
                children: List.filled(7, 0)
                    .map((x) => Container(
                          height: 50,
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              color: Colors.white),
                        ))
                    .toList() as List<Widget>,
              ),
            );
          } else if (snapshot.hasError) {
            // Handle error if any
            return Text('Error: ${snapshot.error}');
          } else {
            // Data has been loaded successfully, display reviews
            Map<String, dynamic> reviewList = snapshot.data!;
            List<dynamic> otherReviews = reviewList['otherReviews'];
            Map<String, dynamic>? userReview = reviewList['userReview'];

            return Column(
              children: [
                Text(
                  'Reviews for ${widget.item['title']}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: otherReviews.length,
                    itemBuilder: (context, index) {
                      return ReviewTile(
                        reviewData: otherReviews[index],
                        showEditButton: false,
                      );
                    },
                  ),
                ),
                if (userReview != null) ...[
                  ReviewTile(
                    reviewData: userReview,
                    showEditButton: true,
                    onReviewUpdated: () {
                      // Reload the reviews when the user's review is updated
                      setState(() {
                        reviews = fetchReviews(widget.item['_id'], userId!);
                      });
                    },
                  ),
                  SizedBox(height: 16),
                ],
                if (userReview == null) ...[
                  ReviewForm(productId: widget.item['_id'], userId: userId!)
                ],
              ],
            );
          }
        },
      ),
    );
  }
}
