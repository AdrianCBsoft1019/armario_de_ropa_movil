import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/garment.dart';
import '../services/storage_service.dart';

class WardrobeProvider extends ChangeNotifier {
  final StorageService _storage = StorageService();
  List<Garment> _garments = [];
  bool _isLoaded = false;

  List<Garment> get garments => List.unmodifiable(_garments);
  bool get isLoaded => _isLoaded;

  List<Garment> get favorites =>
      _garments.where((g) => g.isFavorite).toList();

  List<String> get categories =>
      _garments.map((g) => g.category).toSet().toList();

  /// Carga las prendas desde shared_preferences.
  Future<void> loadFromStorage() async {
    _garments = await _storage.loadGarments();
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> _save() async {
    await _storage.saveGarments(_garments);
  }

  void addGarment(Garment garment) {
    _garments.add(garment);
    notifyListeners();
    _save();
  }

  void removeGarment(String id) {
    _garments.removeWhere((g) => g.id == id);
    notifyListeners();
    _save();
  }

  void toggleFavorite(String id) {
    final index = _garments.indexWhere((g) => g.id == id);
    if (index != -1) {
      _garments[index] = _garments[index].copyWith(
        isFavorite: !_garments[index].isFavorite,
      );
      notifyListeners();
      _save();
    }
  }

  List<Garment> getByCategory(String category) {
    return _garments.where((g) => g.category == category).toList();
  }

  List<Garment> getRandomOutfit() {
    if (_garments.isEmpty) return [];

    final random = Random();
    final cats = categories;
    final outfit = <Garment>[];

    for (final cat in cats) {
      final catGarments = getByCategory(cat);
      if (catGarments.isNotEmpty) {
        outfit.add(catGarments[random.nextInt(catGarments.length)]);
      }
    }
    return outfit;
  }
}