import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shop_with_me/data/models/order/order_model.dart';

class RazorPayServices {
  static final _instance = Razorpay();

  static Future<void> checkoutOrder(OrderModel orderModel,
      {required Function(PaymentSuccessResponse) onSuccess,
      required Function(PaymentFailureResponse) onFailure}) async {
    var options = {
      'key': 'rzp_test_Gct8dfopKgn5wA',
      'order_id': "${orderModel.razorPayOrderId}",
      'name': 'ShopLuxe',
      'description': '${orderModel.sId}',
      'prefill': {
        'contact': '${orderModel.user?.phoneNumber}',
        'email': '${orderModel.user?.email}'
      }
    };
    _instance.on(
        Razorpay.EVENT_PAYMENT_SUCCESS, (PaymentSuccessResponse response) {
          onSuccess(response);
          _instance.clear();
    });
    _instance.on(
        Razorpay.EVENT_PAYMENT_ERROR, (PaymentFailureResponse response) {
          onFailure(response);
          _instance.clear();
    });

    _instance.open(options);
  }
}
