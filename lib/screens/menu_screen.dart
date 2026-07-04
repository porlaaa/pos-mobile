import 'package:flutter/material.dart';
import 'package:pos_mobile/core/api_client.dart';
import 'package:pos_mobile/core/constants.dart';
import 'package:pos_mobile/core/formatters.dart';
import 'package:pos_mobile/utils/dialog_helpers.dart';
import 'package:pos_mobile/utils/value_helpers.dart';
import 'package:pos_mobile/widgets/app_card.dart';
import 'package:pos_mobile/widgets/empty_state.dart';
import 'package:pos_mobile/widgets/future_box.dart';
import 'package:pos_mobile/widgets/heading.dart';
import 'package:pos_mobile/widgets/metric.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key, required this.api});

  final Api api;

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late Future<List<dynamic>> future = Future.wait([
    widget.api.menus(),
    widget.api.items(),
    widget.api.tables(),
  ]);
  final customer = TextEditingController();
  final phone = TextEditingController();
  final guests = TextEditingController(text: '1');
  final cart = <String, int>{};
  int? table;
  String? category;

  @override
  void dispose() {
    customer.dispose();
    phone.dispose();
    guests.dispose();
    super.dispose();
  }

  void reload() => setState(
    () =>
        future = Future.wait([
          widget.api.menus(),
          widget.api.items(),
          widget.api.tables(),
        ]),
  );

  Future<void> placeOrder(List<Map<String, dynamic>> items) async {
    if (cart.isEmpty ||
        table == null ||
        customer.text.trim().isEmpty ||
        phone.text.trim().isEmpty) {
      toast(context, 'Customer, table, and cart are required', error: true);
      return;
    }
    try {
      await widget.api.post('/api/order/', {
        'customerDetails': {
          'name': customer.text.trim(),
          'phone': phone.text.trim(),
          'guests': int.tryParse(guests.text) ?? 1,
        },
        'table': table,
        'items':
            cart.entries
                .map((e) => {'itemId': e.key, 'quantity': e.value})
                .toList(),
      });
      setState(cart.clear);
      reload();
      if (mounted) toast(context, 'Order created');
    } catch (e) {
      if (mounted) toast(context, e.toString(), error: true);
    }
  }

  @override
  Widget build(BuildContext context) => FutureBox<List<dynamic>>(
    future: future,
    onRetry: reload,
    builder: (data) {
      final menus = List<Map<String, dynamic>>.from(data[0]);
      final items = List<Map<String, dynamic>>.from(data[1]);
      final tables = List<Map<String, dynamic>>.from(data[2]);
      category ??= menus.isEmpty ? null : menus.first['_id']?.toString();
      final menuItems =
          category == null
              ? items
              : items
                  .where((i) => i['category']?.toString() == category)
                  .toList();
      final cartItems = items.where((i) => cart.containsKey(i['_id'])).toList();
      final total = cartItems.fold<double>(
        0,
        (s, i) => s + numVal(i['price']) * (cart[i['_id']] ?? 0),
      );

      return ListView(
        padding: pad,
        children: [
          const Heading('Customer Info'),
          gap,
          DropdownButtonFormField<int>(
            value: table,
            decoration: const InputDecoration(labelText: 'Table'),
            items:
                tables
                    .map(
                      (t) => DropdownMenuItem(
                        value: intVal(t['_id']),
                        child: Text('Table ${t['tableNo']} - ${t['status']}'),
                      ),
                    )
                    .toList(),
            onChanged: (v) => setState(() => table = v),
          ),
          gap,
          TextField(
            controller: customer,
            decoration: const InputDecoration(labelText: 'Customer Name'),
          ),
          gap,
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: phone,
                  decoration: const InputDecoration(labelText: 'Phone'),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 92,
                child: TextField(
                  controller: guests,
                  decoration: const InputDecoration(labelText: 'Guests'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:
                  menus
                      .map(
                        (m) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(m['name']?.toString() ?? 'Menu'),
                            selected: category == m['_id']?.toString(),
                            onSelected:
                                (_) => setState(
                                  () => category = m['_id']?.toString(),
                                ),
                          ),
                        ),
                      )
                      .toList(),
            ),
          ),
          const SizedBox(height: 10),
          ...menuItems.map(
            (i) => AppCard(
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: dark,
                  child: Icon(Icons.restaurant, color: accent),
                ),
                title: Text(i['name']?.toString() ?? 'Item'),
                subtitle: Text(money.format(numVal(i['price']))),
                trailing: IconButton(
                  icon: const Icon(Icons.add_circle, color: accent),
                  onPressed:
                      () => setState(
                        () => cart[i['_id']] = (cart[i['_id']] ?? 0) + 1,
                      ),
                ),
              ),
            ),
          ),
          const Heading('Cart'),
          if (cartItems.isEmpty)
            const EmptyState('No items selected')
          else
            ...cartItems.map(
              (i) => ListTile(
                title: Text(i['name']?.toString() ?? 'Item'),
                subtitle: Text(
                  '${cart[i['_id']]} x ${money.format(numVal(i['price']))}',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed:
                      () => setState(() {
                        final id = i['_id'];
                        final qty = (cart[id] ?? 0) - 1;
                        if (qty <= 0) {
                          cart.remove(id);
                        } else {
                          cart[id] = qty;
                        }
                      }),
                ),
              ),
            ),
          Metric('Total', money.format(total * 1.07), Icons.receipt_long),
          FilledButton.icon(
            onPressed: () => placeOrder(items),
            icon: const Icon(Icons.send),
            label: const Text('Place Order'),
          ),
        ],
      );
    },
  );
}
