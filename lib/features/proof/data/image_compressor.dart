import 'dart:io';
import 'dart:math';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

abstract interface class ImageCompressor {
  Future<File> compress(File image);
}

class DefaultImageCompressor implements ImageCompressor {
  const DefaultImageCompressor();

  static const _maxSize = 1 * 1024 * 1024;
  static const _minQuality = 20;

  @override
  Future<File> compress(File image) async {
    if (await image.length() <= _maxSize) return image;

    final dir = await getTemporaryDirectory();
    final outPath = '${dir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg';

    var quality = 85;
    File? result;

    while (quality >= _minQuality) {
      final data = await FlutterImageCompress.compressAndGetFile(
        image.absolute.path,
        outPath,
        quality: quality,
        format: CompressFormat.jpeg,
      );
      if (data == null) break;
      result = File(data.path);
      final len = await result.length();
      if (len <= _maxSize) return result;
      quality = max(_minQuality, quality - 10);
    }

    if (result != null) {
      final len = await result.length();
      if (len <= _maxSize * 2) return result;
    }

    return image;
  }
}
