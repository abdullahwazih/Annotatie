import 'package:annotatiev02/pages/annotator/image.dart';
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
          .select('id, description, type, uploaded_folder_path')
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
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Annotator Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const SizedBox(height: 20),
            Text(
              'Welcome, $annotatorName',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text('annotator ID: $annotatorId'),
            if (role == 'admin') ...[
              const Text(
                'Projects assigned to you:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: isProjectsLoading
                    ? const Center(child: CircularProgressIndicator())
                    : projects.isEmpty
                    ? const Center(child: Text('No projects found.'))
                    : ListView.builder(
                        itemCount: projects.length,
                        itemBuilder: (context, index) {
                          final project = projects[index];
                          final folderPath =
                              project['uploaded_folder_path'] ??
                              'No Folder Path';

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            child: ListTile(
                              title: Text(
                                project['description'] ?? 'No Description',
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Type: ${project['type'] ?? 'N/A'}'),
                                  const SizedBox(height: 4),
                                  Text('Folder Path: $folderPath'),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        ImageGallery(folderPath: folderPath),
                                  ),
                                );
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
    );
  }
}
