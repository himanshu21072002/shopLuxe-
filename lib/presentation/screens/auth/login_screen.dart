import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shop_with_me/core/ui.dart';
import 'package:shop_with_me/logic/cubits/user_cubit/user_cubit.dart';
import 'package:shop_with_me/logic/cubits/user_cubit/user_state.dart';
import 'package:shop_with_me/presentation/screens/auth/providers/login_provider.dart';
import 'package:shop_with_me/presentation/screens/auth/signup_screen.dart';
import 'package:shop_with_me/presentation/screens/splash/splash_screen.dart';
import 'package:shop_with_me/presentation/widgets/gap_widget.dart';
import 'package:shop_with_me/presentation/widgets/link_button.dart';
import 'package:shop_with_me/presentation/widgets/primary_button.dart';
import 'package:shop_with_me/presentation/widgets/primary_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const String routeName = "login";
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation? ani;
  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    ani = ColorTween(begin: Colors.pinkAccent, end: Colors.white)
        .animate(controller!);
    controller!.forward();
    controller!.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  static const colorizeColors = [
    Colors.purple,
    Colors.blue,
    Colors.yellow,
    Colors.red,
  ];

  static const colorizeTextStyle = TextStyle(
      letterSpacing: 2,
      fontSize: 60.0,
      fontFamily: 'Horizon',
      fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LoginProvider>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return BlocListener<UserCubit, UserState>(
      listener: (context, state) {
        if (state is UserLoggedInState) {
          Navigator.pushReplacementNamed(context, SplashScreen.routeName);
        }
      },
      child: Scaffold(
        backgroundColor: ani!.value,
        body: SafeArea(
          child: Form(
            key: provider.formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                SizedBox(
                  width: width,
                  child: Center(
                    child: AnimatedTextKit(
                      repeatForever: true,
                      animatedTexts: [
                        ColorizeAnimatedText(
                          'ShopLuxe',
                          speed: const Duration(milliseconds: 800),
                          textStyle: colorizeTextStyle,
                          colors: colorizeColors,
                        ),
                      ],
                      isRepeatingAnimation: true,
                    ),
                  ),
                ),
                const GapWidget(),
                SizedBox(
                  height: height * 0.1,
                  width: width,
                  child: Center(
                    child: DefaultTextStyle(
                      style: const TextStyle(
                        color: Color(0xff5f97df),
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                      ),
                      child: AnimatedTextKit(
                        pause: const Duration(milliseconds: 100),
                        repeatForever: true,
                        animatedTexts: [
                          FadeAnimatedText('Shop IT!'),
                          FadeAnimatedText('Shop it RIGHT!!'),
                          FadeAnimatedText('Shop it RIGHT NOW!!!'),
                        ],
                      ),
                    ),
                  ),
                ),
                const GapWidget(),
                Text("Log In", style: TextStyles.heading1),
                const GapWidget(
                  size: -5,
                ),
                provider.error != ""
                    ? Text(
                        provider.error,
                        style: const TextStyle(color: Colors.red),
                      )
                    : const SizedBox(),
                const GapWidget(
                  size: -4,
                ),
                PrimaryTextField(
                  labelText: "Email Address",
                  controller: provider.emailController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Email address is required!";
                    }
                    if (!EmailValidator.validate(value.trim())) {
                      return "Invalid email address";
                    }
                    return null;
                  },
                ),
                const GapWidget(),
                PrimaryTextField(
                  labelText: "Password",
                  controller: provider.passwordController,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Password is required!";
                    }
                    return null;
                  },
                ),
                LinkButton(
                  text: 'Forgot Password?',
                  onPressed: () {},
                ),
                const GapWidget(
                  size: 14,
                ),
                PrimaryButton(
                  text: (provider.isLoading) ? "...." : "Login",
                  onPressed: provider.logIn,
                ),
                const GapWidget(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyles.body2,
                    ),
                    LinkButton(
                      text: "Sign Up",
                      onPressed: () {
                        Navigator.pushNamed(context, SignupScreen.routeName);
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
