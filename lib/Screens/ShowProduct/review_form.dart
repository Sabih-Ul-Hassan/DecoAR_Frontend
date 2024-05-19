import 'package:decoar/APICalls/reviews.dart';
import 'package:decoar/Screens/ShowProduct/draggable_prodcut_details.dart';
import 'package:flutter/material.dart';

class ReviewForm extends StatefulWidget {
  String productId;
  String userId;
  ReviewForm({required this.productId, required this.userId});

  @override
  _ReviewFormState createState() => _ReviewFormState();
}

class _ReviewFormState extends State<ReviewForm> {
  int selectedStars = 0;
  TextEditingController reviewController = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
          const Text(
            'Submit a Review',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Your Rating:'),
              Row(
                children: List.generate(
                  5,
                  (index) => GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedStars = index + 1;
                      });
                    },
                    child: Icon(
                      Icons.star,
                      color:
                          index < selectedStars ? Colors.yellow : Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Write your review...',
              border: OutlineInputBorder(),
            ),
            maxLines: null,
            controller: reviewController,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              if (selectedStars == 0 || reviewController.text.isEmpty) {
                return;
              }

              bool uploaded = await uploadReview({
                'productId': widget.productId,
                'userId': widget.userId,
                'stars': selectedStars,
                'review': reviewController.text,
              });
              if (uploaded) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Review uploaded successfully!'),
                  duration: Duration(seconds: 2),
                ));
                setState(() {
                  Navigator.pop(context, true);
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Failed to upload review!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}
