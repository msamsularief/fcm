import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ImageDownloadHandler {
  /// Downloading Image from Internet
  Future<String?> downloadAndSaveFile(String? url, String? fileName) async {
    if (url != null) {
      final Directory? directory = await getExternalStorageDirectory();
      if (directory != null) {
        final Directory newDir =
            await Directory('${directory.path}/Images').create(recursive: true);
        final String filePath = '${newDir.path}/$fileName.jpg';

        debugPrint('Downloading image...');

        final http.Response response = await http.get(Uri.parse(url));
        final File file = File(filePath);
        var files = await file.writeAsBytes(response.bodyBytes);

        debugPrint('Image Downloaded...');

        return files.path;
      } else {
        debugPrint('Cant read image directory!');
        return null;
      }
    } else {
      return null;
    }
  }
}
