// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i4;
import 'package:flutter/material.dart' as _i5;
import 'package:musique/features/album/album_page.dart' as _i1;
import 'package:musique/features/home/home_page.dart' as _i2;
import 'package:musique/features/main/main_page.dart' as _i3;

/// generated route for
/// [_i1.AlbumPage]
class AlbumRoute extends _i4.PageRouteInfo<AlbumRouteArgs> {
  AlbumRoute({
    _i5.Key? key,
    required int albumId,
    List<_i4.PageRouteInfo>? children,
  }) : super(
         AlbumRoute.name,
         args: AlbumRouteArgs(key: key, albumId: albumId),
         initialChildren: children,
       );

  static const String name = 'AlbumRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AlbumRouteArgs>();
      return _i1.AlbumPage(key: args.key, albumId: args.albumId);
    },
  );
}

class AlbumRouteArgs {
  const AlbumRouteArgs({this.key, required this.albumId});

  final _i5.Key? key;

  final int albumId;

  @override
  String toString() {
    return 'AlbumRouteArgs{key: $key, albumId: $albumId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AlbumRouteArgs) return false;
    return key == other.key && albumId == other.albumId;
  }

  @override
  int get hashCode => key.hashCode ^ albumId.hashCode;
}

/// generated route for
/// [_i2.HomePage]
class HomeRoute extends _i4.PageRouteInfo<void> {
  const HomeRoute({List<_i4.PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      return const _i2.HomePage();
    },
  );
}

/// generated route for
/// [_i3.MainPage]
class MainRoute extends _i4.PageRouteInfo<void> {
  const MainRoute({List<_i4.PageRouteInfo>? children})
    : super(MainRoute.name, initialChildren: children);

  static const String name = 'MainRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      return const _i3.MainPage();
    },
  );
}
