import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:musique/features/song/song_tile.dart';
import 'package:musique/imports.dart';

class PlayerBar extends HookWidget {
  const PlayerBar({super.key});

  @override
  Widget build(BuildContext context) {
    final currentSong = useSignalValue(() => di.player.currentSong);
    final isPlaying = useSignalValue(() => di.player.isPlaying);
    final duration = useSignalValue(() => di.player.duration);
    final position = useSignalValue(() => di.player.currentPosition);

    return Container(
      height: 72.0,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Transform.translate(
              offset: Offset(0.0, -2.0),
              child: ExpressiveProgressBar(
                progress: duration != Duration.zero ? position.inMilliseconds / duration.inMilliseconds : 0.0,
                isActive: isPlaying,
              ),
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
                if (isPlaying)
                  IconButton(
                    onPressed: di.player.pause,
                    iconSize: 48.0,
                    icon: Icon(Symbols.pause_rounded, fill: 1.0),
                  )
                else
                  IconButton(
                    onPressed: di.player.resume,
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
