import 'package:flutter/material.dart';

class Heading extends StatelessWidget {
  const Heading(this.value, {super.key});

  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Text(
      value,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
    ),
  );
}
