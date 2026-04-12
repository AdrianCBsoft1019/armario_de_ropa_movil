import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/garment.dart';

class StorageService {
  static const String _key = 'wardrobe_garments';

  /// Guarda la lista completa de prendas en shared_preferences.
  Future<void> saveGarments(List<Garment> garments) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = garments.map((g) => jsonEncode(g.toJson())).toList();
    await prefs.setStringList(_key, jsonList);
  }

  /// Carga la lista de prendas desde shared_preferences.
  Future<List<Garment>> loadGarments() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_key);
    if (jsonList == null) return [];

    return jsonList.map((jsonStr) {
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      return Garment.fromJson(map);
    }).toList();
  }

  /// Limpia todo el almacenamiento de prendas.
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}