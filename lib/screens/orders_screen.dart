import 'package:flutter/material.dart';
import 'package:pos_mobile/core/api_client.dart';
import 'package:pos_mobile/core/constants.dart';
import 'package:pos_mobile/utils/dialog_helpers.dart';
import 'package:pos_mobile/widgets/empty_state.dart';
import 'package:pos_mobile/widgets/future_box.dart';
import 'package:pos_mobile/widgets/order_card.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key, required this.api});

  final Api api;

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late Future<List<Map<String, dynamic>>> future = widget.api.orders();
  var filter = 'All';

  void reload() => setState(() => future = widget.api.orders());

  Future<void> action(Map<String, dynamic> order, String value) async {
    try {
      if (value == 'Cash' || value == 'Online') {
        await widget.api.patch('/api/order/${order['_id']}/payment', {
          'paymentMethod': value,
        });
      } else {
        await widget.api.put('/api/order/${order['_id']}', {
          'orderStatus': value,
        });
      }
      reload();
    } catch (e) {
      if (mounted) toast(context, e.toString(), error: true);
    }
  }

  @override
  Widget build(BuildContext context) => FutureBox(
    future: future,
    onRetry: reload,
    builder: (orders) {
      final visible =
          orders
              .where(
                (o) =>
                    filter == 'All'
                        ? o['orderStatus'] != 'Completed'
                        : o['orderStatus'] == filter,
              )
              .toList();

      return Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: pad,
            child: Row(
              children:
                  ['All', 'In Progress', 'Ready', 'Completed']
                      .map(
                        (s) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(s),
                            selected: filter == s,
                            onSelected: (_) => setState(() => filter = s),
                          ),
                        ),
                      )
                      .toList(),
            ),
          ),
          Expanded(
            child:
                visible.isEmpty
                    ? const EmptyState('No orders available')
                    : ListView(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      children:
                          visible
                              .map(
                                (o) => OrderCard(
                                  order: o,
                                  trailing: PopupMenuButton<String>(
                                    onSelected: (v) => action(o, v),
                                    itemBuilder:
                                        (_) => const [
                                          PopupMenuItem(
                                            value: 'Ready',
                                            child: Text('Mark Ready'),
                                          ),
                                          PopupMenuItem(
                                            value: 'Completed',
                                            child: Text('Mark Completed'),
                                          ),
                                          PopupMenuDivider(),
                                          PopupMenuItem(
                                            value: 'Cash',
                                            child: Text('Paid Cash'),
                                          ),
                                          PopupMenuItem(
                                            value: 'Online',
                                            child: Text('Paid Online'),
                                          ),
                                        ],
                                  ),
                                ),
                              )
                              .toList(),
                    ),
          ),
        ],
      );
    },
  );
}
