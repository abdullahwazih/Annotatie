import 'package:annotatiev02/components/sized_box.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TextAnnotationPage extends StatefulWidget {
  final String projectId;
  final String annotatorId;

  const TextAnnotationPage({
    super.key,
    required this.projectId,
    required this.annotatorId,
  });

  @override
  State<TextAnnotationPage> createState() => _TextAnnotationPageState();
}

class _TextAnnotationPageState extends State<TextAnnotationPage> {
  final supabase = Supabase.instance.client;
  bool isLoading = true;
  String? errorMessage;
  List<Map<String, dynamic>> descriptionsWithItems = [];

  late PageController _pageController;
  int currentIndex = 0;

  // Track selected label per page
  Map<int, String> selectedLabels = {};

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    fetchDescriptionsAndItems();
  }

  Future<void> fetchDescriptionsAndItems() async {
    try {
      final response = await supabase.rpc(
        'get_text_descriptions_and_items',
        params: {
          'p_project_id': widget.projectId,
          'p_annotator_id': widget.annotatorId,
        },
      );

      setState(() {
        descriptionsWithItems = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> saveAnnotation({
    required int index,
    required String description,
    required String selectedLabel,
  }) async {
    try {
      setState(() {
        selectedLabels[index] = selectedLabel;
      });

      await supabase.from('annotations').insert({
        'project_id': widget.projectId,
        'description': description,
        'selected_item': selectedLabel,
        'annotator_id': widget.annotatorId,
        'created_at': DateTime.now().toIso8601String(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Saved: "$selectedLabel" for description')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error saving annotation: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    const darkBlue = Color(0xFF0A2342);
    const darkerBlue = Color(0xFF021024);

    return Theme(
      data: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: darkBlue,
        cardColor: darkerBlue,
        appBarTheme: const AppBarTheme(
          backgroundColor: darkerBlue,
          foregroundColor: Colors.white,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              const SizedBox(width: 80),
              const Text('Project Name', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 100),
              Text(
                '${currentIndex + 1} / ${descriptionsWithItems.length}',
                style: const TextStyle(fontSize: 14, color: Colors.yellow),
              ),
            ],
          ),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage != null
            ? Center(
                child: Text(
                  'Error: $errorMessage',
                  style: const TextStyle(color: Colors.white),
                ),
              )
            : PageView.builder(
                controller: _pageController,
                itemCount: descriptionsWithItems.length,
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  final item = descriptionsWithItems[index];
                  final description = item['description'] as String;
                  final List<dynamic> labels = item['items'] ?? [];

                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: Padding(
                      key: ValueKey(index),
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          const Text(
                            "Please read and label:",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            height: 500,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: darkerBlue,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black45,
                                  blurRadius: 12,
                                  offset: Offset(0, 6),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(20),
                            child: Center(
                              child: SingleChildScrollView(
                                child: Text(
                                  description,
                                  style: const TextStyle(
                                    color: Colors.yellow,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          const Divider(
                            color: Colors.white24,
                            thickness: 1,
                            indent: 40,
                            endIndent: 40,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "Select a label:",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 12,
                            runSpacing: 12,
                            children: labels.map<Widget>((label) {
                              final isSelected = selectedLabels[index] == label;

                              return ElevatedButton(
                                onPressed: () => saveAnnotation(
                                  index: index,
                                  description: description,
                                  selectedLabel: label.toString(),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isSelected
                                      ? Colors.green.shade700
                                      : Colors.blue.shade600,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                ),
                                child: Text(
                                  label.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
