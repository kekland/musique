import 'package:flutter/material.dart';
import 'package:musique/features/home/home_page.dart';

class MusiqueApp extends StatelessWidget {
  const MusiqueApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'musique',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
          dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
        ),
      ),
      home: HomePage(),
    );
  }
}
