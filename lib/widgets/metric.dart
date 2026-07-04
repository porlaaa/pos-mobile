import 'package:flutter/material.dart';
import 'package:pos_mobile/core/constants.dart';
import 'package:pos_mobile/widgets/app_card.dart';

class Metric extends StatelessWidget {
  const Metric(this.label, this.value, this.icon, {super.key});

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) => AppCard(
    child: Row(
      children: [
        Icon(icon, color: accent, size: 30),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: muted)),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
