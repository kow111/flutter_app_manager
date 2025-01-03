import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  final String _baseUrl = 'https://shop-2nd-hand.onrender.com/api/v1';
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Future<http.Response> getPublic(String endpoint) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    try {
      return await http.get(url, headers: _defaultHeaders);
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

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

  Future<String?> _getToken() async {
    return await _secureStorage.read(key: 'token');
  }

  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await _getToken();
    return {
      ..._defaultHeaders,
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<http.Response> getPrivate(String endpoint) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    try {
      final headers = await _getAuthHeaders();
      return await http.get(url, headers: headers);
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

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

  Future<http.Response> deletePrivate(String endpoint) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    try {
      final headers = await _getAuthHeaders();
      return await http.delete(url, headers: headers);
    } catch (e) {
      throw Exception('Failed to delete data: $e');
    }
  }

  Future<http.Response> uploadImage(File imageFile) async {
    final url = Uri.parse("$_baseUrl/upload");
    try {
      final headers = await _getAuthHeaders();

      var request = http.MultipartRequest('POST', url);
      request.headers.addAll(headers);

      // Thêm file ảnh
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
        ),
      );
      var response = await request.send();
      return await http.Response.fromStream(response);
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }
}
