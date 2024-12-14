import 'dart:convert';
import 'package:http/http.dart' as http;

class NetworkService {
  final String baseUrl;

  NetworkService(this.baseUrl);

  Future<dynamic> get(String endpoint, {Map<String, String>? headers}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
      );
      return _processResponse(response);
    } catch (error) {
      throw Exception('GET request error: $error');
    }
  }

  Future<dynamic> post(String endpoint,
      {Map<String, String>? headers, dynamic body}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers ?? {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      return _processResponse(response);
    } catch (error) {
      throw Exception('POST request error: $error');
    }
  }

  Future<dynamic> put(String endpoint,
      {Map<String, String>? headers, dynamic body}) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers ?? {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      return _processResponse(response);
    } catch (error) {
      throw Exception('PUT request error: $error');
    }
  }

  Future<dynamic> delete(String endpoint, {Map<String, String>? headers}) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
      );
      return _processResponse(response);
    } catch (error) {
      throw Exception('DELETE request error: $error');
    }
  }

  // Process HTTP responses
  dynamic _processResponse(http.Response response) {
    final int statusCode = response.statusCode;
    if (statusCode >= 200 && statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception('HTTP error: $statusCode ${response.body}');
    }
  }
}
