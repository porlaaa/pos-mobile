import 'package:flutter/material.dart';
import 'package:pos_mobile/core/constants.dart';

class EmptyState extends StatelessWidget {
  const EmptyState(this.value, {super.key});

  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: pad,
    child: Center(child: Text(value, style: const TextStyle(color: muted))),
  );
}
