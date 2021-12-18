import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_node/app_screens/settings_screen.dart';
import 'package:flutter_node/shared/constants.dart';
import 'package:flutter_node/shared/styles.dart';
import 'package:flutter_node/shared/user_cubit/cubit.dart';
import 'package:flutter_node/shared/user_cubit/cubit_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';

class profileScreen extends StatelessWidget {
  profileScreen({Key? key}) : super(key: key);

  final formKey = GlobalKey<FormState>();
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<userCubit, userCubitStates>(
      listener: (context, state) {
        if (state is updateUserDataDone) {
          userCubit.get(context).getUserData();
        }
      },
      builder: (context, state) {
        final usercubit = userCubit.get(context);
        final data = usercubit.userObject;
        Map<String, dynamic> userData = {
          "userName": data!.userName.toString(),
          "userEmail": data.userEmail.toString(),
          "userPhone": data.userPhoneNumber.toString(),
          "userImage": data.userImage.toString()
        };
        return Scaffold(
          backgroundColor: secondaryColor,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: secondaryColor,
            title: Text(
              'Profile',
              style: TextStyle(color: primaryColor),
            ),
            titleSpacing: 0,
            leading: IconButton(
                onPressed: () {
                  goto(
                    child: settingsScreen(),
                    type: PageTransitionType.fade,
                    context: context,
                  );
                },
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: primaryColor,
                )),
          ),
          body: ListView(
            children: [
              GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          title: Text('Update Your photo'),
                          content: Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    usercubit.pickUserImage(
                                        src: ImageSource.gallery);
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.image,
                                        color: primaryColor,
                                      ),
                                      const SizedBox(width: 10),
                                      Text('From Gallery'),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                GestureDetector(
                                  onTap: () {
                                    usercubit.pickUserImage(
                                        src: ImageSource.camera);
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.camera,
                                        color: primaryColor,
                                      ),
                                      const SizedBox(width: 10),
                                      Text('From Camera'),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      });
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Image(
                    image: NetworkImage(userData['userImage']),
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 2,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Form(
                key: formKey,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: Text(
                          'Your Information :',
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      itemBuilder(
                        hint: 'userName : ' + userData['userName'],
                        type: TextInputType.name,
                        con: userNameController,
                        validate: (String value) {
                          if (value.isEmpty || value.length < 6) {
                            return 'Invalid user Name';
                          }
                          return null;
                        },
                      ),
                      itemBuilder(
                          hint: 'userEmail :' + userData['userEmail'],
                          type: TextInputType.emailAddress,
                          con: emailController,
                          validate: (String value) {
                            if (value.isEmpty ||
                                !value.contains('@') ||
                                !value.contains('.')) {
                              return "Invalid Email";
                            } else {
                              return null;
                            }
                          }),
                      itemBuilder(
                          hint: 'userPhone : ' + userData['userPhone'],
                          type: TextInputType.number,
                          con: phoneController,
                          validate: (String value) {
                            if (value.isEmpty || value.length < 8) {
                              return 'Invalid Phone Number';
                            }
                            return null;
                          }),
                      itemBuilder(
                          hint: "user Password : " + "********",
                          type: TextInputType.visiblePassword,
                          con: passwordController,
                          validate: (String value) {
                            if (value.isEmpty || value.length < 8) {
                              return 'Weak password ,  must be at least 8 characters';
                            }
                            return null;
                          }),
                      const SizedBox(height: 10),
                      state is updateUserDataLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                color: primaryColor,
                              ),
                            )
                          : Container(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (!formKey.currentState!.validate()) {
                                  } else {
                                    usercubit.updateUserData(
                                      userId: data.userId.toString(),
                                      userName: userNameController.text,
                                      email: emailController.text,
                                      password: passwordController.text,
                                      phoneNumber: phoneController.text,
                                      userImage: usercubit.image == null
                                          ? null
                                          : usercubit.image,
                                    );
                                  }
                                },
                                child: Text(
                                  "Save Your Data",
                                  style: TextStyle(
                                    color: secondaryColor,
                                    fontSize: 18,
                                  ),
                                ),
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(primaryColor),
                                ),
                              ),
                            ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

Widget itemBuilder({
  required String hint,
  required TextEditingController con,
  required Function validate,
  required TextInputType type,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 6),
    padding: const EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
      border: Border.all(
        color: primaryColor,
      ),
      borderRadius: BorderRadius.circular(15.0),
    ),
    child: Row(
      children: [
        Expanded(
          child: TextFormField(
            style: TextStyle(color: primaryColor),
            keyboardType: type,
            controller: con,
            obscureText: type == TextInputType.visiblePassword ? true : false,
            decoration: InputDecoration(
              hintText: hint,
              errorStyle: TextStyle(
                color: Colors.red,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              hintStyle: TextStyle(color: primaryColor),
              border: InputBorder.none,
            ),
            validator: (val) => validate(val),
          ),
        ),
      ],
    ),
  );
}
