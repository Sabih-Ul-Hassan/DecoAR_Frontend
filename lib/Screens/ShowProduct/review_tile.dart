import 'package:decoar/Screens/ShowProduct/edit_review_form.dart';
import 'package:flutter/material.dart';

class ReviewTile extends StatelessWidget {
  final Map<String, dynamic> reviewData;
  final bool showEditButton; // Added parameter
  Function? onReviewUpdated;
  ReviewTile({
    required this.reviewData,
    required this.showEditButton,
    this.onReviewUpdated,
  });

  @override
  Widget build(BuildContext context) {
    String username = reviewData['username'];
    int stars = reviewData['stars'];
    String review = reviewData['review'];
    DateTime createdAt = DateTime.parse(reviewData['createdAt']);

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                username,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    Icons.star,
                    color: index < stars ? Colors.yellow : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(review),
          if (!showEditButton) ...[SizedBox(height: 8)],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Created at: ${createdAt.toLocal()}',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              if (showEditButton) ...[
                ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return EditReviewForm(
                          reviewData: reviewData,
                          onReviewUpdated: onReviewUpdated!,
                        );
                      },
                    );
                  },
                  child: Text('Edit'),
                )
              ],
            ],
          ),
        ],
      ),
    );
  }
}
