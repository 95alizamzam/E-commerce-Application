import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_node/Widgets/register_screen/register_widgets.dart';
import 'package:flutter_node/app_screens/home_screen.dart';
import 'package:flutter_node/app_screens/register_screen.dart';
import 'package:flutter_node/shared/constants.dart';
import 'package:flutter_node/shared/styles.dart';
import 'package:flutter_node/shared/user_cubit/cubit.dart';
import 'package:flutter_node/shared/user_cubit/cubit_state.dart';
import 'package:flutter_node/translations/local_keys.dart';
import 'package:page_transition/page_transition.dart';

class loginScreen extends StatelessWidget {
  loginScreen({Key? key}) : super(key: key);

  final TextEditingController passCon = TextEditingController();
  final TextEditingController emailCon = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<userCubit, userCubitStates>(
      listener: (context, state) {
        if (state is loginStateFailed) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Container(
              child: Text(state.errorMsg.toString()),
            ),
          ));
        }
        if (state is loginStateDone) {
          goto(
            child: homeScreen(),
            type: PageTransitionType.bottomToTop,
            context: context,
          );
        }
      },
      builder: (context, state) {
        final cubit = userCubit.get(context);
        return WillPopScope(
          onWillPop: () async {
            goto(
              child: registerScreen(),
              type: PageTransitionType.rightToLeft,
              context: context,
            );
            return true;
          },
          child: SafeArea(
            child: Scaffold(
              backgroundColor: secondaryColor,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: secondaryColor,
              ),
              body: Center(
                child: Container(
                  padding: const EdgeInsets.all(6),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                LocaleKeys.Welcome_to_Online_Shop.tr(),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Login with Your Account and discover our Products',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Form(
                          key: formKey,
                          child: Column(
                            children: [
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
                                  suffixIcon: cubit.isSecure
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  validate: (String value) {
                                    if (value.isEmpty || value.length < 8) {
                                      return 'Weak password ,  must be at least 8 characters';
                                    }
                                    return null;
                                  }),
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                child: Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        if (cubit.connect_to_internet ==
                                            false) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                              LocaleKeys
                                                      .Please_check_Your_internet
                                                  .tr(),
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ));
                                        } else if (!formKey.currentState!
                                            .validate()) {
                                          return;
                                        } else {
                                          FocusScope.of(context).unfocus();
                                          cubit.login(
                                              email: emailCon.text.trim(),
                                              password: passCon.text.trim());
                                        }
                                      },
                                      child: state is loginStateLoading
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
                                                LocaleKeys.Login.tr(),
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
                                          'Browse As a Guest ?!',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: primaryColor,
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {},
                                          child: Text(
                                            'Let\'s Go .. ',
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
          ),
        );
      },
    );
  }
}
