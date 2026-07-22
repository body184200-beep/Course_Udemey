// lib/services/poll_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class PollService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> deletePoll(
      String pollId,
      BuildContext context,
      ) async {
    try {
      final pollDoc = await _firestore.collection('polls').doc(pollId).get();

      if (!pollDoc.exists) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Poll not found")),
        );
        return;
      }

      final data = pollDoc.data();
      final options = data?['options'] as List<dynamic>? ?? [];

      // نحذف كل صور الـ options من Storage قبل حذف الـ document
      await Future.wait(options.map((option) async {
        final optionData = option != null
            ? Map<String, dynamic>.from(option as Map)
            : <String, dynamic>{};

        final imageUrl = optionData['imageUrl'] as String?;

        if (imageUrl != null && imageUrl.isNotEmpty) {
          try {
            await _storage.refFromURL(imageUrl).delete();
          } catch (e) {
            // نتجاهل الخطأ لو الصورة مش موجودة أصلاً في Storage
            debugPrint("Failed to delete image ($imageUrl): $e");
          }
        }
      }));

      await _firestore.collection('polls').doc(pollId).delete();

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Poll deleted successfully")),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Delete failed: $e")),
      );
    }
  }
}