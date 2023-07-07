
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_with_me/core/ui.dart';
import 'package:shop_with_me/logic/cubits/cart_cubit/cart_cubit.dart';
import 'package:shop_with_me/logic/cubits/cart_cubit/cart_state.dart';
import 'package:shop_with_me/logic/services/calculation.dart';
import 'package:shop_with_me/logic/services/formatter.dart';
import 'package:shop_with_me/presentation/screens/order/order_detail_screen.dart';
import 'package:shop_with_me/presentation/widgets/cart_list_view.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);
  static const routeName = "cart";
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
      ),
      body: SafeArea(
        child: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            if (state is CartLoadingState && state.items.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is CartErrorState && state.items.isEmpty) {
              return Center(
                child: Text(state.message),
              );
            }
            if (state is CartLoadedState && state.items.isEmpty) {
              return Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("Your cart is empty!"),
                    Icon(Icons.add_shopping_cart_sharp),
                  ],
                ),
              );
            }
            return Column(
              children: [
                Expanded(
                  child: CartListView(items: state.items),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${state.items.length} items",
                              style: TextStyles.body1
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Total: ${Formatter.formatPrice(Calculations.cartTotal(state.items))}",
                              style: TextStyles.heading3,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width / 2.5,
                          child: CupertinoButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, OrderDetailScreen.routeName);
                            },
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width / 22),
                            color: AppColors.accent,
                            child: const Text("Place order"),
                          ))
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
