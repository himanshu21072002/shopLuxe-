import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shop_with_me/data/models/product/product_model.dart';
import 'package:shop_with_me/presentation/screens/auth/login_screen.dart';
import 'package:shop_with_me/presentation/screens/auth/providers/login_provider.dart';
import 'package:shop_with_me/presentation/screens/auth/providers/signup_provider.dart';
import 'package:shop_with_me/presentation/screens/auth/signup_screen.dart';
import 'package:shop_with_me/presentation/screens/cart/cart_screen.dart';
import 'package:shop_with_me/presentation/screens/home/home_screen.dart';
import 'package:shop_with_me/presentation/screens/order/my_order_screen.dart';
import 'package:shop_with_me/presentation/screens/order/order_detail_screen.dart';
import 'package:shop_with_me/presentation/screens/order/order_placed_screen.dart';
import 'package:shop_with_me/presentation/screens/product/category_product_screen.dart';
import 'package:shop_with_me/presentation/screens/product/product_details_screen.dart';
import 'package:shop_with_me/presentation/screens/splash/splash_screen.dart';
import 'package:shop_with_me/presentation/screens/user/edit_profile_screen.dart';

import '../data/models/category/category_model.dart';
import '../logic/cubits/category_product_cubit/category_product_cubit.dart';
import '../presentation/screens/order/provider/order_detail_provider.dart';

class Routes {
  static Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case LoginScreen.routeName:
        return CupertinoPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (context) => LoginProvider(context),
            child: const LoginScreen(),
          ),
        );
      case SignupScreen.routeName:
        return CupertinoPageRoute(
            builder: (context) => ChangeNotifierProvider(
                create: (context) => SignUpProvider(context),
                child: const SignupScreen()));
      case HomeScreen.routeName:
        return CupertinoPageRoute(builder: (context) => const HomeScreen());
      case SplashScreen.routeName:
        return CupertinoPageRoute(builder: (context) => const SplashScreen());
      case ProductDetailsScreen.routeName:
        return CupertinoPageRoute(
            builder: (context) => ProductDetailsScreen(
                  productModel: settings.arguments as ProductModel,
                ));
      case CartScreen.routeName:
        return CupertinoPageRoute(builder: (context) => const CartScreen());

      case CategoryProductScreen.routeName:
        return CupertinoPageRoute(
            builder: (context) => BlocProvider(
                create: (context) =>
                    CategoryProductCubit(settings.arguments as CategoryModel),
                child: const CategoryProductScreen()));
      case EditProfileScreen.routeName:
        return CupertinoPageRoute(
            builder: (context) => const EditProfileScreen());
      case OrderDetailScreen.routeName: return CupertinoPageRoute(
          builder: (context) => ChangeNotifierProvider(
              create: (context) => OrderDetailProvider(),
              child: const OrderDetailScreen()
          )
      );
      case OrderPlacedScreen.routeName:
        return CupertinoPageRoute(builder: (context) => const OrderPlacedScreen());
      case MyOrderScreen.routeName:
        return CupertinoPageRoute(builder: (context) => const MyOrderScreen());

      default:
        return null;
    }
  }
}
