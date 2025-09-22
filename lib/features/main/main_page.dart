import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_resizable_container/flutter_resizable_container.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:musique/features/home/home_page_drawer.dart';
import 'package:musique/features/player/player_bar.dart';
import 'package:musique/features/queue/queue_widget.dart';
import 'package:musique/imports.dart';
import 'package:window_manager/window_manager.dart';

@RoutePage()
class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        if (width >= 800) {
          return const _MainPageDesktop();
        } else {
          return const _MainPageMobile();
        }
      },
    );
  }
}

class _MainPageDesktop extends StatelessWidget {
  const _MainPageDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surfaceDim,
      body: Column(
        children: [
          DragToMoveArea(
            child: Container(height: 56.0),
          ),
          Expanded(
            child: ResizableContainer(
              direction: Axis.horizontal,
              children: [
                ResizableChild(
                  size: ResizableSize.pixels(256.0, min: 72.0, max: 512.0),
                  divider: ResizableDivider(thickness: 8.0, color: Colors.transparent),
                  child: HomePageDrawer(),
                ),
                ResizableChild(
                  size: ResizableSize.expand(min: 256.0),
                  divider: ResizableDivider(thickness: 8.0, color: Colors.transparent),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Material(
                      borderRadius: BorderRadius.circular(16.0),
                      clipBehavior: Clip.antiAlias,
                      child: AutoRouter(),
                    ),
                  ),
                ),
                ResizableChild(
                  size: ResizableSize.pixels(256.0, min: 72.0, max: 512.0),
                  divider: ResizableDivider(thickness: 8.0, color: Colors.transparent),
                  child: CurrentQueueWidget(),
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

class _MainPageMobile extends StatelessWidget {
  const _MainPageMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AutoRouter(),
    );
  }
}
