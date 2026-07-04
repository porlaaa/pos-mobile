import 'package:flutter/material.dart';
import 'package:pos_mobile/core/api_client.dart';
import 'package:pos_mobile/core/constants.dart';
import 'package:pos_mobile/screens/dashboard_screen.dart';
import 'package:pos_mobile/screens/home_screen.dart';
import 'package:pos_mobile/screens/menu_screen.dart';
import 'package:pos_mobile/screens/orders_screen.dart';
import 'package:pos_mobile/screens/tables_screen.dart';

class ShellScreen extends StatefulWidget {
  const ShellScreen({
    super.key,
    required this.api,
    required this.user,
    required this.onLogout,
  });

  final Api api;
  final Map<String, dynamic> user;
  final Future<void> Function() onLogout;

  @override
  State<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends State<ShellScreen> {
  var index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(api: widget.api, user: widget.user),
      TablesScreen(api: widget.api, isAdmin: widget.user['role'] == 'Admin'),
      OrdersScreen(api: widget.api),
      MenuScreen(api: widget.api),
      DashboardScreen(api: widget.api),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: dark,
        title: Text(['Home', 'Tables', 'Orders', 'Menu', 'Dashboard'][index]),
        actions: [
          TextButton.icon(
            onPressed: widget.onLogout,
            icon: const Icon(Icons.logout),
            label: Text(widget.user['name']?.toString() ?? 'Logout'),
          ),
        ],
      ),
      body: pages[index],
      bottomNavigationBar: NavigationBar(
        backgroundColor: dark,
        selectedIndex: index,
        onDestinationSelected: (v) => setState(() => index = v),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(
            icon: Icon(Icons.table_restaurant_outlined),
            label: 'Tables',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            label: 'Orders',
          ),
          NavigationDestination(
            icon: Icon(Icons.restaurant_outlined),
            label: 'Menu',
          ),
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            label: 'Dash',
          ),
        ],
      ),
    );
  }
}
