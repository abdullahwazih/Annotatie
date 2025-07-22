import 'package:annotatiev02/pages/annotator/image.dart';
import 'package:annotatiev02/pages/annotator/text_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AnnotatorHome extends StatefulWidget {
  const AnnotatorHome({super.key});

  @override
  State<AnnotatorHome> createState() => _AnnotatorHomeState();
}

class _AnnotatorHomeState extends State<AnnotatorHome> {
  String annotatorName = '';
  String annotatorId = '';
  String role = '';
  bool isLoading = true;

  List<dynamic> projects = [];
  bool isProjectsLoading = false;

  @override
  void initState() {
    super.initState();
    fetchAnnotatorInfo();
  }

  Future<void> fetchAnnotatorInfo() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      setState(() {
        annotatorName = 'No user logged in';
        isLoading = false;
      });
      return;
    }

    annotatorId = user.uid;

    try {
      final docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(annotatorId);
      final snapshot = await docRef.get();

      if (snapshot.exists) {
        final data = snapshot.data();
        if (data != null && data['role'] == 'admin') {
          annotatorName = data['username'] ?? 'No Name Found';
          role = data['role'];
          await fetchProjects();
        } else {
          annotatorName = 'Access denied: not an admin';
        }
      } else {
        await docRef.set({
          'uid': annotatorId,
          'username': 'Annotator Name',
          'role': 'admin',
        });
        annotatorName = 'Annotator Name';
        role = 'admin';
        await fetchProjects();
      }
    } catch (e) {
      annotatorName = 'Error fetching data';
      print('Error fetching annotator info: $e');
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> fetchProjects() async {
    setState(() {
      isProjectsLoading = true;
    });

    try {
      final supabase = Supabase.instance.client;

      final response = await supabase
          .from('projects')
          .select(
            'id,  project_name, description, type, items, uploaded_folder_path',
          )
          .eq('annotator_id', annotatorId);

      setState(() {
        projects = response;
      });
    } catch (e) {
      print('Error fetching projects from Supabase: $e');
      setState(() {
        projects = [];
      });
    }

    setState(() {
      isProjectsLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color darkBlue = const Color(0xFF0D1B2A);
    final Color cardBlue = const Color(0xFF1B263B);
    final Color accentBlue = const Color(0xFF415A77);
    final Color textColor = Colors.white;

    if (isLoading) {
      return Scaffold(
        backgroundColor: darkBlue,
        body: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    return Theme(
      data: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: darkBlue,
        cardColor: cardBlue,
        primaryColor: accentBlue,
        colorScheme: ColorScheme.dark(
          primary: accentBlue,
          secondary: accentBlue,
          background: darkBlue,
          surface: cardBlue,
        ),
        textTheme: ThemeData.dark().textTheme.apply(
          bodyColor: textColor,
          displayColor: textColor,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      child: Scaffold(
        backgroundColor: darkBlue,
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 50, 10, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Welcome, $annotatorName',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        // ignore: use_build_context_synchronously
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      icon: const Icon(Icons.logout, color: Colors.white),
                    ),
                  ],
                ),
              ),
              if (role == 'admin') ...[
                const Text(
                  'Projects assigned',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: isProjectsLoading
                      ? const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        )
                      : projects.isEmpty
                      ? const Center(
                          child: Text(
                            'No projects found.',
                            style: TextStyle(color: Colors.white70),
                          ),
                        )
                      : ListView.builder(
                          itemCount: projects.length,
                          itemBuilder: (context, index) {
                            final project = projects[index];
                            final folderPath =
                                project['uploaded_folder_path'] ??
                                'No Folder Path';

                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              color: cardBlue,
                              child: ListTile(
                                title: Text(
                                  project['project_name'] ??
                                      'Name of the Project',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Type: ${project['type'] ?? 'N/A'}',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                  ],
                                ),
                                onTap: () {
                                  final List<String> itemsList =
                                      List<String>.from(project['items'] ?? []);
                                  final String projectId = project['id'];
                                  final String type =
                                      project['type'] ?? 'Unknown';
                                  final String folderPath =
                                      project['uploaded_folder_path'] ?? '';

                                  if (type.toLowerCase() == 'text') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => TextAnnotationPage(
                                          projectId: projectId,
                                          annotatorId: annotatorId,
                                        ),
                                      ),
                                    );
                                  } else if (type.toLowerCase() == 'image') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ImageGallery(
                                          folderPath: folderPath,
                                          items: itemsList,
                                          projectId: projectId,
                                        ),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Unsupported project type',
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            );
                          },
                        ),
                ),
              ] else ...[
                const Center(
                  child: Text(
                    'You do not have permission to view projects.',
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
