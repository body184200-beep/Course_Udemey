import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditPoll extends StatefulWidget {
  final DocumentSnapshot poll;

  const EditPoll({super.key, required this.poll});

  @override
  State<EditPoll> createState() => _EditPollState();
}

class _EditPollState extends State<EditPoll> {
  late TextEditingController titleController;
  List<TextEditingController> optionControllers = [];

  // Keep the original options data (imageUrl, Vote, etc.) so we don't
  // wipe it out when we only edit the title/options text.
  List<Map<String, dynamic>> _originalOptions = [];

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();

    final rawData = widget.poll.data();
    final data = rawData != null
        ? Map<String, dynamic>.from(rawData as Map)
        : <String, dynamic>{};

    titleController = TextEditingController(
      text: data['title'] as String? ?? '',
    );

    final options = data['options'] as List<dynamic>? ?? [];

    for (var option in options) {
      final optionMap = option != null
          ? Map<String, dynamic>.from(option as Map)
          : <String, dynamic>{};
      _originalOptions.add(optionMap);
      optionControllers.add(
        TextEditingController(text: optionMap['Name'] as String? ?? ''),
      );
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    for (final controller in optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Poll")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(hintText: "Poll title"),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: optionControllers.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: TextField(
                      controller: optionControllers[index],
                      decoration: InputDecoration(
                        hintText: "Option ${index + 1}",
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _isSubmitting ? null : _saveChanges,
              child: _isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveChanges() async {
    if (_isSubmitting) return;
    if (!_validateForm()) return;

    setState(() => _isSubmitting = true);

    try {
      // Merge the edited text back with the original option data so
      // imageUrl / Vote (or any other field) isn't lost.
      final updatedOptions = List.generate(optionControllers.length, (i) {
        final original = i < _originalOptions.length
            ? Map<String, dynamic>.from(_originalOptions[i])
            : <String, dynamic>{};
        original['Name'] = optionControllers[i].text.trim();
        return original;
      });

      await FirebaseFirestore.instance
          .collection('polls')
          .doc(widget.poll.id)
          .update({
            'title': titleController.text.trim(),
            'options': updatedOptions,
            'updatedAt': FieldValue.serverTimestamp(),
          });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Poll updated successfully")),
      );
      Navigator.of(context).pop();
    } catch (e) {
      log("Error updating poll: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to update poll: $e")));
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  bool _validateForm() {
    if (titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter a title")));
      return false;
    }
    if (optionControllers.any((c) => c.text.trim().isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all options")),
      );
      return false;
    }
    return true;
  }
}
