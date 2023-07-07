import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_with_me/logic/cubits/user_cubit/user_cubit.dart';
import 'package:shop_with_me/logic/cubits/user_cubit/user_state.dart';

class LoginProvider with ChangeNotifier{
  final BuildContext context;
  LoginProvider(this.context){
    _listenToUserCubit();
  }

  bool isLoading = false;
  String error ="";
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  StreamSubscription? _userSubscription;

  void _listenToUserCubit(){
    log("Listening to user state......");
    _userSubscription=BlocProvider.of<UserCubit>(context).stream.listen((userState) {
      if(userState is UserLoadingState){
        isLoading= true;
        error="";
        notifyListeners();
      }
      else if(userState is UserErrorState){
        isLoading=false;
        error = userState.message;
        notifyListeners();
      }
      else{
        isLoading = false;
        error="";
        notifyListeners();
      }
    });
  }

  void logIn() async{
    if(!formKey.currentState!.validate()){
      return;
    }
    String email=emailController.text.trim();
    String password= passwordController.text.trim();
    BlocProvider.of<UserCubit>(context).signIn(email: email, password: password);
  }

  @override
  void dispose() {
    _userSubscription?.cancel();
    super.dispose();
  }
}