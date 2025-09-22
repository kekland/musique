import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_resizable_container/flutter_resizable_container.dart';
import 'package:musique/features/home/home_page_drawer.dart';
import 'package:musique/features/player/player_bar.dart';
import 'package:musique/features/queue/queue_widget.dart';
import 'package:musique/features/song/song_tile.dart';
import 'package:musique/imports.dart';
import 'package:window_manager/window_manager.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar.large(
          title: Text('All songs'),
          centerTitle: false,
        ),
        DefaultListValueControllerBuilder(
          valueController: di.library.allSongsController,
          itemExtent: 64.0,
          valueBuilder: (context, i, song) {
            return SongTile(
              onTap: () => di.player.play(song),
              song: song,
            );
          },
        ),
      ],
    );
  }
}
