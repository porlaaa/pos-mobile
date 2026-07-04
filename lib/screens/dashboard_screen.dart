import 'package:flutter/material.dart';
import 'package:pos_mobile/core/api_client.dart';
import 'package:pos_mobile/core/constants.dart';
import 'package:pos_mobile/core/formatters.dart';
import 'package:pos_mobile/utils/value_helpers.dart';
import 'package:pos_mobile/widgets/future_box.dart';
import 'package:pos_mobile/widgets/heading.dart';
import 'package:pos_mobile/widgets/metric.dart';
import 'package:pos_mobile/widgets/order_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, required this.api});

  final Api api;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<List<Map<String, dynamic>>> future = widget.api.orders();

  @override
  Widget build(BuildContext context) => FutureBox(
    future: future,
    onRetry: () => setState(() => future = widget.api.orders()),
    builder: (orders) {
      final total = orders.fold<double>(
        0,
        (s, o) =>
            s + numVal(o['bills']?['totalWithTax'] ?? o['bills']?['total']),
      );
      final ready = orders.where((o) => o['orderStatus'] == 'Ready').length;
      final done = orders.where((o) => o['orderStatus'] == 'Completed').length;

      return ListView(
        padding: pad,
        children: [
          const Text(
            'Manage restaurant performance',
            style: TextStyle(color: muted),
          ),
          const SizedBox(height: 14),
          Metric('Sales Revenue', money.format(total), Icons.bar_chart),
          Metric('Ready Orders', '$ready', Icons.room_service_outlined),
          Metric('Completed Orders', '$done', Icons.check_circle_outline),
          const Heading('Latest Orders'),
          ...orders.take(8).map((o) => OrderCard(order: o)),
        ],
      );
    },
  );
}
