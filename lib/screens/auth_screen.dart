import 'package:flutter/material.dart';
import 'package:pos_mobile/core/api_client.dart';
import 'package:pos_mobile/core/constants.dart';
import 'package:pos_mobile/utils/dialog_helpers.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, required this.api, required this.onLogin});

  final Api api;
  final ValueChanged<Map<String, dynamic>> onLogin;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  final name = TextEditingController();
  final phone = TextEditingController();
  var role = 'Waiter';
  var register = false;
  var loading = false;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    name.dispose();
    phone.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    setState(() => loading = true);
    try {
      if (register) {
        await widget.api.register({
          'name': name.text.trim(),
          'phone': phone.text.trim(),
          'email': email.text.trim(),
          'password': password.text,
          'role': role,
        });
      }
      widget.onLogin(await widget.api.login(email.text.trim(), password.text));
    } catch (e) {
      if (mounted) toast(context, e.toString(), error: true);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 34),
            Image.asset('assets/images/logo.png', height: 76),
            const Center(
              child: Text(
                'Restro',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(height: 34),
            Text(
              register ? 'Employee Registration' : 'Employee Login',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: accent,
                fontSize: 28,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 22),
            if (register) ...[
              TextField(
                controller: name,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              gap,
              TextField(
                controller: phone,
                decoration: const InputDecoration(labelText: 'Phone'),
              ),
              gap,
              DropdownButtonFormField(
                value: role,
                decoration: const InputDecoration(labelText: 'Role'),
                items:
                    ['Waiter', 'Cashier', 'Admin']
                        .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                        .toList(),
                onChanged: (v) => setState(() => role = v ?? 'Waiter'),
              ),
              gap,
            ],
            TextField(
              controller: email,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            gap,
            TextField(
              controller: password,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: loading ? null : submit,
              style: FilledButton.styleFrom(
                backgroundColor: accent,
                foregroundColor: Colors.black,
              ),
              child: Text(register ? 'Sign up' : 'Sign in'),
            ),
            TextButton(
              onPressed: () => setState(() => register = !register),
              child: Text(
                register
                    ? 'Already have an account? Sign in'
                    : 'Do not have an account? Sign up',
              ),
            ),
            const Text(
              'Default API: $apiBaseUrl',
              textAlign: TextAlign.center,
              style: TextStyle(color: muted, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
