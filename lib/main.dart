import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/camera_service.dart';
import 'models/garment.dart';
import 'providers/wardrobe_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => WardrobeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Armario Digital',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CameraService _cameraService = CameraService();
  final TextEditingController _nameController = TextEditingController();
  String _selectedCategory = 'Camiseta';

  final List<String> _categories = [
    'Camiseta',
    'Pantalón',
    'Zapatos',
    'Chaqueta',
    'Accesorio',
    'Vestido',
    'Falda',
    'Otro',
  ];

  void _showAddGarmentSheet() {
    _nameController.clear();
    _selectedCategory = 'Camiseta';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        String? photoPath;

        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                left: 24,
                right: 24,
                top: 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    'Añadir Prenda',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  /// FOTO
                  GestureDetector(
                    onTap: () async {
                      final path = await _cameraService.takePhoto();
                      if (path != null) {
                        setSheetState(() => photoPath = path);
                      }
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
                              child: Image.file(
                                File(photoPath!),
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.camera_alt,
                                    size: 48, color: Colors.grey[400]),
                                const SizedBox(height: 8),
                                Text('Toca para tomar foto',
                                    style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 16)),
                              ],
                            ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// NOMBRE
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

                  /// CATEGORIA
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: InputDecoration(
                      labelText: 'Categoría',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.category),
                    ),
                    items: _categories
                        .map((cat) =>
                            DropdownMenuItem(value: cat, child: Text(cat)))
                        .toList(),
                    onChanged: (value) {
                      setSheetState(
                          () => _selectedCategory = value ?? 'Camiseta');
                    },
                  ),

                  const SizedBox(height: 20),

                  /// GUARDAR
                  ElevatedButton.icon(
                    onPressed: () {
                      if (_nameController.text.isEmpty || photoPath == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Debes tomar una foto y escribir un nombre')),
                        );
                        return;
                      }

                      final garment = Garment(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        name: _nameController.text.trim(),
                        category: _selectedCategory,
                        imagePath: photoPath!,
                      );

                      context
                          .read<WardrobeProvider>()
                          .addGarment(garment);

                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text('${garment.name} añadida al armario')),
                      );
                    },
                    icon: const Icon(Icons.save),
                    label: const Text('Guardar Prenda'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WardrobeProvider>(
      builder: (context, wardrobe, child) {
        final garments = wardrobe.garments;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Mi Armario'),
            centerTitle: true,
          ),
          body: garments.isEmpty
              ? const Center(child: Text('Tu armario está vacío'))
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: garments.length,
                  itemBuilder: (context, index) {
                    final garment = garments[index];

                    return Card(
                      child: Column(
                        children: [
                          Expanded(
                            child: Image.file(
                              File(garment.imagePath),
                              fit: BoxFit.cover,
                            ),
                          ),
                          Text(garment.name),
                          Text(garment.category),
                        ],
                      ),
                    );
                  },
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: _showAddGarmentSheet,
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
