import 'package:flutter/material.dart';
import 'package:pos_mobile/core/constants.dart';

class FutureBox<T> extends StatelessWidget {
  const FutureBox({
    super.key,
    required this.future,
    required this.builder,
    required this.onRetry,
  });

  final Future<T> future;
  final Widget Function(T data) builder;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => FutureBuilder<T>(
    future: future,
    builder: (context, snap) {
      if (snap.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }
      if (snap.hasError) {
        return Center(
          child: Padding(
            padding: pad,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.redAccent,
                  size: 48,
                ),
                gap,
                Text(snap.error.toString(), textAlign: TextAlign.center),
                gap,
                FilledButton(onPressed: onRetry, child: const Text('Retry')),
              ],
            ),
          ),
        );
      }
      return builder(snap.data as T);
    },
  );
}
