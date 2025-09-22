import 'package:flutter/material.dart';

class MaterialPageTransitionsBuilder extends FadeForwardsPageTransitionsBuilder {
  const MaterialPageTransitionsBuilder();

  @override
  Duration get transitionDuration => const Duration(milliseconds: 550);
}
