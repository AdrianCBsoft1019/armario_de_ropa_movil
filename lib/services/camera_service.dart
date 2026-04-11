import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class CameraService {
  final ImagePicker _picker = ImagePicker();

  /// Abre la cámara, toma una foto y la guarda en el directorio de la app.
  /// Retorna la ruta local del archivo guardado, o null si se cancela.
  Future<String?> takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (photo == null) return null;

      // Obtener directorio de la app
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String garmentDir = path.join(appDir.path, 'garments');

      // Crear carpeta si no existe
      final Directory dir = Directory(garmentDir);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      // Nombre único basado en timestamp
      final String fileName =
          'garment_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String savedPath = path.join(garmentDir, fileName);

      // Copiar la foto al directorio de la app
      final File savedFile = await File(photo.path).copy(savedPath);

      return savedFile.path;
    } catch (e) {
      print('Error al tomar foto: $e');
      return null;
    }
  }

  /// Elimina una foto del almacenamiento local.
  Future<void> deletePhoto(String filePath) async {
    try {
      final File file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print('Error al eliminar foto: $e');
    }
  }
}