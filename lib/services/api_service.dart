import '../models/clothing_product.dart';

class ApiService {
  Future<List<ClothingProduct>> fetchClothingProducts() async {
    // Sample data since no API is working
    final sampleData = [
      {
        "id": 1,
        "title": "Camisa de algodón blanca",
        "description": "Camisa cómoda de algodón para uso diario",
        "category": "Camisas",
        "image": "https://via.placeholder.com/300x300?text=Camisa+Blanca",
        "ratingCount": 120,
      },
      {
        "id": 2,
        "title": "Camisa azul formal",
        "description": "Camisa azul perfecta para ocasiones formales",
        "category": "Camisas",
        "image": "https://via.placeholder.com/300x300?text=Camisa+Azul",
        "ratingCount": 95,
      },
      {
        "id": 3,
        "title": "Camisa a cuadros",
        "description": "Camisa casual con diseño a cuadros",
        "category": "Camisas",
        "image": "https://via.placeholder.com/300x300?text=Camisa+Cuadros",
        "ratingCount": 60,
      },
      {
        "id": 4,
        "title": "Pantalones vaqueros clásicos",
        "description": "Pantalones vaqueros resistentes y cómodos",
        "category": "Pantalones",
        "image": "https://via.placeholder.com/300x300?text=Pantalones+Vaqueros",
        "ratingCount": 85,
      },
      {
        "id": 5,
        "title": "Pantalones de vestir negros",
        "description": "Pantalones elegantes para el trabajo",
        "category": "Pantalones",
        "image": "https://via.placeholder.com/300x300?text=Pantalones+Negros",
        "ratingCount": 110,
      },
      {
        "id": 6,
        "title": "Pantalones cargo",
        "description": "Pantalones con bolsillos para aventuras",
        "category": "Pantalones",
        "image": "https://via.placeholder.com/300x300?text=Pantalones+Cargo",
        "ratingCount": 95,
      },
      {
        "id": 7,
        "title": "Zapatos deportivos running",
        "description": "Zapatos cómodos para correr y ejercicio",
        "category": "Zapatos",
        "image": "https://via.placeholder.com/300x300?text=Zapatos+Running"
      },
      {
        "id": 8,
        "title": "Zapatos formales negros",
        "description": "Zapatos clásicos para ocasiones especiales",
        "category": "Zapatos",
        "image": "https://via.placeholder.com/300x300?text=Zapatos+Formales",
        "ratingCount": 150,
      },
      {
        "id": 9,
        "title": "Abrigo de invierno grueso",
        "description": "Abrigo cálido para climas fríos",
        "category": "Abrigos",
        "image": "https://via.placeholder.com/300x300?text=Abrigo+Invierno",
        "ratingCount": 150,
      },
      {
        "id": 10,
        "title": "Chaqueta ligera",
        "description": "Chaqueta perfecta para primavera",
        "category": "Abrigos",
        "image": "https://via.placeholder.com/300x300?text=Chaqueta+Ligera",
        "ratingCount": 120,
      },
      {
        "id": 11,
        "title": "Vestido elegante rojo",
        "description": "Vestido perfecto para ocasiones especiales",
        "category": "Vestidos",
        "image": "https://via.placeholder.com/300x300?text=Vestido+Rojo",
        "ratingCount": 90,
      },
      {
        "id": 12,
        "title": "Vestido casual azul",
        "description": "Vestido cómodo para uso diario",
        "category": "Vestidos",
        "image": "https://via.placeholder.com/300x300?text=Vestido+Azul",
        "ratingCount": 75,
      },
    ];

    final products = sampleData
        .cast<Map<String, dynamic>>()
        .map(ClothingProduct.fromJson)
        .toList();

    return products;
  }
}
