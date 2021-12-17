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
    final userData = userCubit.get(context);
    final data = userData.userObject;
    return BlocConsumer<userCubit, userCubitStates>(
      listener: (context, state) {},
      builder: (context, state) {
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
              Stack(
                alignment: Alignment.bottomCenter,
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
                                        userData.pickUserImage(
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
                                        userData.pickUserImage(
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
                    child: CircleAvatar(
                      radius: 75,
                      backgroundImage: NetworkImage(
                        data!.userImage.toString(),
                      ),
                    ),
                  ),
                ],
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
                        type: TextInputType.name,
                        label: 'user Name :',
                        hint: data.userName.toString(),
                        con: userNameController,
                        validate: (String value) {
                          if (value.isEmpty || value.length < 6) {
                            return 'Invalid user Name';
                          }
                          return null;
                        },
                      ),
                      itemBuilder(
                          type: TextInputType.emailAddress,
                          label: 'email  :',
                          hint: data.userEmail.toString(),
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
                          type: TextInputType.number,
                          label: 'phone Number  :',
                          hint: data.userPhoneNumber.toString(),
                          con: phoneController,
                          validate: (String value) {
                            if (value.isEmpty || value.length < 8) {
                              return 'Invalid Phone Number';
                            }
                            return null;
                          }),
                      itemBuilder(
                          type: TextInputType.visiblePassword,
                          label: 'password  :',
                          hint: "*********",
                          con: passwordController,
                          validate: (String value) {
                            if (value.isEmpty || value.length < 8) {
                              return 'Weak password ,  must be at least 8 characters';
                            }
                            return null;
                          }),
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
                                    return;
                                  } else {
                                    userData.updateUserData(
                                      userId: userData.userObject!.userId
                                          .toString(),
                                      userName: userNameController.text,
                                      email: emailController.text,
                                      password: passwordController.text,
                                      phoneNumber: phoneController.text,
                                      userImage: userData.image!,
                                    );

                                    userNameController.clear();
                                    emailController.clear();
                                    passwordController.clear();
                                    phoneController.clear();
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
  required String label,
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
              decoration: InputDecoration(
                hintText: "current Data : " + hint,
                hintStyle: TextStyle(color: primaryColor),
                border: InputBorder.none,
              ),
              validator: (val) => validate(val)),
        ),
      ],
    ),
  );
}
