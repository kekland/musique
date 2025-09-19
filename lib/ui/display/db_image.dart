import 'dart:ui' as ui;

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:musique/imports.dart';

class DbImage extends StatelessWidget {
  const DbImage({
    super.key,
    required this.id,
    this.width,
    this.height,
    this.fit,
    this.alignment = Alignment.center,
  });

  final int id;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    return Image(
      image: DbImageProvider(id: id),
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
    );
  }
}

class DbImageProvider extends ImageProvider<int> {
  DbImageProvider({required this.id});

  final int id;

  @override
  Future<int> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture(id);
  }

  @override
  ImageStreamCompleter loadImage(int key, ImageDecoderCallback decode) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode: decode),
      scale: 1.0,
    );
  }

  /// Fetches the image from the asset bundle, decodes it, and returns a
  /// corresponding [ImageInfo] object.
  ///
  /// This function is used by [loadImage].
  @protected
  Future<ui.Codec> _loadAsync(int key, {required ImageDecoderCallback decode}) async {
    final ui.ImmutableBuffer buffer;

    try {
      final picture = await (di.db.pictures.select()..where((t) => t.id.equals(key))).getSingleOrNull();
      if (picture == null) {
        throw StateError('No picture found with id $key');
      }

      buffer = await ui.ImmutableBuffer.fromUint8List(picture.data);
    } on FlutterError {
      PaintingBinding.instance.imageCache.evict(key);
      rethrow;
    }

    return decode(buffer);
  }
}
