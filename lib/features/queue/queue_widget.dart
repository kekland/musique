import 'package:flutter/material.dart';
import 'package:musique/features/album/album_tile.dart';
import 'package:musique/imports.dart';

class CurrentQueueWidget extends StatelessWidget {
  const CurrentQueueWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        DefaultListValueControllerBuilder(
          valueController: di.library.allAlbumsController,
          valueBuilder: (context, i, album) {
            return AlbumTile(album: album);
          },
        ),
      ],
    );
  }
}
