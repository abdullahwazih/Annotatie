import 'dart:io';
import 'package:annotatiev02/pages/user/annotator_list.dart';
import 'package:annotatiev02/pages/user/project.dart';
import 'package:flutter/material.dart';

class AddTextProject extends StatefulWidget {
  const AddTextProject({super.key});

  @override
  State<AddTextProject> createState() => _UserHome02State();
}

class _UserHome02State extends State<AddTextProject> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _projectNameController = TextEditingController();
  final TextEditingController _textController = TextEditingController();
  final List<String> _texts = [];

  final TextEditingController _controller = TextEditingController();
  final List<String> _items = [];
  File? selectedFile;
  String? fileName;
  String? selectedAnnotatorId;
  String? selectedAnnotatorName;

  void _addText() {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _texts.add(text);
        _textController.clear();
      });
    }
  }

  void handleAnnotatorSelection(String id, String name) {
    setState(() {
      selectedAnnotatorId = id;
      selectedAnnotatorName = name;
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
    const Color darkBlue = Color(0xFF0D1A2F);
    const Color accentBlue = Color(0xFF1976D2);
    const Color textColor = Colors.white70;

    return Theme(
      data: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: darkBlue,
        primaryColor: accentBlue,
        colorScheme: ColorScheme.dark(
          primary: accentBlue,
          secondary: accentBlue,
          background: darkBlue,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFF162447),
          labelStyle: TextStyle(color: textColor),
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
          suffixIconColor: accentBlue,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: textColor),
          bodyLarge: TextStyle(color: Colors.white),
          titleMedium: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: accentBlue),
        listTileTheme: const ListTileThemeData(
          textColor: Colors.white,
          iconColor: accentBlue,
        ),
      ),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              TextField(
                controller: _projectNameController,
                decoration: const InputDecoration(
                  labelText: 'Enter Project Name',
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _textController,
                decoration: InputDecoration(
                  labelText: 'Enter text',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _addText,
                  ),
                ),
                onSubmitted: (_) => _addText(),
                style: const TextStyle(color: Colors.white),
                maxLines: 6,
              ),
              const SizedBox(height: 10),

              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Enter labels',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _addItem,
                  ),
                ),
                onSubmitted: (_) => _addItem(),
                style: const TextStyle(color: Colors.white),
              ),
              SizedBox(
                height: 150,
                child: _items.isEmpty
                    ? const Center(
                        child: SizedBox(
                          height: 30,
                          child: Text(
                            'No labels yet.',
                            style: TextStyle(color: Colors.white54),
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _items.length,
                        itemBuilder: (context, index) {
                          return ListTile(title: Text(_items[index]));
                        },
                      ),
              ),
              AnnotatorListPage(onAnnotatorSelected: handleAnnotatorSelection),
              SizedBox(
                height: 20,
                child: Center(
                  child: Text(
                    selectedAnnotatorName ?? '',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Project(
                items: _items,
                type: 'Text',
                descriptionList: _texts,
                annotatorId: selectedAnnotatorId,
                projectName: _projectNameController.text.trim(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
