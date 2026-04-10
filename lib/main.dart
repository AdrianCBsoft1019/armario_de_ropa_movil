import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

enum Category { camisetas, zapatos, pantalones, chaquetas }

extension CategoryInfo on Category {
  String get label {
    switch (this) {
      case Category.camisetas:
        return 'Camisetas';
      case Category.zapatos:
        return 'Zapatos';
      case Category.pantalones:
        return 'Pantalones';
      case Category.chaquetas:
        return 'Chaquetas';
    }
  }

  IconData get icon {
    switch (this) {
      case Category.camisetas:
        return Icons.checkroom;
      case Category.zapatos:
        return Icons.directions_run;
      case Category.pantalones:
        return Icons.straight;
      case Category.chaquetas:
        return Icons.shopping_bag;
    }
  }
}

class Garment {
  Garment({
    required this.id,
    required this.name,
    required this.category,
    this.photo,
    this.isFavorite = false,
  });

  final String id;
  String name;
  Category category;
  XFile? photo;
  bool isFavorite;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mi Armario',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ImagePicker _picker = ImagePicker();
  final List<Garment> _garments = [];
  int _selectedIndex = 0;

  void _toggleFavorite(Garment garment) {
    setState(() {
      garment.isFavorite = !garment.isFavorite;
    });
  }

  void _showAddGarmentSheet() {
    final TextEditingController nameController = TextEditingController();
    Category selectedCategory = Category.camisetas;
    XFile? selectedPhoto;
    bool isFavorite = false;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      child: Text(
                        'Registrar prenda',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Nombre de la prenda',
                        labelStyle: const TextStyle(color: Colors.deepPurple),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.deepPurple,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.deepPurple,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(
                          Icons.checkroom,
                          color: Colors.deepPurple,
                        ),
                      ),
                      onChanged: (_) => setModalState(() {}),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<Category>(
                      initialValue: selectedCategory,
                      decoration: InputDecoration(
                        labelText: 'Categoría',
                        labelStyle: const TextStyle(color: Colors.deepPurple),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.deepPurple,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.deepPurple,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(
                          Icons.category,
                          color: Colors.deepPurple,
                        ),
                      ),
                      items: Category.values.map((Category category) {
                        return DropdownMenuItem<Category>(
                          value: category,
                          child: Text(category.label),
                        );
                      }).toList(),
                      onChanged: (Category? value) {
                        if (value != null) {
                          setModalState(() {
                            selectedCategory = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.camera_alt),
                            label: const Text('Cámara'),
                            onPressed: () async {
                              final image = await _picker.pickImage(
                                source: ImageSource.camera,
                                maxWidth: 1000,
                              );
                              if (image != null) {
                                setModalState(() {
                                  selectedPhoto = image;
                                });
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.photo_library),
                            label: const Text('Galería'),
                            onPressed: () async {
                              final image = await _picker.pickImage(
                                source: ImageSource.gallery,
                                maxWidth: 1000,
                              );
                              if (image != null) {
                                setModalState(() {
                                  selectedPhoto = image;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    selectedPhoto == null
                        ? Container(
                            height: 180,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.deepPurple.withAlpha(
                                  (255 * 0.3).round(),
                                ),
                                width: 2,
                              ),
                              color: Colors.deepPurple.withAlpha(
                                (255 * 0.05).round(),
                              ),
                            ),
                            child: const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.image_not_supported,
                                    size: 48,
                                    color: Colors.deepPurple,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Toca cámara o galería para cargar foto',
                                    style: TextStyle(color: Colors.deepPurple),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.file(
                              File(selectedPhoto!.path),
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                    const SizedBox(height: 16),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      value: isFavorite,
                      title: const Text('Marcar como favorito'),
                      activeColor: Colors.deepPurple,
                      onChanged: (value) {
                        setModalState(() {
                          isFavorite = value ?? false;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: nameController.text.trim().isEmpty
                            ? null
                            : () {
                                final newGarment = Garment(
                                  id: DateTime.now().millisecondsSinceEpoch
                                      .toString(),
                                  name: nameController.text.trim(),
                                  category: selectedCategory,
                                  photo: selectedPhoto,
                                  isFavorite: isFavorite,
                                );
                                setState(() {
                                  _garments.add(newGarment);
                                });
                                Navigator.of(context).pop();
                              },
                        child: const Text('Guardar prenda'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCategorySummary() {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: Category.values.length,
        separatorBuilder: (context, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final category = Category.values[index];
          final count = _garments
              .where((item) => item.category == category)
              .length;
          return Container(
            width: 140,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.deepPurple.withAlpha((255 * 0.7).round()),
                  Colors.deepPurple.withAlpha((255 * 0.5).round()),
                ],
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurple.withAlpha((255 * 0.2).round()),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(category.icon, size: 28, color: Colors.white),
                const SizedBox(height: 12),
                Text(
                  category.label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                Text(
                  '$count prendas',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildGarmentCard(Garment garment) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      shadowColor: Colors.deepPurple.withAlpha((255 * 0.2).round()),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _toggleFavorite(garment),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: garment.photo != null
                    ? Image.file(File(garment.photo!.path), fit: BoxFit.cover)
                    : Container(
                        color: Colors.deepPurple.withAlpha((255 * 0.1).round()),
                        child: const Icon(
                          Icons.photo,
                          size: 64,
                          color: Colors.deepPurple,
                        ),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    garment.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.withAlpha(
                            (255 * 0.1).round(),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              garment.category.icon,
                              size: 14,
                              color: Colors.deepPurple,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              garment.category.label,
                              style: const TextStyle(
                                color: Colors.deepPurple,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => _toggleFavorite(garment),
                        child: Icon(
                          garment.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: garment.isFavorite
                              ? Colors.red
                              : Colors.deepPurple.withAlpha(
                                  (255 * 0.5).round(),
                                ),
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArmarioTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Categorías',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const SizedBox(height: 12),
        _buildCategorySummary(),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('Mi ropa', style: Theme.of(context).textTheme.titleLarge),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: _garments.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      'Agrega prendas a tu armario. Toma una foto, elige la categoría y marca tus favoritas.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: _garments.length,
                  itemBuilder: (context, index) {
                    return _buildGarmentCard(_garments[index]);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildFavoritesTab() {
    final favorites = _garments.where((garment) => garment.isFavorite).toList();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: favorites.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 80,
                    color: Colors.deepPurple.withAlpha((255 * 0.2).round()),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No has marcado outfits favoritos aún.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Pulsa el corazón en una prenda para guardarla aquí',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              itemCount: favorites.length,
              separatorBuilder: (context, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final garment = favorites[index];
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.deepPurple.withAlpha((255 * 0.05).round()),
                        Colors.deepPurple.withAlpha((255 * 0.02).round()),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: Colors.deepPurple.withAlpha((255 * 0.15).round()),
                      width: 1,
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: garment.photo != null
                          ? Image.file(
                              File(garment.photo!.path),
                              width: 64,
                              height: 64,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              width: 64,
                              height: 64,
                              color: Colors.deepPurple.withAlpha(
                                (255 * 0.1).round(),
                              ),
                              child: const Icon(
                                Icons.photo,
                                color: Colors.deepPurple,
                              ),
                            ),
                    ),
                    title: Text(
                      garment.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    subtitle: Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.withAlpha((255 * 0.1).round()),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        garment.category.label,
                        style: const TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    trailing: GestureDetector(
                      onTap: () => _toggleFavorite(garment),
                      child: Icon(
                        Icons.favorite,
                        color: Colors.red.withAlpha((255 * 0.7).round()),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [_buildArmarioTab(), _buildFavoritesTab()];

    return Scaffold(
      appBar: AppBar(title: Text(widget.title), centerTitle: false),
      body: pages[_selectedIndex],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddGarmentSheet,
        icon: const Icon(Icons.add),
        label: const Text('Agregar prenda'),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (value) =>
            setState(() => _selectedIndex = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.checkroom), label: 'Armario'),
          NavigationDestination(icon: Icon(Icons.star), label: 'Favoritos'),
        ],
      ),
    );
  }
}
