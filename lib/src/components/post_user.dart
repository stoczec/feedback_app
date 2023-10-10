// ignore: unused_import
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class PostUser extends StatelessWidget {
  final String message;
  final String user;
  final double rating;
  const PostUser({
    super.key,
    required this.message,
    required this.user,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: const EdgeInsets.all(25),
      child: Row(
        children: [
          const SizedBox(
            width: 20,
          ),
          // message and user email
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RatingBar.builder(
                initialRating: rating,
                minRating: 1,
                itemSize: 25.0,
                itemBuilder: (context, _) =>
                    const Icon(Icons.star, color: Colors.amber),
                onRatingUpdate: (ratingValueStar) {},
                ignoreGestures: true,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                user,
                style: TextStyle(color: Colors.grey[500]),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(message),
            ],
          )
        ],
      ),
    );
  }
}
