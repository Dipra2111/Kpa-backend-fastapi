import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  // Change this to your API base
  static const String baseUrl = 'http://10.0.2.2:8000'; // Android emulator → host machine
  // For real device on same network, use http://<your-ip>:8000

  String? _token;
  String? get token => _token;

  Map<String, String> _headers() => {
        'Content-Type': 'application/json',
        if (_token != null) 'Authorization': 'Bearer $_token',
      };

  Future<void> login({required String phone, required String password}) async {
    final uri = Uri.parse('$baseUrl/api/auth/login');
    final res = await http.post(uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phone, 'password': password}));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      _token = data['token'];
    } else {
      throw Exception('Login failed: ${res.statusCode} ${res.body}');
    }
  }

  // Wheel Specs
  Future<List<dynamic>> listWheelSpecs() async {
    final uri = Uri.parse('$baseUrl/api/forms/wheel-specifications');
    final res = await http.get(uri, headers: _headers());
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as List<dynamic>;
    }
    throw Exception('Failed to load specs: ${res.statusCode}');
  }

  Future<Map<String, dynamic>> upsertWheelSpec(Map<String, dynamic> body) async {
    final uri = Uri.parse('$baseUrl/api/forms/wheel-specifications');
    final res = await http.post(uri, headers: _headers(), body: jsonEncode(body));
    if (res.statusCode == 201 || res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to upsert: ${res.statusCode} ${res.body}');
  }

  // Bogie Checksheet
  Future<Map<String, dynamic>> createBogieChecksheet(Map<String, dynamic> body) async {
    final uri = Uri.parse('$baseUrl/api/forms/bogie-checksheet');
    final res = await http.post(uri, headers: _headers(), body: jsonEncode(body));
    if (res.statusCode == 201) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to create checksheet: ${res.statusCode} ${res.body}');
  }
}
