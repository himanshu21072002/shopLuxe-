import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_with_me/data/models/cart/cart_item_model.dart';
import 'package:shop_with_me/data/models/product/product_model.dart';
import 'package:shop_with_me/data/repositories/cart_repository.dart';
import 'package:shop_with_me/logic/cubits/cart_cubit/cart_state.dart';
import 'package:shop_with_me/logic/cubits/user_cubit/user_cubit.dart';
import 'package:shop_with_me/logic/cubits/user_cubit/user_state.dart';

class CartCubit extends Cubit<CartState> {
  final UserCubit _userCubit;
  StreamSubscription? _userSubscription;
  CartCubit(this._userCubit) : super(CartInitialState()) {
    //initial value
    _handleUserState(_userCubit.state);
    //listening to User Cubit (for future updates)
    _userSubscription = _userCubit.stream.listen(_handleUserState);
  }

  void _handleUserState(UserState userState) {
    if (userState is UserLoggedInState) {
      _initialize(userState.userModel.sId!);
    } else if (userState is UserLoggedOutState) {
      emit(CartInitialState());
    }
  }

  final _cartRepository = CartRepository();
  void sortAndLoad(List<CartItemModel> items) {
    items.sort((a, b) => b.product!.title!.compareTo(a.product!.title!));
    emit(CartLoadedState(items));
  }

  void _initialize(String userId) async {
    emit(CartLoadingState(state.items));
    try {
      final items = await _cartRepository.fetchCartForUser(userId);
      sortAndLoad(items);
    } catch (ex) {
      emit(CartErrorState(ex.toString(), state.items));
    }
  }

  void addToCart(ProductModel product, int quantity) async {
    emit(CartLoadingState(state.items));
    try {
      if (_userCubit.state is UserLoggedInState) {
        UserLoggedInState userState = _userCubit.state as UserLoggedInState;
        CartItemModel newItem =
            CartItemModel(product: product, quantity: quantity);
        final items =
            await _cartRepository.addToCart(newItem, userState.userModel.sId!);
        sortAndLoad(items);
      } else {
        throw "An error occurred while adding the item!";
      }
    } catch (ex) {
      emit(CartErrorState(ex.toString(), state.items));
    }
  }

  void removeFromCart(ProductModel product) async {
    emit(CartLoadingState(state.items));
    try {
      if (_userCubit.state is UserLoggedInState) {
        UserLoggedInState userState = _userCubit.state as UserLoggedInState;
        final items = await _cartRepository.removeFromCart(
            product.sId!, userState.userModel.sId!);
        sortAndLoad(items);
      } else {
        throw "An error occurred while removing the item!";
      }
    } catch (ex) {
      emit(CartErrorState(ex.toString(), state.items));
    }
  }

  bool cartContains(ProductModel product) {
    if (state.items.isNotEmpty) {
      final foundItem = state.items
          .where((item) => item.product!.sId! == product.sId!)
          .toList();
      if (foundItem.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }

  void clearCart(){
    emit(CartLoadedState([]));
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
