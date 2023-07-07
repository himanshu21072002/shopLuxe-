// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_with_me/logic/cubits/user_cubit/user_cubit.dart';

import '../../../core/ui.dart';
import '../../../data/models/user/user_model.dart';
import '../../../logic/cubits/user_cubit/user_state.dart';
import '../../widgets/gap_widget.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/primary_textfield.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);
  static const routeName = "edit_profile";
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Edit Profile"),
        ),
        body: SafeArea(
          child: BlocBuilder<UserCubit, UserState>(builder: (context, state) {
            if (state is UserLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is UserErrorState) {
              return Center(
                child: Text(state.message),
              );
            }
            if (state is UserLoggedInState) {
                UserModel userModel=state.userModel;
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text("Personal Details",
                      style: TextStyles.body1.copyWith(fontWeight: FontWeight.bold)),
                  const GapWidget(
                    size: -10,
                  ),
                  PrimaryTextField(
                    initialValue: userModel.fullName,
                    onChanged: (value) {
                      userModel.fullName = value;
                    },
                    labelText: "Full Name",
                  ),
                  const GapWidget(),
                  PrimaryTextField(
                    initialValue: userModel.phoneNumber,
                    onChanged: (value) {
                      userModel.phoneNumber = value;
                    },
                    labelText: "Phone Number",
                  ),
                  const GapWidget(size: 20),
                  Text("Address",
                      style: TextStyles.body1.copyWith(fontWeight: FontWeight.bold)),
                  const GapWidget(
                    size: -10,
                  ),
                  PrimaryTextField(
                    initialValue: userModel.address,
                    onChanged: (value) {
                      userModel.address = value;
                    },
                    labelText: "Address",
                  ),
                  const GapWidget(),
                  PrimaryTextField(
                    initialValue: userModel.city,
                    onChanged: (value) {
                      userModel.city = value;
                    },
                    labelText: "City",
                  ),
                  const GapWidget(),
                  PrimaryTextField(
                    initialValue: userModel.state,
                    onChanged: (value) {
                      userModel.state = value;
                    },
                    labelText: "State",
                  ),
                  const GapWidget(),
                  PrimaryButton(
                      onPressed: () async {
                        bool success = await BlocProvider.of<UserCubit>(context)
                            .updateUser(userModel);
                        if (success) {
                          Navigator.pop(context);
                        }
                      },
                      text: "Save"),
                ],
              );
            }
            return const Center(
              child: Text("An error occurred"),
            );
          }),
        ));
  }
}


