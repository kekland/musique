import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:musique/app/router.dart';
import 'package:musique/imports.dart';

class MusiqueApp extends StatefulWidget {
  const MusiqueApp({super.key});

  @override
  State<MusiqueApp> createState() => _MusiqueAppState();
}

class _MusiqueAppState extends State<MusiqueApp> {
  late final AppRouter router;

  @override
  void initState() {
    super.initState();
    router = AppRouter(defaultRouteType: RouteType.material());
  }

  @override
  void dispose() {
    router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.dark,
      dynamicSchemeVariant: DynamicSchemeVariant.vibrant,
    );

    colorScheme = colorScheme.copyWith(
      surface: colorScheme.surfaceContainerLow,
    );

    return MaterialApp(
      title: 'musique',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: colorScheme,
        appBarTheme: AppBarTheme(
          centerTitle: false,
          backgroundColor: colorScheme.surfaceContainerLow,
          surfaceTintColor: Colors.transparent,
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: MaterialPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      home: Router.withConfig(
        config: router.config(),
      ),
    );
  }
}
