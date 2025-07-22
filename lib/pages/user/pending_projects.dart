import 'package:annotatiev02/pages/user/completed_project_details.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PendingProjects extends StatefulWidget {
  final String userId;

  const PendingProjects({super.key, required this.userId});

  @override
  State<PendingProjects> createState() => _CompletedProjectsState();
}

class _CompletedProjectsState extends State<PendingProjects> {
  final SupabaseClient supabase = Supabase.instance.client;
  late Future<List<Map<String, dynamic>>> futureProjects;

  // Fetch completed projects via Supabase RPC
  Future<List<Map<String, dynamic>>> fetchCompletedProjects() async {
    try {
      final data = await supabase.rpc(
        'get_completed_project_details_by_user',
        params: {'p_user_id': widget.userId},
      );

      if (data is List) {
        final parsedData = List<Map<String, dynamic>>.from(data);
        print('Returned Projects:');
        for (final item in parsedData) {
          print(item); // 👈 print the full map
        }
        return parsedData;
      } else {
        print('Returned something else: $data');
        return [];
      }
    } catch (e) {
      print('RPC Error: $e');
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
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(35, 0, 0, 0),
          child: const Text('Completed Projects'),
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
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ListTile(
                  title: Text(
                    project['description'] ?? 'Unnamed Project',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text('Type: ${project['type'] ?? 'No type'}')],
                  ),
                  onTap: () {},
                ),
              );
            },
          );
        },
      ),
    );
  }
}
