import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fire_base/core/App_Colors/Colors.dart';
import '../../Poll_Presentation/Presentation/Widgets/poll_list.dart';
import '../../Poll_Screen/Presentation/poll.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _currentUserId = FirebaseAuth.instance.currentUser?.uid;
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUserId == null) {
      return Scaffold(
        backgroundColor: AppColors.nescafeLight,
        body: Center(
          child: Text(
            "You must be logged in to view polls.",
            style: TextStyle(color: AppColors.black, fontSize: 16),
          ),
        ),
      );
    }

    final uid = _currentUserId!;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.nescafeLight,
        appBar: AppBar(
          title: const Text("Home"),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.settings, color: AppColors.black),
            ),
          ],
          bottom: TabBar(
            indicatorColor: AppColors.orange,
            labelColor: AppColors.black,
            tabs: const [
              Tab(text: "Posted"),
              Tab(text: "All"),
              Tab(text: "Voted"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Posted
            PollList(
              stream: FirebaseFirestore.instance
                  .collection('polls')
                  .where('userId', isEqualTo: uid)
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              emptyMessage: "You haven't posted any polls yet.",
            ),

            // All polls
            PollList(
              stream: FirebaseFirestore.instance
                  .collection('polls')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              emptyMessage: "No polls available yet.",
            ),

            // Voted
            PollList(
              stream: FirebaseFirestore.instance
                  .collection('polls')
                  .where('voters', arrayContains: uid)
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              emptyMessage: "You haven't voted on any polls yet.",
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => Poll(currentUserId: uid)),
            );
          },
          child: Icon(Icons.add, color: AppColors.black),
        ),
      ),
    );
  }
}