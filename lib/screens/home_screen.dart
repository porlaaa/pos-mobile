import 'package:flutter/material.dart';
import 'package:pos_mobile/core/api_client.dart';
import 'package:pos_mobile/core/constants.dart';
import 'package:pos_mobile/core/formatters.dart';
import 'package:pos_mobile/utils/value_helpers.dart';
import 'package:pos_mobile/widgets/empty_state.dart';
import 'package:pos_mobile/widgets/future_box.dart';
import 'package:pos_mobile/widgets/heading.dart';
import 'package:pos_mobile/widgets/metric.dart';
import 'package:pos_mobile/widgets/order_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.api, required this.user});

  final Api api;
  final Map<String, dynamic> user;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Map<String, dynamic>>> future = widget.api.orders();

  @override
  Widget build(BuildContext context) => FutureBox(
    future: future,
    onRetry: () => setState(() => future = widget.api.orders()),
    builder: (orders) {
      final total = orders.fold<double>(
        0,
        (s, o) => s + numVal(o['bills']?['total']),
      );
      final running =
          orders.where((o) => o['orderStatus'] == 'In Progress').length;

      return ListView(
        padding: pad,
        children: [
          Text(
            'Good ${greeting()}, ${widget.user['name'] ?? 'User'}',
            style: titleStyle,
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Metric(
                  'Total Earnings',
                  money.format(total),
                  Icons.payments_outlined,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Metric('In Progress', '$running', Icons.timelapse),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Heading('Recent Orders'),
          if (orders.isEmpty)
            const EmptyState('No orders available')
          else
            ...orders.take(6).map((o) => OrderCard(order: o)),
        ],
      );
    },
  );
}
