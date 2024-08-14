import 'package:gemicates/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import '../models/product_model.dart';

class ProductController {
  Future<List<Product>> fetchProducts() async {
    try {
      final response =
          await http.get(Uri.parse('https://dummyjson.com/products'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body)['products'];
        return data.map((product) => Product.fromJson(product)).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }

  Future<bool> fetchRemoteConfig() async {
    final remoteConfig = FirebaseRemoteConfig.instance;

    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ));

    try {
      await remoteConfig.fetchAndActivate();
    } catch (e) {
      print('Fetch throttled: $e');
    }

    return remoteConfig.getBool(remoteConfigKeyShowDiscountedPrice);
  }
}
