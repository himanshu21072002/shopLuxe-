import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/ui.dart';
import '../../data/models/product/product_model.dart';
import '../../logic/services/formatter.dart';
import '../screens/product/product_details_screen.dart';
import 'gap_widget.dart';

class ProductListView extends StatelessWidget {
  final List<ProductModel> products;

  const ProductListView({
    super.key,
    required this.products
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return CupertinoButton(
            onPressed: () {
              Navigator.pushNamed(context, ProductDetailsScreen.routeName,
                  arguments: product);
            },
            padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
            child: Row(
              children: [
                CachedNetworkImage(
                    width: MediaQuery.of(context).size.width / 3,
                    height: MediaQuery.of(context).size.height / 6,
                    imageUrl: product.images![0].toString()),
                const GapWidget(
                  size: -5,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title.toString(),
                        style: TextStyles.body1.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        product.description.toString(),
                        style: TextStyles.body2
                            .copyWith(color: AppColors.textLight),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const GapWidget(),
                      Text(
                        Formatter.formatPrice(product.price!),
                        style: TextStyles.heading3,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
