import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_with_me/logic/cubits/product_cubit/product_cubit.dart';
import 'package:shop_with_me/logic/cubits/product_cubit/product_state.dart';

import 'package:shop_with_me/presentation/widgets/product_list_view.dart';

class UserFeedScreen extends StatefulWidget {
  const UserFeedScreen({Key? key}) : super(key: key);

  @override
  State<UserFeedScreen> createState() => _UserFeedScreenState();
}

class _UserFeedScreenState extends State<UserFeedScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductCubit, ProductState>(builder: (context, state) {
      if (state is ProductLoadingState && state.products.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      if (state is ProductErrorState && state.products.isEmpty) {
        return Center(
          child: Text(state.message),
        );
      }
      return ProductListView(products: state.products);
    });
  }
}
