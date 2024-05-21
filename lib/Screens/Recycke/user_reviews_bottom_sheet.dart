import 'package:decoar/APICalls/reviews.dart';
import 'package:decoar/Providers/User.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class UserReviewsBottomSheet extends StatefulWidget {
  final String userId;

  UserReviewsBottomSheet({required this.userId});

  @override
  _UserReviewsBottomSheetState createState() => _UserReviewsBottomSheetState();
}

class _UserReviewsBottomSheetState extends State<UserReviewsBottomSheet> {
  late Future<Map<String, dynamic>> reviews;

  ScrollController reviewScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    reviews = fetchUserReviews(widget.userId,
        Provider.of<UserProvider>(context, listen: false).user!.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: FutureBuilder<Map<String, dynamic>>(
        future: reviews,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
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
            return Text('Error: ${snapshot.error}');
          } else {
            Map<String, dynamic> reviewList = snapshot.data!;
            List<dynamic> userReviews = reviewList['otherReviews'] ?? [];
            Map<String, dynamic>? userReview = reviewList['userReview'] ?? null;

            return Column(
              children: [
                Text(
                  'Your Reviews',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: userReviews.length,
                    itemBuilder: (context, index) {
                      return UserReviewTile(
                        reviewData: userReviews[index],
                        showEditButton: true,
                        onReviewUpdated: () {
                          setState(() {
                            reviews = fetchUserReviews(
                                widget.userId,
                                Provider.of<UserProvider>(context,
                                        listen: false)
                                    .user!
                                    .userId);
                          });
                        },
                      );
                    },
                  ),
                ),
                if (userReview != null) ...[
                  UserReviewTile(
                    reviewData: userReview,
                    showEditButton: true,
                    onReviewUpdated: () {
                      setState(() {
                        reviews = fetchReviews(
                            widget.userId,
                            Provider.of<UserProvider>(context, listen: false)
                                .user!
                                .userId);
                      });
                    },
                  ),
                  SizedBox(height: 16),
                ],
                if (userReview == null) ...[
                  UserReviewForm(userId: widget.userId)
                ],
              ],
            );
          }
        },
      ),
    );
  }
}

class UserReviewTile extends StatelessWidget {
  late final Map<String, dynamic> reviewData;
  late final bool showEditButton;
  Function? onReviewUpdated;

  UserReviewTile({
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
          SizedBox(height: 8),
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
                        return UserEditReviewForm(
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

class UserReviewForm extends StatefulWidget {
  final String userId;

  UserReviewForm({required this.userId});

  @override
  _UserReviewFormState createState() => _UserReviewFormState();
}

class _UserReviewFormState extends State<UserReviewForm> {
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

              bool uploaded = await uploadUsersReview({
                "ReviewedUsersId": widget.userId,
                'userId': Provider.of<UserProvider>(context, listen: false)
                    .user!
                    .userId,
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

class UserEditReviewForm extends StatefulWidget {
  final Map<String, dynamic> reviewData;
  final Function onReviewUpdated;

  UserEditReviewForm({required this.reviewData, required this.onReviewUpdated});

  @override
  _UserEditReviewFormState createState() => _UserEditReviewFormState();
}

class _UserEditReviewFormState extends State<UserEditReviewForm> {
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
              bool updated = await updateUserReview(widget.reviewData['_id'], {
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
