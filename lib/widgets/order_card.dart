import 'package:flutter/material.dart';
import 'package:pos_mobile/core/formatters.dart';
import 'package:pos_mobile/utils/value_helpers.dart';
import 'package:pos_mobile/widgets/app_card.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.order, this.trailing});

  final Map<String, dynamic> order;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final created = DateTime.tryParse(order['createdAt']?.toString() ?? '');
    final details = [
      'Table ${order['table'] ?? 'N/A'}',
      order['orderStatus']?.toString() ?? 'N/A',
      if (created != null) dateFmt.format(created.toLocal()),
    ].join(' - ');

    return AppCard(
      child: ListTile(
        title: Text(
          order['customerDetails']?['name']?.toString() ?? 'Walk-in',
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        subtitle: Text(details),
        trailing:
            trailing ??
            Text(
              money.format(
                numVal(
                  order['bills']?['totalWithTax'] ?? order['bills']?['total'],
                ),
              ),
            ),
      ),
    );
  }
}
