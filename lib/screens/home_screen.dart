import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/clothing_product.dart';
import '../services/api_service.dart';
import '../widgets/product_card.dart';

enum ClothingSection { all, camisetas, pantalones, zapatos, abrigos }

extension ClothingSectionInfo on ClothingSection {
  String get label {
    switch (this) {
      case ClothingSection.all:
        return 'Todo';
      case ClothingSection.camisetas:
        return 'Camisas';
      case ClothingSection.pantalones:
        return 'Pantalones';
      case ClothingSection.zapatos:
        return 'Zapatos';
      case ClothingSection.abrigos:
        return 'Abrigos';
    }
  }

  IconData get icon {
    switch (this) {
      case ClothingSection.all:
        return Icons.checkroom;
      case ClothingSection.camisetas:
        return Icons.checkroom;
      case ClothingSection.pantalones:
        return Icons.straighten;
      case ClothingSection.zapatos:
        return Icons.directions_run;
      case ClothingSection.abrigos:
        return Icons.shopping_bag;
    }
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  final ImagePicker _picker = ImagePicker();
  late Future<List<ClothingProduct>> _futureProducts;
  List<ClothingProduct> _wardrobeProducts = [];
  ClothingSection _selectedSection = ClothingSection.all;

  @override
  void initState() {
    super.initState();
    _futureProducts = _apiService.fetchClothingProducts();
  }

  void _refreshProducts() {
    setState(() {
      _futureProducts = _apiService.fetchClothingProducts();
    });
  }

  Future<void> _showAddOptions() async {
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Agregar Ropa'),
        content: const Text('¿Cómo quieres agregar la imagen?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(ImageSource.camera),
            child: const Text('Tomar Foto'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(ImageSource.gallery),
            child: const Text('Subir Imagen'),
          ),
        ],
      ),
    );

    if (source != null) {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        await _selectCategoryAndAdd(image);
      }
    }
  }

  Future<void> _selectCategoryAndAdd(XFile image) async {
    final categories = [
      'Camisas',
      'Pantalones',
      'Zapatos',
      'Abrigos',
      'Vestidos',
    ];
    final selectedCategory = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Seleccionar Categoría'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: categories
              .map(
                (cat) => ListTile(
                  title: Text(cat),
                  onTap: () => Navigator.of(context).pop(cat),
                ),
              )
              .toList(),
        ),
      ),
    );

    if (selectedCategory != null) {
      final descriptionController = TextEditingController();
      final description = await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Agregar Descripción'),
          content: TextField(
            controller: descriptionController,
            decoration: const InputDecoration(
              hintText: 'Describe tu prenda...',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(''),
              child: const Text('Sin descripción'),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pop(descriptionController.text),
              child: const Text('Guardar'),
            ),
          ],
        ),
      );

      if (description != null) {
        final newProduct = ClothingProduct(
          id: DateTime.now().millisecondsSinceEpoch,
          title: 'Ropa Personalizada',
          price: 0.0,
          description: description.isEmpty
              ? 'Agregado desde ${image.name}'
              : description,
          category: selectedCategory,
          image: image.path,
          rating: 0.0,
          ratingCount: 0,
        );
        setState(() {
          _wardrobeProducts.add(newProduct);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ropa agregada al armario')),
        );
      }
    }
  }

  bool _matchesSection(ClothingProduct product, ClothingSection section) {
    final title = product.title.toLowerCase();
    switch (section) {
      case ClothingSection.all:
        return true;
      case ClothingSection.camisetas:
        return title.contains('camisa') || title.contains('shirt');
      case ClothingSection.pantalones:
        return title.contains('pantalon') || title.contains('pant');
      case ClothingSection.zapatos:
        return title.contains('zapato') || title.contains('shoe');
      case ClothingSection.abrigos:
        return title.contains('abrigo') ||
            title.contains('chaqueta') ||
            title.contains('jacket') ||
            title.contains('coat');
    }
  }

  List<ClothingProduct> _filterProducts(
    List<ClothingProduct> products,
    ClothingSection section,
  ) {
    return products
        .where((product) => _matchesSection(product, section))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mi Armario')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Productos de ropa',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Filtra por camisas, pantalones, zapatos y abrigos',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 54,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                final section = ClothingSection.values[index];
                return ChoiceChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(section.icon, size: 18),
                      const SizedBox(width: 6),
                      Text(section.label),
                    ],
                  ),
                  selected: _selectedSection == section,
                  selectedColor: Colors.deepPurple,
                  backgroundColor: Colors.grey.shade200,
                  labelStyle: TextStyle(
                    color: _selectedSection == section
                        ? Colors.white
                        : Colors.black87,
                  ),
                  onSelected: (_) {
                    setState(() {
                      _selectedSection = section;
                    });
                  },
                );
              },
              separatorBuilder: (context, index) => const SizedBox(width: 10),
              itemCount: ClothingSection.values.length,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: FutureBuilder<List<ClothingProduct>>(
              future: _futureProducts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'Error al cargar los productos. Verifica tu conexión e inténtalo de nuevo.\n\n${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  );
                }

                final apiProducts = snapshot.data ?? [];
                final allProducts = [...apiProducts, ..._wardrobeProducts];
                final filteredProducts = _filterProducts(
                  allProducts,
                  _selectedSection,
                );

                if (filteredProducts.isEmpty) {
                  return Center(
                    child: Text(
                      'No hay productos para ${_selectedSection.label.toLowerCase()}.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    return ProductCard(product: filteredProducts[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddOptions,
        icon: const Icon(Icons.add),
        label: const Text('Agregar Ropa'),
      ),
    );
  }
}
