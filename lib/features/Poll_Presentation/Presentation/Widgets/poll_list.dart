import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:fire_base/features/Poll_Presentation/Presentation/Widgets/poll_card.dart';

class PollList extends StatelessWidget {
  final Stream<QuerySnapshot> stream;
  final String emptyMessage;

  const PollList({super.key, required this.stream, required this.emptyMessage});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("Something went wrong: ${snapshot.error}"));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data?.docs ?? [];

        if (docs.isEmpty) {
          return Center(child: Text(emptyMessage));
        }

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 80),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            return PollCard(poll: docs[index]);
          },
        );
      },
    );
  }
}