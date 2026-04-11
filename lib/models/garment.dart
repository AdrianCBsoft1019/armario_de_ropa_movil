class Garment {
  final String id;
  final String name;
  final String category;
  final String imagePath;
  final bool isFavorite;
  final DateTime createdAt;

  Garment({
    required this.id,
    required this.name,
    required this.category,
    required this.imagePath,
    this.isFavorite = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Garment copyWith({
    String? id,
    String? name,
    String? category,
    String? imagePath,
    bool? isFavorite,
    DateTime? createdAt,
  }) {
    return Garment(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      imagePath: imagePath ?? this.imagePath,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'imagePath': imagePath,
      'isFavorite': isFavorite,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Garment.fromJson(Map<String, dynamic> json) {
    return Garment(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      imagePath: json['imagePath'] as String,
      isFavorite: json['isFavorite'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}