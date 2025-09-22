import 'package:flutter/material.dart';
import 'package:musique/features/song/song_tile.dart';
import 'package:musique/imports.dart';
import 'package:musique/services/library/albums_value_controller.dart';
import 'package:musique/services/library/songs_value_controller.dart';

@RoutePage()
class AlbumPage extends HookWidget {
  const AlbumPage({
    super.key,
    required this.albumId,
  });

  final int albumId;

  @override
  Widget build(BuildContext context) {
    final valueController = useDisposable(() => AlbumValueController(id: albumId));
    final songsValueController = useDisposable(() => AlbumSongsValueController(albumId: albumId));

    useEffect(() {
      valueController.load();
      songsValueController.load();
      return null;
    }, [valueController, songsValueController]);

    return DefaultValueControllerBuilder(
      valueController: valueController,
      valueBuilder: (context, album) => Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar.large(
              surfaceTintColor: Colors.transparent,
              title: Text(album.name),
              centerTitle: false,
            ),
            DefaultListValueControllerBuilder(
              valueController: songsValueController,
              itemExtent: 64.0,
              valueBuilder: (context, i, song) {
                return SongTile(
                  onTap: () => di.player.play(song),
                  song: song,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
