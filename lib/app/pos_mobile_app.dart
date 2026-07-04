import 'package:flutter/material.dart';
import 'package:pos_mobile/core/api_client.dart';
import 'package:pos_mobile/core/constants.dart';
import 'package:pos_mobile/screens/auth_screen.dart';
import 'package:pos_mobile/screens/shell_screen.dart';

class PosMobileApp extends StatefulWidget {
  const PosMobileApp({super.key});

  @override
  State<PosMobileApp> createState() => _PosMobileAppState();
}

class _PosMobileAppState extends State<PosMobileApp> {
  final api = Api();
  Map<String, dynamic>? user;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'POS Mobile',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: bg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: accent,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: dark,
          border: OutlineInputBorder(),
        ),
      ),
      home:
          user == null
              ? AuthScreen(api: api, onLogin: (u) => setState(() => user = u))
              : ShellScreen(
                api: api,
                user: user!,
                onLogout: () async {
                  await api.logout();
                  setState(() => user = null);
                },
              ),
    );
  }
}
