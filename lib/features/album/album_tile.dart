import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:musique/imports.dart';

class AlbumTile extends HookWidget {
  const AlbumTile({
    super.key,
    this.onTap,
    required this.album,
  });

  final VoidCallback? onTap;
  final Album album;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 64.0,
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.only(left: 16.0, right: 4.0),
        selectedTileColor: context.colorScheme.surfaceContainerHigh,
        subtitleTextStyle: TextStyle(
          inherit: true,
          color: context.colorScheme.onSurfaceVariant.withOpacity(0.6),
          fontSize: 13.0,
        ),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(4.0),
          child: SizedBox(
            width: 48.0,
            height: 48.0,
            child: DbImage(id: album.pictureId ?? 0, fit: BoxFit.cover),
          ),
        ),
        title: Text(album.name, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(album.artist ?? 'Unknown Artist', maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
    );
  }
}
