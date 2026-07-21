import 'package:fire_base/core/App_Colors/Colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../Poll_Screen/Persentation/poll.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
final String _currentUserId = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.settings, color: AppColors.black),
            ),
          ],
          bottom: const TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: AppColors.orange,
            labelColor: AppColors.black,
            labelStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
            tabs: [
              Tab(text: "Posted"),
              Tab(text: "All"),
              Tab(text: "Voted"),
            ],
          ),
        ),
        backgroundColor: AppColors.nescafeLight,
        body: TabBarView(
          children: [
            Container(child: Text("Posted")),
            Container(child: Text("All")),
            Container(child: Text("Voted")),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Poll(currentUserId: _currentUserId,)),
            );
          },
          child: Icon(Icons.add, color: AppColors.black),
        ),
      ),
    );
  }
}
