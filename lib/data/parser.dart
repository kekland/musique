import 'dart:io';
import 'dart:typed_data';

import 'package:audio_metadata_reader/audio_metadata_reader.dart';

class ParsedPicture {
  ParsedPicture({
    required this.data,
    required this.hash,
  });

  final Uint8List data;
  final int hash;
}

class ParsedSong {
  ParsedSong({
    required this.file,
    required this.title,
    this.artist,
    this.performers,
    this.album,
    this.trackNumber,
    this.discNumber,
    this.duration,
    this.year,
    this.picture,
  });

  final File file;
  final String title;
  final String? artist;
  final String? performers;
  final String? album;
  final int? trackNumber;
  final int? discNumber;
  final Duration? duration;
  final int? year;
  final ParsedPicture? picture;
}

final _supportedExtensions = {
  'mp3',
  'flac',
  'ogg',
  'm4a',
  'wav',
};

Stream<ParsedSong> parseLibrary(Directory baseDirectory) async* {
  // Recursively parse the library directory
  final entities = await baseDirectory.list(recursive: true).toList();

  for (final entity in entities) {
    if (entity is File && _supportedExtensions.contains(entity.path.toLowerCase().split('.').last)) {
      final metadata = readMetadata(entity, getImage: true);
      ParsedPicture? picture;

      if (metadata.pictures.isNotEmpty) {
        picture = ParsedPicture(
          data: metadata.pictures.first.bytes,
          hash: '${metadata.artist}/${metadata.album}'.hashCode,
        );
      } else {
        // Check for cover.jpg or folder.jpg in the same directory
        final coverFile = File('${entity.parent.path}/cover.jpg');
        final folderFile = File('${entity.parent.path}/folder.jpg');
        if (await coverFile.exists()) {
          picture = ParsedPicture(
            data: await coverFile.readAsBytes(),
            hash: coverFile.path.hashCode,
          );
        } else if (await folderFile.exists()) {
          picture = ParsedPicture(
            data: await folderFile.readAsBytes(),
            hash: folderFile.path.hashCode,
          );
        }
      }

      final song = ParsedSong(
        file: entity,
        title: metadata.title ?? entity.uri.pathSegments.last,
        artist: metadata.artist,
        performers: metadata.performers.isNotEmpty ? metadata.performers.join(', ') : null,
        album: metadata.album,
        trackNumber: metadata.trackNumber,
        discNumber: metadata.discNumber,
        duration: metadata.duration,
        year: metadata.year?.year,
        picture: picture,
      );

      yield song;
    }
  }
}
