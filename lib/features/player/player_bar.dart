import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:musique/features/song/song_tile.dart';
import 'package:musique/imports.dart';

class PlayerBar extends HookWidget {
  const PlayerBar({super.key});

  @override
  Widget build(BuildContext context) {
    final currentSong = useSignalValue(() => di.player.currentSong);

    return Container(
      height: 64.0,
      child: Stack(
        children: [
          Transform.translate(
            offset: Offset(0.0, -2.0),
            child: LinearProgressIndicator(
              value: 0.3,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: currentSong != null ? SongTile(song: currentSong) : SizedBox.shrink(),
              ),
            ],
          ),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Symbols.skip_previous_rounded, fill: 1.0),
                ),
                IconButton(
                  onPressed: () {},
                  iconSize: 48.0,
                  icon: Icon(Symbols.play_arrow_rounded, fill: 1.0),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Symbols.skip_next_rounded, fill: 1.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
