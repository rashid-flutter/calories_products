import 'package:dio/dio.dart';
import 'package:food/models/product_model.dart';

class ApiService {
  final Dio _dio = Dio();

  Future<Products> fetchProducts() async {
    try {
      final response = await _dio
          .get('https://run.mocky.io/v3/18e8dae4-f39d-46bc-9cf6-9f8b97c32f9c');
      if (response.statusCode == 200) {
        return Products.fromJson(response.data);
      } else {
        throw Exception('Failed to load products');
      }
    } on DioException catch (_) {
      rethrow;
    }
  }
}
