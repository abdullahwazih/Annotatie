import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProjectDetailPage extends StatefulWidget {
  final String folderPath;

  const ProjectDetailPage({super.key, required this.folderPath});

  @override
  State<ProjectDetailPage> createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends State<ProjectDetailPage> {
  List<FileObject> imageFiles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchImagesFromFolder();
  }

  Future<void> fetchImagesFromFolder() async {
    try {
      final supabase = Supabase.instance.client;

      final response = await supabase.storage
          .from('your-bucket-name') // 🔁 Replace with your bucket name
          .list(path: widget.folderPath);

      setState(() {
        imageFiles = response;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching images: $e');
      setState(() {
        imageFiles = [];
        isLoading = false;
      });
    }
  }

  String getPublicUrl(String path) {
    final supabase = Supabase.instance.client;
    return supabase.storage.from('your-bucket-name').getPublicUrl(path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Project Images')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : imageFiles.isEmpty
            ? const Center(child: Text('No images found.'))
            : ListView.builder(
                itemCount: imageFiles.length,
                itemBuilder: (context, index) {
                  final file = imageFiles[index];
                  final imageUrl = getPublicUrl(
                    '${widget.folderPath}/${file.name}',
                  );
                  return Card(
                    child: ListTile(
                      leading: Image.network(imageUrl),
                      title: Text(file.name),
                      subtitle: const Text('Label and description here'),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
