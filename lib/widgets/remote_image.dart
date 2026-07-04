import 'package:flutter/material.dart';
import 'package:pos_mobile/core/constants.dart';

class RemoteImage extends StatelessWidget {
  const RemoteImage({super.key, required this.url, required this.size});

  final String? url;
  final double size;

  @override
  Widget build(BuildContext context) {
    final cleanUrl = url?.trim() ?? '';
    final valid =
        cleanUrl.startsWith('http://') || cleanUrl.startsWith('https://');
    if (!valid) {
      return fallback;
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(size / 2),
      child: Image.network(
        cleanUrl,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => fallback,
      ),
    );
  }

  Widget get fallback => CircleAvatar(
    radius: size / 2,
    backgroundColor: dark,
    child: Icon(Icons.restaurant, color: accent, size: size * 0.55),
  );
}
