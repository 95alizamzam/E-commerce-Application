import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_node/Widgets/login_screen/intro_section.dart';
import 'package:flutter_node/Widgets/login_screen/login_form.dart';
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

  @override
  Widget build(BuildContext context) {
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    loginIntro(),
                    loginForm(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
