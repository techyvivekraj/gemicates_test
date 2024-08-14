import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String _baseUrl = 'https://dummyjson.com/products';

  Future<List<dynamic>> getProducts() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      if (response.statusCode == 200) {
        return json.decode(response.body)['products'];
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('API error: $e');
    }
  }
}
