import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_with_me/logic/cubits/user_cubit/user_cubit.dart';
import 'package:shop_with_me/logic/cubits/user_cubit/user_state.dart';
import 'package:shop_with_me/presentation/screens/cart/cart_screen.dart';
import 'package:shop_with_me/presentation/screens/home/profile_screen.dart';
import 'package:shop_with_me/presentation/screens/home/user_feed_screen.dart';
import 'package:shop_with_me/presentation/screens/splash/splash_screen.dart';

import '../../../core/ui.dart';
import '../../../logic/cubits/cart_cubit/cart_cubit.dart';
import '../../../logic/cubits/cart_cubit/cart_state.dart';
import 'category_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const String routeName = "home";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  List<Widget> screens = const [
    UserFeedScreen(),
    CategoryScreen(),
    ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCubit,UserState>(
      listener: (context,state){
        if(state is UserLoggedOutState){
          Navigator.pushReplacementNamed(context, SplashScreen.routeName);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "ShopLuxe",
            style: TextStyle(
                fontFamily: 'Horizon',
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
                fontSize: 32),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, CartScreen.routeName);
              },
              icon: BlocBuilder<CartCubit, CartState>(
                  builder: (context, state) {
                    return Badge(
                        label: Text("${state.items.length}"),
                        isLabelVisible: (state is CartLoadingState) ? false : true,
                        child: const Icon(CupertinoIcons.cart_fill)
                    );
                  }
              ),
            ),
          ],
        ),
        body: screens[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.category), label: "Categories"),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
            ]),
      ),
    );
  }
}
