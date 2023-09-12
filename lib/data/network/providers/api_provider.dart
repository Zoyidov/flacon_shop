import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../utils/constants.dart';
import '../../model/product_model.dart';
import '../../model/universal_model.dart';

class ApiProvider {

  //------------------------------Product provider------------------------------

  Future<UniversalResponse> getAllProducts() async {
    Uri url = Uri.parse('$baseUrl/products');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return UniversalResponse(
          data: (jsonDecode(response.body) as List?)
                  ?.map((e) => ProductModel.fromJson(e))
                  .toList() ??
              [],
        );
      }
      return UniversalResponse(error: 'Error: Status code not equal to 200');
    } catch (e) {
      return UniversalResponse(error: e.toString());
    }
  }

  Future<UniversalResponse> getProductsByLimit({required int limit}) async {
    Uri url = Uri.parse('$baseUrl/products?limit=$limit');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return UniversalResponse(
          data: (jsonDecode(response.body) as List?)
                  ?.map((e) => ProductModel.fromJson(e))
                  .toList() ??
              [],
        );
      }
      return UniversalResponse(error: 'Error: Status code not equal to 200');
    } catch (e) {
      return UniversalResponse(error: e.toString());
    }
  }

  Future<UniversalResponse> getProductById({required int id}) async {
    Uri url = Uri.parse('$baseUrl/products/$id');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return UniversalResponse(
            data: ProductModel.fromJson(jsonDecode(response.body)));
      } else if (response.statusCode != 200) {
        return UniversalResponse(error: 'Error: Status code not equal to 200');
      }

      return UniversalResponse(error: 'Error: Product not found');
    } catch (e) {
      return UniversalResponse(error: e.toString());
    }
  }

  Future<UniversalResponse> addProduct(ProductModel product) async {
    Uri url = Uri.parse('$baseUrl/products');
    try {
      final response = await http.post(
        url,
        body: jsonEncode(product.toJson()),
      );

      if (response.statusCode == 200) {
        return UniversalResponse(
          data: ProductModel.fromJson(
            jsonDecode(response.body),
          ),
        );
      }
      return UniversalResponse(error: 'Error: Status code not equal to 200');
    } catch (e) {
      return UniversalResponse(error: e.toString());
    }
  }

  Future<UniversalResponse> productUpdate(ProductModel product) async {
    Uri url = Uri.parse('$baseUrl/products/${product.id}');
    try {
      final response = await http.put(
        url,
        body: product.toJson(),
      );
      if (response.statusCode == 200) {
        return UniversalResponse(
            data: ProductModel.fromJson(jsonDecode(response.body)));
      }
      return UniversalResponse(error: 'Error: Status code not equal to 200');
    } catch (e) {
      return UniversalResponse(error: e.toString());
    }
  }

  Future<UniversalResponse> deleteProduct(int id) async {
    Uri url = Uri.parse('$baseUrl/products/$id');
    try {
      final response = await http.delete(url);
      if (response.statusCode == 200) {
        return UniversalResponse(
            data: ProductModel.fromJson(jsonDecode(response.body)));
      }
      return UniversalResponse(error: 'Error: Status code not equal to 200');
    } catch (e) {
      return UniversalResponse(error: e.toString());
    }
  }

  Future<UniversalResponse> sortProducts(String sort) async {
    Uri url = Uri.parse('$baseUrl/products?sort=$sort');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return UniversalResponse(
          data: (jsonDecode(response.body) as List?)
                  ?.map((e) => ProductModel.fromJson(e))
                  .toList() ??
              [],
        );
      }
      return UniversalResponse(error: 'Error: Status code not equal to 200');
    } catch (e) {
      return UniversalResponse(error: e.toString());
    }
  }

  Future<UniversalResponse> getProductsByCategory(
      {required String category}) async {
    Uri url = Uri.parse(
      category.isNotEmpty
          ? '$baseUrl/products/category/$category'
          : "$baseUrl/products",
    );
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return UniversalResponse(
            data: (jsonDecode(response.body) as List?)
                    ?.map((e) => ProductModel.fromJson(e))
                    .toList() ??
                []);
      }
      return UniversalResponse(error: 'Error: Status code not equal to 200');
    } catch (e) {
      return UniversalResponse(error: e.toString());
    }
  }


  //------------------------------Category provider-----------------------------

  Future<UniversalResponse> getAllCategories() async {
    Uri url = Uri.parse('$baseUrl/products/categories');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return UniversalResponse(
          data: (jsonDecode(response.body) as List?)
              ?.map((e) => e as String)
              .toList(),
        );
      }
      return UniversalResponse(error: 'Error: Status code not equal to 200');
    } catch (e) {
      return UniversalResponse(error: e.toString());
    }
  }
}
