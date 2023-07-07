import 'package:shop_with_me/data/models/product/product_model.dart';

class CartItemModel {
  ProductModel? product;
  int? quantity;
  String? sId;

  CartItemModel({this.quantity, this.sId,this.product});

  CartItemModel.fromJson(Map<String, dynamic> json) {
    product= ProductModel.fromJson(json['product']);
    quantity = json['quantity'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson({bool objectMode = false}) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product']=(objectMode==false)?product!.sId:product!.toJson();
    data['quantity'] = quantity;
    data['_id'] = sId;
    return data;
  }
}
