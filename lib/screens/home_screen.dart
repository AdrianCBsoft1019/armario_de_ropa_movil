import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Importante para la vibración
import 'package:provider/provider.dart';
import '../models/clothing_product.dart';
import '../models/garment.dart';
import '../providers/wardrobe_provider.dart';
import '../services/api_service.dart';
import '../services/camera_service.dart';
import '../widgets/product_card.dart';

// ─────────────────────────────────────────────
// Secciones / Categorías
// ─────────────────────────────────────────────
enum ClothingSection { todo, camisetas, pantalones, zapatos, abrigos, vestidos }

extension ClothingSectionInfo on ClothingSection {
  String get label {
    switch (this) {
      case ClothingSection.todo:       return 'Todo';
      case ClothingSection.camisetas:  return 'Camisas';
      case ClothingSection.pantalones: return 'Pantalones';
      case ClothingSection.zapatos:    return 'Zapatos';
      case ClothingSection.abrigos:    return 'Abrigos';
      case ClothingSection.vestidos:   return 'Vestidos';
    }
  }

  IconData get icon {
    switch (this) {
      case ClothingSection.todo:       return Icons.grid_view;
      case ClothingSection.camisetas:  return Icons.checkroom;
      case ClothingSection.pantalones: return Icons.straighten;
      case ClothingSection.zapatos:    return Icons.directions_run;
      case ClothingSection.abrigos:    return Icons.shopping_bag;
      case ClothingSection.vestidos:   return Icons.dry_cleaning;
    }
  }
}

// ─────────────────────────────────────────────
// HomeScreen con 2 tabs
// ─────────────────────────────────────────────
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Armario'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.store), text: 'Catálogo'),
            Tab(icon: Icon(Icons.checkroom), text: 'Mi Armario'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _CatalogTab(),
          _WardrobeTab(),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Tab 1: Catálogo (productos de la API)
// ─────────────────────────────────────────────
class _CatalogTab extends StatefulWidget {
  const _CatalogTab();

  @override
  State<_CatalogTab> createState() => _CatalogTabState();
}

class _CatalogTabState extends State<_CatalogTab> {
  final ApiService _apiService = ApiService();
  late Future<List<ClothingProduct>> _futureProducts;
  ClothingSection _selectedSection = ClothingSection.todo;

  @override
  void initState() {
    super.initState();
    _futureProducts = _apiService.fetchClothingProducts();
  }

  bool _matchesSection(ClothingProduct p, ClothingSection s) {
    final cat = p.category.toLowerCase();
    switch (s) {
      case ClothingSection.todo:       return true;
      case ClothingSection.camisetas:  return cat.contains('camisa') || cat.contains('shirt');
      case ClothingSection.pantalones: return cat.contains('pantalon') || cat.contains('pant');
      case ClothingSection.zapatos:    return cat.contains('zapato') || cat.contains('shoe');
      case ClothingSection.abrigos:    return cat.contains('abrigo') || cat.contains('chaqueta') || cat.contains('jacket');
      case ClothingSection.vestidos:   return cat.contains('vestido') || cat.contains('dress');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 56,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: ClothingSection.values.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final section = ClothingSection.values[i];
              final selected = _selectedSection == section;
              return ChoiceChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(section.icon, size: 16,
                        color: selected ? Colors.white : Colors.black87),
                    const SizedBox(width: 4),
                    Text(section.label),
                  ],
                ),
                selected: selected,
                selectedColor: const Color(0xFF6C63FF),
                labelStyle: TextStyle(
                  color: selected ? Colors.white : Colors.black87,
                  fontSize: 13,
                ),
                onSelected: (_) =>
                    setState(() => _selectedSection = section),
              );
            },
          ),
        ),
        Expanded(
          child: FutureBuilder<List<ClothingProduct>>(
            future: _futureProducts,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final filtered = (snapshot.data ?? [])
                  .where((p) => _matchesSection(p, _selectedSection))
                  .toList();

              if (filtered.isEmpty) {
                return Center(
                  child: Text(
                    'No hay productos en ${_selectedSection.label}',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                );
              }

              return ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (context, i) =>
                    ProductCard(product: filtered[i]),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Tab 2: Mi Armario (prendas personales)
// ─────────────────────────────────────────────
class _WardrobeTab extends StatefulWidget {
  const _WardrobeTab();

  @override
  State<_WardrobeTab> createState() => _WardrobeTabState();
}

class _WardrobeTabState extends State<_WardrobeTab> {
  final CameraService _cameraService = CameraService();
  final TextEditingController _nameController = TextEditingController();
  String _selectedCategory = 'Camiseta';
  String _filterCategory = 'Todas';

  final List<String> _categories = [
    'Camiseta', 'Pantalón', 'Zapatos', 'Chaqueta',
    'Accesorio', 'Vestido', 'Falda', 'Otro',
  ];

  List<String> get _filterOptions => ['Todas', ..._categories];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _showAddGarmentSheet() {
    _nameController.clear();
    _selectedCategory = 'Camiseta';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        String? photoPath;
        return StatefulBuilder(
          builder: (ctx, setSheet) => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
              left: 24, right: 24, top: 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40, height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Añadir Prenda',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () async {
                    final p = await _cameraService.takePhoto();
                    if (p != null) setSheet(() => photoPath = p);
                  },
                  child: Container(
                    height: 180,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey[300]!, width: 2),
                    ),
                    child: photoPath != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.file(File(photoPath!),
                                fit: BoxFit.cover, width: double.infinity),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.camera_alt,
                                  size: 48, color: Colors.grey[400]),
                              const SizedBox(height: 8),
                              Text('Toca para tomar foto',
                                  style: TextStyle(
                                      color: Colors.grey[500], fontSize: 16)),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Nombre de la prenda',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.edit),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: InputDecoration(
                    labelText: 'Categoría',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.category),
                  ),
                  items: _categories
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) =>
                      setSheet(() => _selectedCategory = v ?? 'Camiseta'),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    if (_nameController.text.isEmpty || photoPath == null) {
                      ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
                          content: Text(
                              'Debes tomar una foto y escribir un nombre')));
                      return;
                    }
                    final garment = Garment(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: _nameController.text.trim(),
                      category: _selectedCategory,
                      imagePath: photoPath!,
                    );
                    context.read<WardrobeProvider>().addGarment(garment);
                    Navigator.pop(ctx);
                  },
                  icon: const Icon(Icons.save),
                  label: const Text('Guardar Prenda'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WardrobeProvider>(
      builder: (context, wardrobe, _) {
        final allGarments = wardrobe.garments;
        final garments = _filterCategory == 'Todas'
            ? allGarments
            : allGarments
                .where((g) => g.category == _filterCategory)
                .toList();

        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: _showAddGarmentSheet,
            child: const Icon(Icons.add),
          ),
          body: Column(
            children: [
              SizedBox(
                height: 56,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: _filterOptions.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    final opt = _filterOptions[i];
                    final selected = _filterCategory == opt;
                    return ChoiceChip(
                      label: Text(opt),
                      selected: selected,
                      onSelected: (_) =>
                          setState(() => _filterCategory = opt),
                    );
                  },
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: garments.length,
                  itemBuilder: (context, index) {
                    final garment = garments[index];
                    return Dismissible(
                      key: Key(garment.id),
                      direction: DismissDirection.up,
                      onDismissed: (_) {
                        // VIBRACIÓN AL ELIMINAR
                        HapticFeedback.vibrate(); 
                        wardrobe.removeGarment(garment.id);
                      },
                      background: Container(
                        decoration: BoxDecoration(
                          color: Colors.red[400],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(Icons.delete, color: Colors.white, size: 40),
                      ),
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: Image.file(
                                File(garment.imagePath), 
                                fit: BoxFit.cover
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                garment.name, 
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}