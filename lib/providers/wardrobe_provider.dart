import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/garment.dart';

class WardrobeProvider extends ChangeNotifier {
  List<Garment> _garments = [];

  List<Garment> get garments => List.unmodifiable(_garments);

  List<Garment> get favorites =>
      _garments.where((g) => g.isFavorite).toList();

  List<String> get categories =>
      _garments.map((g) => g.category).toSet().toList();

  void addGarment(Garment garment) {
    _garments.add(garment);
    notifyListeners();
  }

  void removeGarment(String id) {
    _garments.removeWhere((g) => g.id == id);
    notifyListeners();
  }

  void toggleFavorite(String id) {
    final index = _garments.indexWhere((g) => g.id == id);
    if (index != -1) {
      _garments[index] = _garments[index].copyWith(
        isFavorite: !_garments[index].isFavorite,
      );
      notifyListeners();
    }
  }

  List<Garment> getByCategory(String category) {
    return _garments.where((g) => g.category == category).toList();
  }

  /// Genera un outfit aleatorio: una prenda de cada categoría disponible.
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