import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:musique/features/album/album_tile.dart';
import 'package:musique/imports.dart';

class HomePageDrawer extends HookWidget {
  const HomePageDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              ListTile(
                onTap: () {},
                leading: Container(
                  width: 48.0,
                  height: 48.0,
                  decoration: BoxDecoration(
                    color: context.colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Icon(Symbols.home_rounded, fill: 0.0),
                ),
                title: Text('Home'),
              ),
              const SizedBox(height: 12.0),
              ListTile(
                onTap: () {},
                leading: Container(
                  width: 48.0,
                  height: 48.0,
                  decoration: BoxDecoration(
                    color: context.colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Icon(Symbols.album_rounded, fill: 0.0),
                ),
                title: Text('All songs'),
              ),
              const SizedBox(height: 12.0),
              ListTile(
                onTap: () {},
                leading: Container(
                  width: 48.0,
                  height: 48.0,
                  decoration: BoxDecoration(
                    color: context.colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Icon(Symbols.settings_rounded, fill: 0.0),
                ),
                title: Text('Settings'),
              ),
              const SizedBox(height: 8.0),
              Divider(),
            ],
          ),
        ),
        DefaultListValueControllerBuilder(
          valueController: di.library.allAlbumsController,
          valueBuilder: (context, i, album) {
            return AlbumTile(
              onTap: () => context.router.push(AlbumRoute(albumId: album.id)),
              album: album,
            );
          },
        ),
      ],
    );
  }
}
