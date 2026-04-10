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
        "image": "https://www.puntoblanco.co/cdn/shop/files/ceya-blanco-900-729513_000900-5_b3902d80-3983-4d9d-a25a-ac431b18de0d.jpg",
        "ratingCount": 120,
      },
      {
        "id": 2,
        "title": "Camisa azul formal",
        "description": "Camisa azul perfecta para ocasiones formales",
        "category": "Camisas",
        "image": "https://thumbs.dreamstime.com/b/camisas-de-vestir-azules-colgadas-en-el-tendedero-una-camisa-azul-crujiente-y-limpia-cuelga-un-contra-fondo-blanco-perfecto-para-392358856.jpg",
        "ratingCount": 95,
      },
      {
        "id": 3,
        "title": "Camisa a cuadros",
        "description": "Camisa casual con diseño a cuadros",
        "category": "Camisas",
        "image": "https://whitmanstore.com.co/cdn/shop/files/CamisaHCIJamaicaCuadrosVerdes1.jpg",
        "ratingCount": 60,
      },
      {
        "id": 4,
        "title": "Pantalones vaqueros clásicos",
        "description": "Pantalones vaqueros resistentes y cómodos",
        "category": "Pantalones",
        "image": "https://arturocalle.vteximg.com.br/arquivos/ids/770615/HOMBRE-JEAN-10135898-AZUL-740_1.jpg",
        "ratingCount": 85,
      },
      {
        "id": 5,
        "title": "Pantalones de vestir negros",
        "description": "Pantalones elegantes para el trabajo",
        "category": "Pantalones",
        "image": "https://totalchef.mx/cdn/shop/files/Pantalon-Basico-Negro-Talla-Mediana-Uniformes-De-Mexico-PBN05.png",
        "ratingCount": 110,
      },
      {
        "id": 6,
        "title": "Pantalones cargo",
        "description": "Pantalones con bolsillos para aventuras",
        "category": "Pantalones",
        "image": "https://colombia.bioweb.co/cdn/shop/products/ALFI_e90db195-755d-42f3-800a-94912e49b7de.jpg",
        "ratingCount": 95,
      },
      {
        "id": 7,
        "title": "Zapatos deportivos running",
        "description": "Zapatos cómodos para correr y ejercicio",
        "category": "Zapatos",
        "image": "https://www.gef.co/cdn/shop/files/zoe-tenis-beige-8040-745739_008040-1_28a4d3dd-79ba-45ed-8e60-8d299f42a053.jpg"
      },
      {
        "id": 8,
        "title": "Zapatos formales negros",
        "description": "Zapatos clásicos para ocasiones especiales",
        "category": "Zapatos",
        "image": "https://www.villaromana.com.co/cdn/shop/products/ZA00103031_01.jpg",
        "ratingCount": 150,
      },
      {
        "id": 9,
        "title": "Abrigo de invierno grueso",
        "description": "Abrigo cálido para climas fríos",
        "category": "Abrigos",
        "image": "https://m.media-amazon.com/images/I/71vlmpcIe0L._AC_UY1000_.jpg",
        "ratingCount": 150,
      },
      {
        "id": 10,
        "title": "Chaqueta ligera",
        "description": "Chaqueta perfecta para primavera",
        "category": "Abrigos",
        "image": "https://m.media-amazon.com/images/I/61S2JEkSQJL._AC_UY1000_.jpg",
        "ratingCount": 120,
      },
      {
        "id": 11,
        "title": "Vestido elegante rojo",
        "description": "Vestido perfecto para ocasiones especiales",
        "category": "Vestidos",
        "image": "https://png.pngtree.com/png-vector/20250220/ourlarge/pngtree-elegant-red-satin-evening-gown-png-image_15539980.png",
        "ratingCount": 90,
      },
      {
        "id": 12,
        "title": "Vestido casual azul",
        "description": "Vestido cómodo para uso diario",
        "category": "Vestidos",
        "image": "https://looktwice.co/cdn/shop/files/KNM005-1-Vestido-Azul-Polo-KNM005_e9b014b3-b73f-4539-8f15-79f177f1b99b.jpg",
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
