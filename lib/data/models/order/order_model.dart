import 'package:shop_with_me/data/models/cart/cart_item_model.dart';
import 'package:shop_with_me/data/models/user/user_model.dart';

class OrderModel {
  String? sId;
  UserModel? user;
  List<CartItemModel>? items;
  String? status;
  double? totalAmount;
  String? razorPayOrderId;
  DateTime? updatedOn;
  DateTime? createdOn;

  OrderModel(
      {this.sId,
      this.status,
      this.updatedOn,
      this.createdOn,
      this.items,
      this.user,
      this.totalAmount,
      this.razorPayOrderId});

  OrderModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = UserModel.fromJson(json['user']);
    items = (json['items'] as List<dynamic>)
        .map((item) => CartItemModel.fromJson(item))
        .toList();
    status = json['status'];
    razorPayOrderId = json["razorPayOrderId"];
    totalAmount = double.tryParse(json["totalAmount"].toString());
    updatedOn = DateTime.tryParse(json['updatedOn']);
    createdOn = DateTime.tryParse(json['createdOn']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['user'] = user!.toJson();
    data['items'] =
        items!.map((item) => item.toJson(objectMode: true)).toList();
    data['status'] = status;
    data["razorPayOrderId"] = razorPayOrderId;
    data["totalAmount"] = totalAmount;
    data['updatedOn'] = updatedOn?.toIso8601String();
    data['createdOn'] = createdOn?.toIso8601String();

    return data;
  }
}
