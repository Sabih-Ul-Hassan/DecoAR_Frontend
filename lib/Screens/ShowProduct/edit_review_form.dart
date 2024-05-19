import 'package:decoar/APICalls/reviews.dart';
import 'package:decoar/Screens/ShowProduct/draggable_prodcut_details.dart';
import 'package:flutter/material.dart';

class EditReviewForm extends StatefulWidget {
  final Map<String, dynamic> reviewData;
  final Function onReviewUpdated;

  EditReviewForm({required this.reviewData, required this.onReviewUpdated});

  @override
  _EditReviewFormState createState() => _EditReviewFormState();
}

class _EditReviewFormState extends State<EditReviewForm> {
  int selectedStars = 0;
  TextEditingController reviewController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedStars = widget.reviewData['stars'];
    reviewController.text = widget.reviewData['review'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.89,
      ),
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
            'Edit Your Review',
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
              labelText: 'Edit your review...',
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
              bool updated = await updateReview(widget.reviewData['_id'], {
                'stars': selectedStars,
                'review': reviewController.text,
              });

              if (updated) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Review updated successfully!'),
                  duration: Duration(seconds: 2),
                ));

                widget.onReviewUpdated();

                Navigator.pop(context, true);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Failed to update review!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }
}
