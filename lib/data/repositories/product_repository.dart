import 'package:dio/dio.dart';
import 'package:shop_with_me/core/api.dart';
import '../models/product/product_model.dart';

class ProductRepository {
  final _api = Api();

  Future<List<ProductModel>> fetchAllProducts() async {
    try {
      Response response = await _api.sendRequest.get("/product/");
      ApiResponse apiResponse = ApiResponse.fromResponse(response);
      if (!apiResponse.success) {
        throw apiResponse.message.toString();
      }
      // if successful then convert data to model
      return (apiResponse.data as List<dynamic>).map((json) =>ProductModel.fromJson(json)).toList();
    } catch (ex) {
      rethrow;
    }
  }
  Future<List<ProductModel>> fetchProductsByCategory(String categoryId) async {
    try {
      Response response = await _api.sendRequest.get("/product/category/$categoryId");
      ApiResponse apiResponse = ApiResponse.fromResponse(response);
      if (!apiResponse.success) {
        throw apiResponse.message.toString();
      }
      // if successful then convert data to model
      return (apiResponse.data as List<dynamic>).map((json) =>ProductModel.fromJson(json)).toList();
    } catch (ex) {
      rethrow;
    }
  }

}
