import 'dart:io';
import 'package:annotatiev02/pages/user/annotator_list.dart';
import 'package:annotatiev02/pages/user/image_upload.dart';
import 'package:annotatiev02/pages/user/project.dart';
import 'package:flutter/material.dart';

class AddImageProject extends StatefulWidget {
  const AddImageProject({super.key});

  @override
  State<AddImageProject> createState() => _UserHome02State();
}

class _UserHome02State extends State<AddImageProject> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _controller = TextEditingController();
  final List<String> _items = [];
  File? selectedFile;
  String? fileName;
  String? uploadedFolderPath;
  String? selectedAnnotatorId;
  String? selectedAnnotatorName;
  String? projectName;

  void handleAnnotatorSelection(String id, String name) {
    setState(() {
      selectedAnnotatorId = id;
      selectedAnnotatorName = name;
    });
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
    final Color darkBlue = const Color(0xFF0D1A2F);
    final Color darkerBlue = const Color(0xFF091322);
    final Color accentBlue = const Color(0xFF1976D2);

    return Theme(
      data: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: darkBlue,
        primaryColor: accentBlue,
        colorScheme: ColorScheme.dark(
          primary: accentBlue,
          secondary: accentBlue,
          background: darkBlue,
          surface: darkerBlue,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: darkerBlue,
          labelStyle: TextStyle(color: Colors.white70),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: accentBlue),
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: accentBlue),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: accentBlue, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
          bodyLarge: TextStyle(color: Colors.white),
          bodySmall: TextStyle(color: Colors.white70),
        ),
        iconTheme: IconThemeData(color: accentBlue),
        listTileTheme: ListTileThemeData(
          tileColor: darkerBlue,
          textColor: Colors.white,
        ),
      ),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                ImageUpload(onUploadComplete: handleUploadComplete),
                const SizedBox(height: 20),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Enter Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 20),
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
                SizedBox(
                  height: 150,
                  child: _items.isEmpty
                      ? Center(
                          child: SizedBox(
                            height: 30,
                            child: Text('No labels yet.'),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _items.length,
                          itemBuilder: (context, index) {
                            return ListTile(title: Text(_items[index]));
                          },
                        ),
                ),
                Text(
                  uploadedFolderPath ?? 'No folder uploaded',
                  style: TextStyle(color: Colors.white70),
                ),
                AnnotatorListPage(
                  onAnnotatorSelected: handleAnnotatorSelection,
                ),
                SizedBox(
                  height: 20,
                  child: Center(
                    child: Text(
                      selectedAnnotatorName ?? '',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Project(
                  items: _items,
                  type: 'image',
                  projectName: _descriptionController.text.trim(),
                  uploadedFolderPath: uploadedFolderPath,
                  annotatorId: selectedAnnotatorId,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
