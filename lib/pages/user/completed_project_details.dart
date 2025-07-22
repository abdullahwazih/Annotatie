import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProjectShowCase extends StatefulWidget {
  final String projectId;
  final String projectName;

  const ProjectShowCase({
    super.key,
    required this.projectId,
    required this.projectName,
  });

  @override
  State<ProjectShowCase> createState() => _ProjectShowCaseState();
}

class _ProjectShowCaseState extends State<ProjectShowCase> {
  final SupabaseClient supabase = Supabase.instance.client;
  late Future<List<Map<String, dynamic>>> annotationsFuture;
  final PageController _pageController = PageController();
  int _currentPage = 0;

  Future<List<Map<String, dynamic>>> fetchAnnotations() async {
    try {
      final data = await supabase.rpc(
        'get_annotations_by_project_id',
        params: {'p_project_id': widget.projectId},
      );

      if (data is List) {
        return List<Map<String, dynamic>>.from(data);
      } else {
        return [];
      }
    } catch (e) {
      print('Error fetching annotations: $e');
      throw Exception('Error fetching annotations: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    annotationsFuture = fetchAnnotations();
  }

  @override
  Widget build(BuildContext context) {
    const darkBlue = Color(0xFF0D1A2F);
    const darkerBlue = Color(0xFF091224);

    return Theme(
      data: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: darkBlue,
        appBarTheme: const AppBarTheme(
          backgroundColor: darkerBlue,
          foregroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        colorScheme: ColorScheme.dark(
          primary: Colors.blueAccent,
          background: darkBlue,
          surface: darkerBlue,
        ),
        textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white)),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.fromLTRB(65, 0, 0, 0),
            child: Text(widget.projectName),
          ),
        ),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: annotationsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No annotations found.'));
            }

            final annotations = snapshot.data!;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(36, 12, 0, 0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${_currentPage + 1} / ${annotations.length}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: annotations.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      final item = annotations[index];
                      final imageUrl = item['image_url'] ?? '';
                      final label = item['selected_item'] ?? 'No item selected';

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white12,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.contain,
                                  width: double.infinity,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Center(
                                        child: Icon(
                                          Icons.broken_image,
                                          size: 100,
                                          color: Colors.white54,
                                        ),
                                      ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            "Selected Label",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1,
                            ),
                          ),
                          const Divider(
                            color: Colors.white24,
                            thickness: 1,
                            indent: 80,
                            endIndent: 80,
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade600,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              label,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
