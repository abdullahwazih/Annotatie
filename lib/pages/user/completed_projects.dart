import 'package:annotatiev02/pages/user/completed_project_details.dart';
import 'package:annotatiev02/pages/user/text_project_details.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CompletedProjects extends StatefulWidget {
  final String userId;

  const CompletedProjects({super.key, required this.userId});

  @override
  State<CompletedProjects> createState() => _CompletedProjectsState();
}

class _CompletedProjectsState extends State<CompletedProjects> {
  final SupabaseClient supabase = Supabase.instance.client;
  late Future<List<Map<String, dynamic>>> futureProjects;

  Future<List<Map<String, dynamic>>> fetchCompletedProjects() async {
    try {
      final data = await supabase.rpc(
        'get_completed_project_details_by_user',
        params: {'p_user_id': widget.userId},
      );
      print('Fetched data: $data'); // Add this line

      if (data is List) {
        final parsedData = List<Map<String, dynamic>>.from(data);
        return parsedData;
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Error fetching completed projects: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    futureProjects = fetchCompletedProjects();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF162447),
        cardColor: const Color(0xFF1B263B),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1F4068),
          foregroundColor: Colors.white,
        ),
        colorScheme: ColorScheme.dark(
          primary: Color(0xFF1F4068),
          secondary: Color(0xFF1B6CA8),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Padding(
            padding: EdgeInsets.fromLTRB(35, 0, 0, 0),
            child: Text('Completed Projects'),
          ),
        ),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: futureProjects,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No completed projects found.'));
            }

            final projects = snapshot.data!;
            return ListView.builder(
              itemCount: projects.length,
              itemBuilder: (context, index) {
                final project = projects[index];
                final projectId = project['id'] ?? '';
                final description =
                    project['project_name'] ?? 'Name of the project';
                final type = project['type'] ?? '';

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: ListTile(
                    title: Text(
                      description,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      'Type: $type',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    onTap: () {
                      if (type.toLowerCase() == 'text') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                TextProjectShowCase(projectId: projectId),
                          ),
                        );
                      } else if (type.toLowerCase() == 'image') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProjectShowCase(
                              projectId: projectId,
                              projectName: description,
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Unsupported project type.'),
                          ),
                        );
                      }
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
