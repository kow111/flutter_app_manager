import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  final String _baseUrl =
      'http://localhost:3000/api/v1'; // Thay URL phù hợp với API
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  // Headers chung
  Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Gọi API GET công khai
  Future<http.Response> getPublic(String endpoint) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    try {
      return await http.get(url, headers: _defaultHeaders);
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  // Gọi API POST công khai
  Future<http.Response> postPublic(
      String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    try {
      return await http.post(
        url,
        headers: _defaultHeaders,
        body: jsonEncode(data),
      );
    } catch (e) {
      throw Exception('Failed to post data: $e');
    }
  }

  // Lấy token từ secure storage
  Future<String?> _getToken() async {
    return await _secureStorage.read(key: 'token');
  }

  // Headers có token cho các API bảo mật
  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await _getToken();
    return {
      ..._defaultHeaders,
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Gọi API GET bảo mật
  Future<http.Response> getPrivate(String endpoint) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    try {
      final headers = await _getAuthHeaders();
      return await http.get(url, headers: headers);
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  // Gọi API POST bảo mật
  Future<http.Response> postPrivate(
      String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    try {
      final headers = await _getAuthHeaders();
      return await http.post(
        url,
        headers: headers,
        body: jsonEncode(data),
      );
    } catch (e) {
      throw Exception('Failed to post data: $e');
    }
  }

  // Gọi API PUT bảo mật
  Future<http.Response> putPrivate(
      String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    try {
      final headers = await _getAuthHeaders();
      return await http.put(
        url,
        headers: headers,
        body: jsonEncode(data),
      );
    } catch (e) {
      throw Exception('Failed to put data: $e');
    }
  }

  // Gọi API DELETE bảo mật
  Future<http.Response> deletePrivate(String endpoint) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    try {
      final headers = await _getAuthHeaders();
      return await http.delete(url, headers: headers);
    } catch (e) {
      throw Exception('Failed to delete data: $e');
    }
  }
}
