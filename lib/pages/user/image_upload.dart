import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ImageUpload extends StatefulWidget {
  final void Function(String folderPath) onUploadComplete;

  const ImageUpload({super.key, required this.onUploadComplete});

  @override
  State<ImageUpload> createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  List<File> selectedFiles = [];
  final folderController = TextEditingController();
  String? savedFolderName;

  Future<void> pickImages() async {
    if (savedFolderName == null || savedFolderName!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please set folder name first')),
      );
      return;
    }

    final ImagePicker picker = ImagePicker();
    final List<XFile>? images = await picker.pickMultiImage();

    if (images != null && images.isNotEmpty) {
      setState(() {
        selectedFiles = images.map((image) => File(image.path)).toList();
      });
    }
  }

  Future<String?> uploadImages() async {
    if (savedFolderName == null || savedFolderName!.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Folder name is not set')));
      return null;
    }

    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null || selectedFiles.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Missing user or images.')));
      return null;
    }

    final folderPath = '$userId/$savedFolderName';

    for (int i = 0; i < selectedFiles.length; i++) {
      final file = selectedFiles[i];
      final fileName =
          DateTime.now().millisecondsSinceEpoch.toString() + '_$i.jpg';
      final fullPath = '$folderPath/$fileName';

      try {
        await Supabase.instance.client.storage
            .from('images')
            .upload(fullPath, file);

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Uploaded: $fullPath')));
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to upload: $fullPath')));
      }
    }

    setState(() {
      selectedFiles.clear();
    });

    return folderPath;
  }

  @override
  void dispose() {
    folderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: folderController,
            decoration: InputDecoration(
              labelText: 'Enter Project Name',
              suffixIcon: IconButton(
                icon: const Icon(Icons.check, color: Colors.green),
                onPressed: () {
                  final enteredName = folderController.text.trim();
                  if (enteredName.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Folder name cannot be empty'),
                      ),
                    );
                    return;
                  }
                  setState(() {
                    savedFolderName = enteredName;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Folder name set to: $savedFolderName'),
                    ),
                  );
                },
              ),
            ),
          ),

          selectedFiles.isEmpty
              ? const Text('')
              : Text('Images selected: ${selectedFiles.length}'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: pickImages,
                child: const Text('Images'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () async {
                  final folderPath = await uploadImages();
                  if (folderPath != null) {
                    widget.onUploadComplete(folderPath);
                  }
                },
                child: const Text('Upload'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              final folderPath = await uploadImages();
              if (folderPath != null) {
                widget.onUploadComplete(folderPath);
              }
            },
            child: const Text('Upload'),
          ),
        ],
      ),
    );
  }
}
