import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/App_Colors/Colors.dart';
import '../../../core/Custom_TextFormField/TextFormField.dart';

class Poll extends StatefulWidget {
  const Poll({super.key});

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
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomTextFormField(
                          controller: optionsController[i],
                          title: 'Option ${i + 1}',
                          hint: 'Enter option ${i + 1}',
                        ),
                      ),

                      const SizedBox(width: 12),

                      GestureDetector(
                        onTap: () => pickImage(i),
                        child: options[i] != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  options[i]!,
                                  height: 60,
                                  width: 60,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Container(
                                height: 60,
                                width: 60,
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
                    ],
                  ),
                ),
              ],
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
}
