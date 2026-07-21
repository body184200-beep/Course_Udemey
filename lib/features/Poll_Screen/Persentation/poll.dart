import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/App_Colors/Colors.dart';
import '../../../core/Custom_TextFormField/TextFormField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Poll extends StatefulWidget {
  final String currentUserId;

  const Poll({super.key, required this.currentUserId});

  @override
  State<Poll> createState() => _PollState();
}

class _PollState extends State<Poll> {
  final TextEditingController titleController = TextEditingController();

  final List<TextEditingController> optionsController = List.generate(
    3,
        (index) => TextEditingController(),
  );
  final List<File?> options = [null, null, null];
  late final ImagePicker _imagePicker = ImagePicker();

  bool _isSubmitting = false;

  @override
  void dispose() {
    titleController.dispose();
    for (final controller in optionsController) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.nescafeLight,
      appBar: AppBar(
        backgroundColor: AppColors.coffee,
        centerTitle: true,
        title: Text(
          "Poll",
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 16,
            color: AppColors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomTextFormField(
                controller: titleController,
                title: 'Poll',
                hint: 'Poll Title',
              ),

              const SizedBox(height: 20),

              for (int i = 0; i < optionsController.length; i++) ...[
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: CustomTextFormField(
                          controller: optionsController[i],
                          title: 'Option ${i + 1}',
                          hint: 'Enter option ${i + 1}',
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: GestureDetector(
                          onTap: _isSubmitting ? null : () => pickImage(i),
                          child: options[i] != null
                              ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              options[i]!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) {
                                return const Icon(Icons.broken_image);
                              },
                            ),
                          )
                              : Container(
                            decoration: BoxDecoration(
                              color: AppColors.coffee,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.add_photo_alternate,
                              color: AppColors.red,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ),
              ],
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: _isSubmitting
                    ? null
                    : () => submitPoll(widget.currentUserId, context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.blue,
                  ),
                )
                    : Text(
                  "Create Poll",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.blue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> pickImage(int i) async {
    final XFile? pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        options[i] = File(pickedFile.path);
      });
    }
  }

  Future<void> submitPoll(String userId, BuildContext context) async {
    if (!validateForm(context)) return;

    setState(() => _isSubmitting = true);

    try {
      final pollDocRef = FirebaseFirestore.instance.collection('polls').doc();
      final pollId = pollDocRef.id;
      final List<Map<String, dynamic>> pollOptionsData = [];

      for (int i = 0; i < optionsController.length; i++) {
        final imageUrl = await uploadImage(options[i]!, pollId, i);
        if (imageUrl == null) {
          throw Exception("Error uploading image for option ${i + 1}");
        }
        pollOptionsData.add({
          "Name": optionsController[i].text.trim(),
          "imageUrl": imageUrl,
          "Vote": 0,
        });
      }

      await pollDocRef.set({
        "userId": userId,
        "pollId": pollId,
        "title": titleController.text.trim(),
        "options": pollOptionsData,
        "createdAt": FieldValue.serverTimestamp(),
        "voted": 0,
      });

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Poll created successfully")),
      );
      Navigator.of(context).pop();
    } catch (e) {
      log("Error submitting poll: $e");
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to create poll: $e")),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  bool validateForm(BuildContext context) {
    if (titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter a title")));
      return false;
    }
    if (optionsController.any((controller) => controller.text.trim().isEmpty)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter all options")));
      return false;
    }
    if (options.any((option) => option == null)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select all images")));
      return false;
    }
    return true;
  }

  Future<String?> uploadImage(File imageFile, String pollId, int index) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child(
        'polls/$pollId/$index$pollId.jpg',
      );
      final uploadTask = await storageRef.putFile(imageFile);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      log("Error uploading image: $e");
      return null;
    }
  }
}