import 'package:flutter/material.dart';
import 'package:pos_mobile/core/api_client.dart';
import 'package:pos_mobile/core/constants.dart';
import 'package:pos_mobile/utils/dialog_helpers.dart';
import 'package:pos_mobile/utils/value_helpers.dart';
import 'package:pos_mobile/widgets/app_card.dart';
import 'package:pos_mobile/widgets/future_box.dart';

class TablesScreen extends StatefulWidget {
  const TablesScreen({super.key, required this.api, required this.isAdmin});

  final Api api;
  final bool isAdmin;

  @override
  State<TablesScreen> createState() => _TablesScreenState();
}

class _TablesScreenState extends State<TablesScreen> {
  late Future<List<Map<String, dynamic>>> future = widget.api.tables();
  var filter = 'All';

  void reload() => setState(() => future = widget.api.tables());

  Future<void> addTable() async {
    final no = TextEditingController();
    final seats = TextEditingController(text: '4');
    try {
      final ok = await formDialog(context, 'Create Table', [
        TextField(
          controller: no,
          decoration: const InputDecoration(labelText: 'Table Number'),
        ),
        gap,
        TextField(
          controller: seats,
          decoration: const InputDecoration(labelText: 'Seats'),
        ),
      ]);
      if (ok != true) return;
      await widget.api.post('/api/table/', {
        'tableNo': int.parse(no.text),
        'seats': int.parse(seats.text),
        'status': 'Available',
      });
      reload();
    } catch (e) {
      if (mounted) toast(context, e.toString(), error: true);
    } finally {
      no.dispose();
      seats.dispose();
    }
  }

  Future<void> deleteTable(Map<String, dynamic> table) async {
    if (table['status'] == 'Booked') {
      toast(context, 'Cannot delete booked table!', error: true);
      return;
    }
    final ok = await confirm(
      context,
      'Delete Table',
      'Delete Table ${table['tableNo']}?',
    );
    if (ok != true) return;
    try {
      await widget.api.delete('/api/table/${table['_id']}');
      reload();
    } catch (e) {
      if (mounted) toast(context, e.toString(), error: true);
    }
  }

  @override
  Widget build(BuildContext context) => FutureBox(
    future: future,
    onRetry: reload,
    builder: (tables) {
      tables.sort(
        (a, b) => intVal(a['tableNo']).compareTo(intVal(b['tableNo'])),
      );
      final visible =
          filter == 'All'
              ? tables
              : tables.where((t) => t['status'] == 'Booked').toList();

      return Column(
        children: [
          Padding(
            padding: pad,
            child: Row(
              children: [
                ChoiceChip(
                  label: const Text('All'),
                  selected: filter == 'All',
                  onSelected: (_) => setState(() => filter = 'All'),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Booked'),
                  selected: filter == 'Booked',
                  onSelected: (_) => setState(() => filter = 'Booked'),
                ),
                const Spacer(),
                if (widget.isAdmin)
                  FilledButton.icon(
                    onPressed: addTable,
                    icon: const Icon(Icons.add),
                    label: const Text('Add'),
                  ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.08,
              ),
              itemCount: visible.length,
              itemBuilder: (_, i) {
                final t = visible[i];
                final booked = t['status'] == 'Booked';
                final name =
                    t['currentOrder']?['customerDetails']?['name']
                        ?.toString() ??
                    'N/A';

                return AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Table ${t['tableNo']}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            booked ? Icons.lock_clock : Icons.check_circle,
                            color:
                                booked ? Colors.redAccent : Colors.greenAccent,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${t['seats']} seats',
                        style: const TextStyle(color: muted),
                      ),
                      Text(
                        booked ? name : 'Available',
                        style: TextStyle(
                          color: booked ? Colors.redAccent : Colors.greenAccent,
                        ),
                      ),
                      const Spacer(),
                      if (widget.isAdmin)
                        Align(
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                            onPressed: () => deleteTable(t),
                            child: const Text('Delete'),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      );
    },
  );
}
