import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ImageGallery extends StatefulWidget {
  final String folderPath;
  final List<String> items;
  final String projectId;
  

  ImageGallery({
    super.key,
    required this.folderPath,
    required this.items,
    required this.projectId, // New field
  });

  @override
  State<ImageGallery> createState() => _ImageGalleryState();
}

class _ImageGalleryState extends State<ImageGallery> {
  final SupabaseClient supabase = Supabase.instance.client;
  late Future<List<String>> imageUrlsFuture;
  int currentIndex = 0; // 👈 new

  @override
  void initState() {
    super.initState();
    imageUrlsFuture = getImageUrls(widget.folderPath);
  }

  Future<List<String>> getImageUrls(String folderPath) async {
    const bucketName = 'images';

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
          final PageController pageController = PageController();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Image ${currentIndex + 1} / ${urls.length}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              Expanded(
                child: PageView.builder(
                  controller: pageController,
                  itemCount: urls.length,
                  onPageChanged: (index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return InteractiveViewer(
                      child: Center(
                        child: Image.network(urls[index], fit: BoxFit.contain),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  children: widget.items.map((item) {
                    return ElevatedButton(
                      onPressed: () async {
                        final currentPage = pageController.hasClients
                            ? pageController.page?.round() ?? 0
                            : 0;
                        final selectedUrl = urls[currentPage];
                        final selectedItem = item;
                        final annotatorId =
                            Supabase.instance.client.auth.currentUser?.id ??
                            "unknown";

                        // Save to Supabase
                        try {
                          await supabase.from('annotations').insert({
                            'project_id': widget.projectId,
                            'image_url': selectedUrl,
                            'selected_item': selectedItem,
                            'annotator_id': annotatorId,
                            'created_at': DateTime.now().toIso8601String(),
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Saved: $selectedItem for image'),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error saving annotation: $e'),
                            ),
                          );
                        }
                      },

                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: Colors.blue.shade600,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                      child: Text(
                        item,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }
}
