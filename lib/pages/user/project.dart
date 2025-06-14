import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Project extends StatelessWidget {
  final List<String> items;
  final String? type;
  final String? description;
  final String? uploadedFolderPath;
  final String? annotatorId; // <- New field added

  const Project({
    super.key,
    required this.items,
    this.type,
    this.description,
    this.uploadedFolderPath,
    this.annotatorId,
  });

  Future<void> uploadDataToSupabaseDatabase(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("User not logged in")));
      return;
    }

    final uid = user.uid;
    final supabase = Supabase.instance.client;

    try {
      await supabase.from('projects').insert({
        'user_id': uid,
        'annotator_id': annotatorId, // Matches the new column
        'type': type,
        'description': description,
        'items': items, // List<String> is valid for jsonb
        'uploaded_folder_path': uploadedFolderPath,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Project uploaded successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ Upload failed: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => uploadDataToSupabaseDatabase(context),
      child: const Text("Done"),
    );
  }
}
