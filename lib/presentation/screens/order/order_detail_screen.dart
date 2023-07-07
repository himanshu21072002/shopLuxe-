// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shop_with_me/data/models/order/order_model.dart';
import 'package:shop_with_me/logic/cubits/cart_cubit/cart_cubit.dart';
import 'package:shop_with_me/logic/cubits/cart_cubit/cart_state.dart';
import 'package:shop_with_me/logic/cubits/order_cubit/order_cubit.dart';
import 'package:shop_with_me/logic/cubits/user_cubit/user_cubit.dart';
import 'package:shop_with_me/logic/services/razorpay_services.dart';
import 'package:shop_with_me/presentation/screens/order/order_placed_screen.dart';
import 'package:shop_with_me/presentation/screens/order/provider/order_detail_provider.dart';
import 'package:shop_with_me/presentation/widgets/primary_button.dart';

import '../../../core/ui.dart';
import '../../../data/models/user/user_model.dart';
import '../../../logic/cubits/user_cubit/user_state.dart';
import '../../widgets/cart_list_view.dart';
import '../../widgets/gap_widget.dart';
import '../../widgets/link_button.dart';
import '../user/edit_profile_screen.dart';

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({Key? key}) : super(key: key);
  static const routeName = "order_detail";
  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Order"),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            BlocBuilder<UserCubit, UserState>(builder: (context, state) {
              if (state is UserLoadingState) {
                return const CircularProgressIndicator();
              }

              if (state is UserLoggedInState) {
                UserModel user = state.userModel;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "User Details",
                      style: TextStyles.body2
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const GapWidget(),
                    Text("${user.fullName}", style: TextStyles.heading3),
                    Text(
                      "Email: ${user.email}",
                      style: TextStyles.body2,
                    ),
                    Text(
                      "Phone: ${user.phoneNumber}",
                      style: TextStyles.body2,
                    ),
                    Text(
                      "Address: ${user.address}, ${user.city}, ${user.state}",
                      style: TextStyles.body2,
                    ),
                    LinkButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, EditProfileScreen.routeName);
                        },
                        text: "Edit Profile"),
                  ],
                );
              }

              if (state is UserErrorState) {
                return Text(state.message);
              }

              return const SizedBox();
            }),
            const GapWidget(size: 10),
            Text(
              "Items",
              style: TextStyles.body2.copyWith(fontWeight: FontWeight.bold),
            ),
            const GapWidget(),
            BlocBuilder<CartCubit, CartState>(
              builder: (context, state) {
                if (state is CartLoadingState && state.items.isEmpty) {
                  return const CircularProgressIndicator();
                }

                if (state is CartErrorState && state.items.isEmpty) {
                  return Text(state.message);
                }

                return CartListView(
                  items: state.items,
                  shrikWrap: true,
                  noScroll: true,
                );
              },
            ),
            const GapWidget(size: 10),
            Text(
              "Payment",
              style: TextStyles.body2.copyWith(fontWeight: FontWeight.bold),
            ),
            const GapWidget(),
            Consumer<OrderDetailProvider>(
              builder: (context, provider, child) {
                return Column(
                  children: [
                    RadioListTile(
                      value: "pay-on-delivery",
                      groupValue: provider.paymentMethod,
                      contentPadding: EdgeInsets.zero,
                      onChanged: provider.changePaymentMethod,
                      title: const Text("Pay on Delivery"),
                    ),
                    RadioListTile(
                      value: "pay-now",
                      groupValue: provider.paymentMethod,
                      contentPadding: EdgeInsets.zero,
                      onChanged: provider.changePaymentMethod,
                      title: const Text("Pay Now"),
                    ),
                  ],
                );
              },
            ),
            const GapWidget(),
            PrimaryButton(
              text: 'Place Order',
              onPressed: () async {
                OrderModel? newOrder =
                    await BlocProvider.of<OrderCubit>(context).createOrder(
                        items: BlocProvider.of<CartCubit>(context).state.items,
                        paymentMethod: Provider.of<OrderDetailProvider>(context,
                                listen: false)
                            .paymentMethod
                            .toString());
                if (newOrder == null) {
                  return;
                }
                if (newOrder.status == "order-placed") {
                  Navigator.popUntil(context, (route) => route.isFirst);
                  Navigator.pushNamed(context, OrderPlacedScreen.routeName);
                }
                if (newOrder.status == "payment-pending") {
                  await RazorPayServices.checkoutOrder(newOrder,
                      onSuccess: (response) async {
                    newOrder.status = "order_placed";
                    bool success = await BlocProvider.of<OrderCubit>(context)
                        .updateOrder(
                            newOrder, response.paymentId, response.signature);
                    if (!success) {
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   const SnackBar(content: Text("can't update the order")),
                      // );
                      log("can't update the order");
                      return;
                    }
                    Navigator.popUntil(context, (route) => route.isFirst);
                    Navigator.pushNamed(context, OrderPlacedScreen.routeName);
                  }, onFailure: (response) {
                    log("payment failed!");
                  });
                }
        log("idhar aa gaya");
              },
            )
          ],
        ),
      ),
    );
  }
}
