import 'package:flutter/material.dart';

const apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://10.0.2.2:5000',
);

const bg = Color(0xFF1F1F1F);
const card = Color(0xFF262626);
const dark = Color(0xFF1A1A1A);
const accent = Color(0xFFF6B100);
const muted = Color(0xFFABABAB);

const pad = EdgeInsets.all(16);
const gap = SizedBox(height: 10);
const titleStyle = TextStyle(fontSize: 24, fontWeight: FontWeight.w800);
