import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:shop_with_me/core/ui.dart';
import 'package:shop_with_me/data/models/product/product_model.dart';
import 'package:shop_with_me/logic/cubits/cart_cubit/cart_cubit.dart';
import 'package:shop_with_me/logic/services/formatter.dart';
import 'package:shop_with_me/presentation/widgets/gap_widget.dart';
import 'package:shop_with_me/presentation/widgets/primary_button.dart';

import '../../../logic/cubits/cart_cubit/cart_state.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel productModel;
  const ProductDetailsScreen({Key? key, required this.productModel})
      : super(key: key);
  static const routeName = "product_details";
  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.productModel.title}"),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            child: CarouselSlider.builder(
              unlimitedMode: true,
              itemCount: widget.productModel.images?.length ?? 0,
              slideIndicator: CircularSlideIndicator(
                currentIndicatorColor: AppColors.accent,
              ),
              slideBuilder: (index) {
                String url = widget.productModel.images![index];
                return CachedNetworkImage(imageUrl: url);
              },
            ),
          ),
          const GapWidget(
            size: 5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${widget.productModel.title}",
                  style: TextStyles.heading3,
                ),
                Text(
                  Formatter.formatPrice(widget.productModel.price!),
                  style: TextStyles.heading2,
                ),
                const GapWidget(
                  size: 10,
                ),
                BlocBuilder<CartCubit, CartState>(builder: (context, state) {
                  bool isInCart=(BlocProvider.of<CartCubit>(context)
                      .cartContains(widget.productModel));
                  return PrimaryButton(
                      onPressed: !isInCart
                          ? () {
                              BlocProvider.of<CartCubit>(context)
                                  .addToCart(widget.productModel, 1);
                            }
                          : null,
                      text: isInCart
                          ? "Product added to cart"
                          : "Add to Cart",
                      textStyle: TextStyle(
                          color: isInCart
                              ? AppColors.textLight
                              : Colors.white));
                }),
                const GapWidget(
                  size: 10,
                ),
                Text(
                  "Description",
                  style: TextStyles.body2.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  "${widget.productModel.description}",
                  style: TextStyles.body1,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
