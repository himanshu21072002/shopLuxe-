import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shop_with_me/core/api.dart';
import 'package:shop_with_me/data/models/order/order_model.dart';

class OrderRepository {
  final _api = Api();

  Future<List<OrderModel>> fetchOrderForUser(String userId) async {
    try {
      Response response = await _api.sendRequest.get("/order/$userId");
      ApiResponse apiResponse = ApiResponse.fromResponse(response);
      if (!apiResponse.success) {
        throw apiResponse.message.toString();
      }
      // if successful then convert data to model
      return (apiResponse.data as List<dynamic>)
          .map((json) => OrderModel.fromJson(json))
          .toList();
    } catch (ex) {
      rethrow;
    }
  }

  Future<OrderModel> createOrder(OrderModel orderModel) async {
    try {
      Response response = await _api.sendRequest
          .post("/order/", data: jsonEncode(orderModel.toJson()));
      ApiResponse apiResponse = ApiResponse.fromResponse(response);
      if (!apiResponse.success) {
        throw apiResponse.message.toString();
      }
      // if successful then convert data to model
      return OrderModel.fromJson(apiResponse.data);
    } catch (ex) {
      rethrow;
    }
  }
}
