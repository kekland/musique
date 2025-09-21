import 'package:flutter/material.dart';
import 'package:flutter_resizable_container/flutter_resizable_container.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:musique/features/home/home_page_drawer.dart';
import 'package:musique/features/player/player_bar.dart';
import 'package:musique/features/song/song_tile.dart';
import 'package:musique/imports.dart';
import 'package:window_manager/window_manager.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          DragToMoveArea(
            child: Container(
              height: 56.0,
              // child: Center(
              //   child: SizedBox(
              //     width: 360.0,
              //     height: 40.0,
              //     child: TextField(
              //       decoration: InputDecoration(
              //         filled: true,
              //         fillColor: context.colorScheme.surfaceContainer,
              //         prefixIcon: Icon(Symbols.search_rounded),
              //         hintText: 'Search...',
              //         contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
              //         border: OutlineInputBorder(
              //           borderRadius: BorderRadius.circular(16.0),
              //           borderSide: BorderSide.none,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ),
          ),
          Expanded(
            child: ResizableContainer(
              direction: Axis.horizontal,
              children: [
                ResizableChild(
                  size: ResizableSize.pixels(256.0, min: 64.0, max: 512.0),
                  divider: ResizableDivider(thickness: 8.0, color: Colors.transparent),
                  child: HomePageDrawer(),
                ),
                ResizableChild(
                  size: ResizableSize.expand(min: 256.0),
                  child: Material(
                    color: context.colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(16.0),
                    clipBehavior: Clip.antiAlias,
                    child: CustomScrollView(
                      slivers: [
                        SliverAppBar.large(
                          backgroundColor: context.colorScheme.surfaceContainerLow,
                          surfaceTintColor: Colors.transparent,
                          title: Text('All songs'),
                          centerTitle: false,
                        ),
                        MuDefaultListValueControllerBuilder(
                          valueController: di.library.allSongsController,
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
                ),
              ],
            ),
          ),
          PlayerBar(),
        ],
      ),
    );
  }
}
