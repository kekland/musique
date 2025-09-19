import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:musique/imports.dart';

class SongTile extends HookWidget {
  const SongTile({
    super.key,
    this.onTap,
    required this.song,
  });

  final VoidCallback? onTap;
  final Song song;

  @override
  Widget build(BuildContext context) {
    final isCurrent = useComputed(() => di.player.currentSong?.id == song.id).value;

    return SizedBox(
      width: double.infinity,
      height: 64.0,
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.only(left: 16.0, right: 4.0),
        selected: isCurrent,
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
            child: DbImage(id: song.pictureId ?? 0, fit: BoxFit.cover),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              song.durationMs != null ? formatDuration(Duration(milliseconds: song.durationMs!)) : '',
              style: TextStyle(fontFeatures: [FontFeature.tabularFigures()]),
            ),
            const SizedBox(width: 4.0),
            SizedBox(
              width: 40.0,
              height: 40.0,
              child: IconButton(
                onPressed: () {},
                icon: Icon(Symbols.more_vert_rounded, size: 16.0),
              ),
            ),
          ],
        ),
        title: Text(song.title),
        subtitle: Text(song.artist ?? 'Unknown Artist'),
      ),
    );
  }
}
