import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_with_me/data/models/order/order_model.dart';
import 'package:shop_with_me/data/repositories/order_repository.dart';
import 'package:shop_with_me/logic/services/calculation.dart';

import '../../../data/models/cart/cart_item_model.dart';
import '../cart_cubit/cart_cubit.dart';
import '../user_cubit/user_cubit.dart';
import '../user_cubit/user_state.dart';
import 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final UserCubit _userCubit;
  final CartCubit _cartCubit;
  StreamSubscription? _userSubscription;
  OrderCubit(this._userCubit, this._cartCubit) : super(OrderInitialState()) {
    //initial value
    _handleUserState(_userCubit.state);
    //listening to User Cubit (for future updates)
    _userSubscription = _userCubit.stream.listen(_handleUserState);
  }

  void _handleUserState(UserState userState) {
    if (userState is UserLoggedInState) {
      _initialize(userState.userModel.sId!);
    } else if (userState is UserLoggedOutState) {
      emit(OrderInitialState());
    }
  }

  final _orderRepository = OrderRepository();

  void _initialize(String userId) async {
    emit(OrderLoadingState(state.orders));
    try {
      final orders = await _orderRepository.fetchOrderForUser(userId);
      emit(OrderLoadedState(orders));
    } catch (ex) {
      emit(OrderErrorState(ex.toString(), state.orders));
    }
  }

  Future<OrderModel?> createOrder(
      {required List<CartItemModel> items,
      required String paymentMethod}) async {
    emit(OrderLoadedState(state.orders));
    try {
      if (_userCubit.state is! UserLoggedInState) {
        return null;
      }
      OrderModel newOrder = OrderModel(
          items: items,
          totalAmount: Calculations.cartTotal(items),
          user: (_userCubit.state as UserLoggedInState).userModel,
          status: (paymentMethod == "pay-on-delivery")
              ? "order-placed"
              : "payment-pending");
      final order = await _orderRepository.createOrder(newOrder);
      List<OrderModel> orders = [ order,...state.orders];
      emit(OrderLoadedState(orders));
      _cartCubit.clearCart();

      return order;
    } catch (ex) {
      emit(OrderErrorState(ex.toString(), state.orders));
      return null;
    }
  }
  Future<bool> updateOrder(OrderModel orderModel,String? paymentId,String? signature) async{
    try{
     OrderModel updatedOrder=await  _orderRepository.updateOrder(orderModel, paymentId, signature);
      int index=state.orders.indexOf(updatedOrder);
      if(index==-1) return false;

      List<OrderModel> newList= state.orders;
      newList[index]= updatedOrder;
      emit(OrderLoadedState(newList));
      return true;
    }
    catch(ex){
      emit(OrderErrorState(ex.toString(), state.orders));
      return false;
    }
  
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
