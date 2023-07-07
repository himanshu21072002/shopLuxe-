import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_with_me/presentation/screens/auth/providers/signup_provider.dart';

import '../../../core/ui.dart';
import '../../widgets/gap_widget.dart';
import '../../widgets/link_button.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/primary_textfield.dart';
import 'login_screen.dart';


class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);
  static const String routeName="signup";
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    final provider= Provider.of<SignUpProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text("ShopLuxe",style: TextStyles.heading2,),),
      body: SafeArea(
        child: Form(
          key: provider.formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const GapWidget(),
              Text("Create Account", style: TextStyles.heading1),
              const GapWidget(size: -5,),
              provider.error != ""
                  ? Text(
                provider.error,
                style: const TextStyle(color: Colors.red),
              )
                  : const SizedBox(),
              const GapWidget(size: -4,),
              PrimaryTextField(
                labelText: "Email Address",
                controller: provider.emailController,
                validator: (value){
                  if(value==null || value.trim().isEmpty){
                    return "Email address is required!";
                  }
                  if(!EmailValidator.validate(value.trim())){
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
                validator: (value){
                  if(value==null || value.trim().isEmpty){
                    return "Password is required!";
                  }
                  return null;
                },
              ),
              const GapWidget(),
              PrimaryTextField(
                labelText: "Confirm Password",
                controller: provider.cPasswordController,
                obscureText: true,
                validator: (value){
                  if(value==null || value.trim().isEmpty){
                    return "Confirm your password";
                  }
                  if(value.trim()!=provider.passwordController.text.trim()){
                    return "Passwords do not match";
                  }
                  return null;
                },
              ),
              const GapWidget(
                size: 14,
              ),
              PrimaryButton(
                text: (provider.isLoading) ? "...." : "Create Account",
                onPressed: provider.createAccount,
              ),
              const GapWidget(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: TextStyles.body2,
                  ),
                  LinkButton(
                    text: "Log In",
                    onPressed: () {
                      Navigator.pushNamed(context,LoginScreen.routeName);
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
