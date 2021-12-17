import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_node/Widgets/register_screen/register_widgets.dart';
import 'package:flutter_node/Widgets/register_screen/top_section.dart';
import 'package:flutter_node/app_screens/home_screen.dart';
import 'package:flutter_node/app_screens/login_screen.dart';
import 'package:flutter_node/shared/constants.dart';
import 'package:flutter_node/shared/styles.dart';
import 'package:flutter_node/shared/user_cubit/cubit.dart';
import 'package:flutter_node/shared/user_cubit/cubit_state.dart';
import 'package:page_transition/page_transition.dart';

class registerScreen extends StatelessWidget {
  registerScreen({Key? key}) : super(key: key);

  final TextEditingController userCon = TextEditingController();
  final TextEditingController passCon = TextEditingController();
  final TextEditingController emailCon = TextEditingController();
  final TextEditingController phoneCon = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<userCubit, userCubitStates>(
      listener: (context, state) {
        if (state is RegisterErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Container(
              child: Text(state.errorMessage),
            ),
          ));
        }

        if (state is RegisterDoneState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Container(
              child: Row(children: [
                Expanded(
                    child: Text(
                  "Register Done SUCCESSFULLLY",
                  style: TextStyle(color: primaryColor),
                )),
                Icon(
                  Icons.verified,
                  color: Colors.green,
                ),
              ]),
            ),
          ));
          goto(
            child: homeScreen(),
            type: PageTransitionType.fade,
            context: context,
          );
        }
      },
      builder: (context, state) {
        final cubit = userCubit.get(context);
        return SafeArea(
          child: Scaffold(
            backgroundColor: secondaryColor,
            body: Center(
              child: Container(
                padding: const EdgeInsets.all(6),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      topSection(cubit: cubit),
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            textField(
                              cubit: cubit,
                              isSecure: false,
                              controller: userCon,
                              type: TextInputType.name,
                              hint: 'User Name',
                              label: 'User Name',
                              prefixIcon: Icons.person_outlined,
                              suffixIcon: null,
                              validate: (String value) {
                                if (value.isEmpty || value.length < 6) {
                                  return 'Invalid user Name';
                                }
                                return null;
                              },
                            ),
                            textField(
                              cubit: cubit,
                              isSecure: false,
                              controller: emailCon,
                              type: TextInputType.emailAddress,
                              hint: 'Email',
                              label: 'Email',
                              prefixIcon: Icons.email,
                              suffixIcon: null,
                              validate: (String value) {
                                if (value.isEmpty ||
                                    !value.contains('@') ||
                                    !value.contains('.')) {
                                  return 'Invalid email';
                                }
                                return null;
                              },
                            ),
                            textField(
                                cubit: cubit,
                                isSecure: !cubit.isSecure,
                                controller: passCon,
                                type: TextInputType.visiblePassword,
                                hint: 'Password',
                                label: 'Password',
                                prefixIcon: Icons.lock,
                                suffixIcon: cubit.isSecure
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                validate: (String value) {
                                  if (value.isEmpty || value.length < 8) {
                                    return 'Weak password ,  must be at least 8 characters';
                                  }
                                  return null;
                                }),
                            textField(
                                cubit: cubit,
                                isSecure: false,
                                controller: phoneCon,
                                type: TextInputType.phone,
                                hint: 'Phone Number',
                                label: 'Phone Number',
                                prefixIcon: Icons.phone,
                                suffixIcon: null,
                                validate: (String value) {
                                  if (value.isEmpty || value.length < 8) {
                                    return 'Invalid Phone Number';
                                  }
                                  return null;
                                }),
                            Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if (cubit.connect_to_internet == false) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                            'Please check Your internet !!! ',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ));
                                      } else if (cubit.image == null) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                            'Please Select Your Image',
                                            style:
                                                TextStyle(color: primaryColor),
                                          ),
                                        ));
                                      } else if (!formKey.currentState!
                                          .validate()) {
                                        return;
                                      } else {
                                        FocusScope.of(context).unfocus();
                                        cubit.registerUser(
                                          userName: userCon.text.trim(),
                                          email: emailCon.text.trim(),
                                          password: passCon.text.trim(),
                                          phoneNumber: phoneCon.text.trim(),
                                          userImage: cubit.image!,
                                        );
                                      }
                                    },
                                    child: state is RegisterLoadingState
                                        ? CircularProgressIndicator(
                                            color: primaryColor,
                                          )
                                        : Container(
                                            decoration: BoxDecoration(
                                              color: primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.all(14),
                                            width: double.infinity,
                                            child: Text(
                                              'Register',
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: secondaryColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Already Have An Account ?!',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: primaryColor,
                                        ),
                                      ),
                                      TextButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                            secondaryColor,
                                          ),
                                        ),
                                        onPressed: () {
                                          goto(
                                            child: loginScreen(),
                                            type:
                                                PageTransitionType.leftToRight,
                                            context: context,
                                          );
                                        },
                                        child: Text(
                                          'Login',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: primaryColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
