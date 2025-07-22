import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AnnotatorListPage extends StatefulWidget {
  final void Function(String annotatorId, String annotatorName)
  onAnnotatorSelected;

  const AnnotatorListPage({super.key, required this.onAnnotatorSelected});

  @override
  State<AnnotatorListPage> createState() => _AnnotatorListPageState();
}

class _AnnotatorListPageState extends State<AnnotatorListPage> {
  String? selectedAnnotatorId;

  void onAnnotatorTap(String annotatorId, String annotatorName) {
    setState(() {
      selectedAnnotatorId = annotatorId;
    });

    // Send annotator ID to parent
    widget.onAnnotatorSelected(annotatorId, annotatorName);

    // ✅ Show annotator NAME in SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Selected Annotator: $annotatorName')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 3.0,
                vertical: 8.0,
              ),
              child: SizedBox(
                height: 200,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .where('role', isEqualTo: 'admin')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text("Error fetching annotators."),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final docs = snapshot.data!.docs;

                    if (docs.isEmpty) {
                      return const Center(child: Text("No annotators found."));
                    }

                    return ListView.builder(
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final data = docs[index].data() as Map<String, dynamic>;
                        final annotatorId = docs[index].id;
                        final annotatorName = data['username'] ?? 'No Name';

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            leading: const Icon(Icons.person_outline),
                            title: Text(annotatorName),
                            onTap: () =>
                                onAnnotatorTap(annotatorId, annotatorName),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
