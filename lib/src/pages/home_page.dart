// ignore_for_file: unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedback_app/src/components/post_user.dart';
import 'package:feedback_app/src/components/text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // rating value
  double ratingValue = 3;
  double ratingValueStar = 0;

  // user
  final currentUser = FirebaseAuth.instance.currentUser!;

  // text controller
  final textController = TextEditingController();

  // sign user out
  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  // post message
  void postMessage() {
    // only post if there is something in the textfield
    if (textController.text.isNotEmpty) {
      // store in firebase
      FirebaseFirestore.instance.collection('User Posts').add({
        'UserEmail': currentUser.email,
        'Message': textController.text,
        'TimeStamp': Timestamp.now(),
        'Rating': ratingValue,
      });
    }

    // clear the textfield
    setState(() {
      textController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: const Text('Feedback APP'),
          backgroundColor: Colors.grey[900],
          actions: [
            // sign out button
            IconButton(onPressed: signOut, icon: const Icon(Icons.logout)),
          ],
        ),
        body: Center(
          child: Column(
            children: [
              // feedback app
              Expanded(
                  child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("User Posts")
                    .orderBy("TimeStamp", descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        // get the message
                        final post = snapshot.data!.docs[index];
                        return PostUser(
                          message: post['Message'],
                          user: post['UserEmail'],
                          rating: post['Rating'] ?? 0,
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error:${snapshot.error}'),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              )),
              // rating bar
              const SizedBox(
                height: 30,
              ),
              const Text(
                'Please rate the application.',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 24,
                ),
              ),
              RatingBar.builder(
                  initialRating: ratingValue,
                  minRating: 1,
                  itemBuilder: (context, _) =>
                      const Icon(Icons.star, color: Colors.amber),
                  onRatingUpdate: (ratingValueStar) async {
                    setState(() {
                      ratingValue = ratingValueStar;
                    });
                  }),

              // post message
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Row(
                  children: [
                    // text field
                    Expanded(
                        child: MyTextField(
                      controller: textController,
                      hintText: "Write something about the app...",
                      obscureText: false,
                    )),

                    // post button
                    IconButton(
                        onPressed: postMessage,
                        icon: const Icon(Icons.arrow_circle_up_rounded))
                  ],
                ),
              ),
              // logged in as
              Text(
                "Logged in as: " + currentUser.email!,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.bold,
                  // fontSize: 24,
                ),
              ),

              const SizedBox(
                height: 50,
              )
            ],
          ),
        ));
  }
}
