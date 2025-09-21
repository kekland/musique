import 'package:flutter/material.dart';
import 'package:musique/features/album/album_tile.dart';
import 'package:musique/imports.dart';

class HomePageDrawer extends HookWidget {
  const HomePageDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        MuDefaultListValueControllerBuilder(
          valueController: di.library.allAlbumsController,
          valueBuilder: (context, i, album) {
            return AlbumTile(album: album);
          },
        ),
      ],
    );
  }
}
