import 'dart:io';
import 'package:annotatiev02/pages/user/annotator_list.dart';
import 'package:annotatiev02/pages/user/image_upload.dart';
import 'package:annotatiev02/pages/user/project.dart';
import 'package:flutter/material.dart';
import 'package:annotatiev02/components/options.dart';

class UserHome02 extends StatefulWidget {
  const UserHome02({super.key});

  @override
  State<UserHome02> createState() => _UserHome02State();
}

class _UserHome02State extends State<UserHome02> {
  String _chosenType = 'Image';
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _controller = TextEditingController();
  final List<String> _items = [];
  File? selectedFile;
  String? fileName;
  String? uploadedFolderPath;
  String? selectedAnnotatorId;

  void handleAnnotatorSelection(String id) {
    setState(() {
      selectedAnnotatorId = id; // ✅ Save the selected ID
    });
    // You can use it here or save it to a variable/state
  }

  void handleUploadComplete(String folderPath) {
    setState(() {
      uploadedFolderPath = folderPath;
    });
  }

  void _addItem() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _items.add(text);
        _controller.clear();
      });
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Options(
              choices: ['Image', 'Audio', 'Text'],
              onSelected: (choice) {
                setState(() {
                  _chosenType = choice;
                });
              },
            ),

            const SizedBox(height: 5),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Enter Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),

            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter labels',
                suffixIcon: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addItem,
                ),
              ),
              onSubmitted: (_) => _addItem(),
            ),

            Container(
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: _items.isEmpty
                  ? Center(
                      child: Container(
                        height: 50,
                        child: Text('No labels yet.'),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        return ListTile(title: Text(_items[index]));
                      },
                    ),
            ),
            ImageUpload(onUploadComplete: handleUploadComplete),

            AnnotatorListPage(onAnnotatorSelected: handleAnnotatorSelection),
            SizedBox(
              height: 15,
              child: Center(
                child: Text(
                  'selectedAnnotatorId: ${selectedAnnotatorId ?? 'None'}',
                ),
              ),
            ),
            Project(
              items: _items,
              type: _chosenType,
              description: _descriptionController.text,
              uploadedFolderPath: uploadedFolderPath,
              annotatorId: selectedAnnotatorId,
            ),
          ],
        ),
      ),
    );
  }
}
