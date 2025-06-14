import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ImageGallery extends StatefulWidget {
  final String folderPath;

  const ImageGallery({super.key, required this.folderPath});

  @override
  State<ImageGallery> createState() => _ImageGalleryState();
}

class _ImageGalleryState extends State<ImageGallery> {
  final SupabaseClient supabase = Supabase.instance.client;
  late Future<List<String>> imageUrlsFuture;

  @override
  void initState() {
    super.initState();
    imageUrlsFuture = getImageUrls(widget.folderPath);
  }

  Future<List<String>> getImageUrls(String folderPath) async {
    final bucketName = 'images'; // <- replace with your actual bucket name

    final files = await supabase.storage
        .from(bucketName)
        .list(path: folderPath);

    List<String> urls = [];

    for (final file in files) {
      final url = supabase.storage
          .from(bucketName)
          .getPublicUrl('$folderPath/${file.name}');
      urls.add(url);
    }

    return urls;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Image Gallery")),
      body: FutureBuilder<List<String>>(
        future: imageUrlsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError ||
              !snapshot.hasData ||
              snapshot.data!.isEmpty) {
            return const Center(child: Text("No images found."));
          }

          final urls = snapshot.data!;

          return ListView.builder(
            itemCount: urls.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(urls[index], fit: BoxFit.cover),
              );
            },
          );
        },
      ),
    );
  }
}
