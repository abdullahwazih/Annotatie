class ProjectModel {
  final String id;
  final String userId;
  final String? annotatorId; // <- New field added
  final String? type;
  final String? description;
  final List<dynamic>? items;
  final String? uploadedFolderPath;
  final DateTime? createdAt;

  ProjectModel({
    required this.id,
    required this.userId,
    this.annotatorId, // <- New parameter added
    this.type,
    this.description,
    this.items,
    this.uploadedFolderPath,
    this.createdAt,
  });

  factory ProjectModel.fromMap(Map<String, dynamic> map) {
    return ProjectModel(
      id: map['id'],
      userId: map['user_id'],
      annotatorId: map['annotator_id'], // <- Mapping from map
      type: map['type'],
      description: map['description'],
      items: map['items'] != null ? List<dynamic>.from(map['items']) : null,
      uploadedFolderPath: map['uploaded_folder_path'],
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : null,
    );
  }
}
