import 'package:flutter/material.dart';
import 'package:pos_mobile/core/constants.dart';

class AppCard extends StatelessWidget {
  const AppCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Card(
    color: card,
    margin: const EdgeInsets.only(bottom: 10),
    child: Padding(padding: const EdgeInsets.all(12), child: child),
  );
}
