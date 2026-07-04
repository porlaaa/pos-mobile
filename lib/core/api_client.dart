import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pos_mobile/core/constants.dart';

class ApiError implements Exception {
  ApiError(this.message);

  final String message;

  @override
  String toString() => message;
}

class Api {
  final _client = http.Client();
  String? _cookie;

  Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    if (_cookie != null) 'Cookie': _cookie!,
  };

  Uri uri(String path) => Uri.parse('$apiBaseUrl$path');

  dynamic decode(http.Response res) {
    final setCookie = res.headers['set-cookie'];
    if (setCookie != null && setCookie.isNotEmpty) {
      _cookie = setCookie.split(';').first;
    }

    final body = res.body.isEmpty ? <String, dynamic>{} : jsonDecode(res.body);
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw ApiError(
        body is Map
            ? body['message']?.toString() ?? 'Request failed'
            : 'Request failed',
      );
    }
    return body;
  }

  Future<dynamic> get(String path) async =>
      decode(await _client.get(uri(path), headers: headers));

  Future<dynamic> post(String path, Map<String, dynamic> data) async => decode(
    await _client.post(uri(path), headers: headers, body: jsonEncode(data)),
  );

  Future<dynamic> put(String path, Map<String, dynamic> data) async => decode(
    await _client.put(uri(path), headers: headers, body: jsonEncode(data)),
  );

  Future<dynamic> patch(String path, Map<String, dynamic> data) async => decode(
    await _client.patch(uri(path), headers: headers, body: jsonEncode(data)),
  );

  Future<dynamic> delete(String path) async =>
      decode(await _client.delete(uri(path), headers: headers));

  Future<Map<String, dynamic>> login(String email, String password) async =>
      Map<String, dynamic>.from(
        (await post('/api/user/login', {
          'email': email,
          'password': password,
        }))['data'],
      );

  Future<void> register(Map<String, dynamic> data) async =>
      post('/api/user/register', data);

  Future<void> logout() async {
    await post('/api/user/logout', {});
    _cookie = null;
  }

  Future<List<Map<String, dynamic>>> tables() async =>
      List<Map<String, dynamic>>.from((await get('/api/table'))['data']);

  Future<List<Map<String, dynamic>>> menus() async =>
      List<Map<String, dynamic>>.from((await get('/api/menu'))['data']);

  Future<List<Map<String, dynamic>>> items() async =>
      List<Map<String, dynamic>>.from((await get('/api/item'))['data']);

  Future<List<Map<String, dynamic>>> orders() async =>
      List<Map<String, dynamic>>.from((await get('/api/order'))['data']);
}
