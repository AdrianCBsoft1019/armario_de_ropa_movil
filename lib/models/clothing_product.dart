class ClothingProduct {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final double rating;
  final int ratingCount;

  ClothingProduct({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
    required this.ratingCount,
  });

  factory ClothingProduct.fromJson(Map<String, dynamic> json) {
    final ratingJson = json['rating'];
    final categoryJson = json['category'];
    final images = json['images'];

    String imageUrl;
    if (images is List && images.isNotEmpty) {
      imageUrl = images.first.toString();
    } else {
      imageUrl = json['image'] as String? ?? '';
    }

    String categoryValue;
    if (categoryJson is Map<String, dynamic>) {
      categoryValue = categoryJson['name'] as String? ?? '';
    } else {
      categoryValue = categoryJson as String? ?? '';
    }

    double ratingValue = 0.0;
    int ratingCountValue = 0;
    if (ratingJson is Map<String, dynamic>) {
      ratingValue = (ratingJson['rate'] as num?)?.toDouble() ?? 0.0;
      ratingCountValue = (ratingJson['count'] as int?) ?? 0;
    } else if (ratingJson is num) {
      ratingValue = ratingJson.toDouble();
    }

    return ClothingProduct(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] as String? ?? '',
      category: categoryValue,
      image: imageUrl,
      rating: ratingValue,
      ratingCount: ratingCountValue,
    );
  }
}
