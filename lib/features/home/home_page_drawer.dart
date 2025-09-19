import 'package:flutter/material.dart';

class HomePageDrawer extends StatelessWidget {
  const HomePageDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text('All songs'),
        ),
        ListTile(
          title: Text('Albums'),
        ),
      ],
    );
  }
}
