import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_node/Widgets/register_screen/register_widgets.dart';
import 'package:flutter_node/app_screens/home_screen.dart';
import 'package:flutter_node/app_screens/login_screen.dart';
import 'package:flutter_node/shared/constants.dart';
import 'package:flutter_node/shared/styles.dart';
import 'package:flutter_node/shared/user_cubit/cubit.dart';
import 'package:flutter_node/shared/user_cubit/cubit_state.dart';
import 'package:flutter_node/translations/local_keys.dart';
import 'package:page_transition/page_transition.dart';

class registerFrom extends StatelessWidget {
  registerFrom({Key? key}) : super(key: key);

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
          showSnackBar(
            context: context,
            color: Colors.red,
            message: state.errorMessage,
            messageColor: Colors.white,
          );
        }

        if (state is RegisterDoneState) {
          showSnackBar(
            context: context,
            color: secondaryColor,
            message: 'Register Done SUCCESSFULLLY',
            messageColor: primaryColor,
          );
          goto(
            child: homeScreen(),
            type: PageTransitionType.fade,
            context: context,
          );
        }
      },
      builder: (context, state) {
        final cubit = userCubit.get(context);
        return Form(
          key: formKey,
          child: Column(
            children: [
              textField(
                cubit: cubit,
                isSecure: false,
                controller: userCon,
                type: TextInputType.name,
                hint: LocaleKeys.User_Name.tr(),
                label: LocaleKeys.User_Name.tr(),
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
                hint: LocaleKeys.Email.tr(),
                label: LocaleKeys.Email.tr(),
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
                  hint: LocaleKeys.Password.tr(),
                  label: LocaleKeys.Password.tr(),
                  prefixIcon: Icons.lock,
                  suffixIcon:
                      cubit.isSecure ? Icons.visibility_off : Icons.visibility,
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
                  hint: LocaleKeys.Phone_Number.tr(),
                  label: LocaleKeys.Phone_Number.tr(),
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
                        if (!cubit.connect_to_internet!) {
                          showSnackBar(
                            context: context,
                            color: Colors.red,
                            message: LocaleKeys.Please_check_Your_internet.tr(),
                            messageColor: Colors.white,
                          );
                        } else if (cubit.image == null) {
                          showSnackBar(
                            context: context,
                            color: Colors.red,
                            message: LocaleKeys.Please_Select_Your_Image.tr(),
                            messageColor: Colors.white,
                          );
                        } else if (!formKey.currentState!.validate()) {
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
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(14),
                              width: double.infinity,
                              child: Text(
                                LocaleKeys.Register.tr(),
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
                          LocaleKeys.Already_Have_An_Account.tr(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              secondaryColor,
                            ),
                          ),
                          onPressed: () {
                            goto(
                              child: loginScreen(),
                              type: PageTransitionType.leftToRight,
                              context: context,
                            );
                          },
                          child: Text(
                            LocaleKeys.Login.tr(),
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
        );
      },
    );
  }
}
