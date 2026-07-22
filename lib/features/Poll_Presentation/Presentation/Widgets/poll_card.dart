import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fire_base/features/Poll_Presentation/Presentation/Widgets/poll_options.dart';
import '../../../../core/App_Colors/Colors.dart';
import '../Pages/delet_poll.dart';
import '../Pages/edit_poll.dart';

class PollCard extends StatelessWidget {
  final DocumentSnapshot poll;

  const PollCard({super.key, required this.poll});

  @override
  Widget build(BuildContext context) {
    final data = (poll.data() as Map<String, dynamic>?) ?? {};

    final title = data['title'] as String? ?? '';
    final options = data['options'] as List<dynamic>? ?? [];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.orange.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditPoll(poll: poll),
                        ),
                      );
                    },
                    icon: Icon(Icons.edit, color: AppColors.orange),
                    tooltip: "Edit Poll",
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.red.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    onPressed: () => _confirmDelete(context),
                    icon: const Icon(Icons.delete, color: AppColors.red),
                    tooltip: "Delete Poll",
                  ),
                ),
              ],
            ),

            const Divider(color: AppColors.grey),
            const SizedBox(height: 10),

            ...options.map((option) {
              final optionData = option != null
                  ? Map<String, dynamic>.from(option as Map)
                  : <String, dynamic>{};

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.grey),
                ),
                child: Row(
                  children: [
                    PollOptionImage(imageUrl: optionData['imageUrl']),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        optionData['Name'] as String? ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: AppColors.black),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Delete Poll"),
          content: const Text(
            "Are you sure you want to delete this poll? This action cannot be undone.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await PollService().deletePoll(poll.id, context);
              },
              child: Text("Delete", style: TextStyle(color: AppColors.red)),
            ),
          ],
        );
      },
    );
  }
}