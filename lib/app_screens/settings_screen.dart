import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_node/app_screens/contact_us_screen.dart';
import 'package:flutter_node/app_screens/home_screen.dart';
import 'package:flutter_node/app_screens/profile_screen.dart';
import 'package:flutter_node/app_screens/splash_screen.dart';
import 'package:flutter_node/shared/app_cubit/cubit.dart';
import 'package:flutter_node/shared/app_cubit/cubit_states.dart';
import 'package:flutter_node/shared/constants.dart';
import 'package:flutter_node/shared/shared_prefrences/shared_prefrences.dart';
import 'package:flutter_node/shared/styles.dart';
import 'package:flutter_node/shared/user_cubit/cubit.dart';
import 'package:page_transition/page_transition.dart';

class settingsScreen extends StatelessWidget {
  const settingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<appCubit, appCubitStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = appCubit.get(context);
        return Scaffold(
          backgroundColor: secondaryColor,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: secondaryColor,
            title: Text(
              'Settings',
              style: TextStyle(color: primaryColor),
            ),
            titleSpacing: 0,
            leading: IconButton(
                onPressed: () {
                  goto(
                    child: homeScreen(),
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
            padding: const EdgeInsets.symmetric(horizontal: 10),
            children: [
              settingItemBuider(
                leadingIcon: Icons.wb_sunny,
                text: 'Change Application Mood',
                trailingIcon: null,
                child: Switch(
                    activeColor: primaryColor,
                    value: isDark,
                    onChanged: (bool value) {
                      cubit.changeAppMood(context: context, val: value);
                    }),
                function: () {
                  // cubit.changeAppMood(context: context);
                },
              ),
              settingItemBuider(
                leadingIcon: Icons.language,
                text: 'Change Application Language',
                trailingIcon: Icons.spellcheck_outlined,
                function: () {},
              ),
              settingItemBuider(
                  leadingIcon: Icons.color_lens,
                  text: 'Change Application Colors',
                  trailingIcon: Icons.colorize,
                  function: () {
                    cubit.changeAppColors(context: context);
                  }),
              settingItemBuider(
                leadingIcon: Icons.person,
                text: 'Change user Data',
                trailingIcon: Icons.edit,
                function: () {
                  goto(
                    child: profileScreen(),
                    type: PageTransitionType.fade,
                    context: context,
                  );
                },
              ),
              settingItemBuider(
                leadingIcon: Icons.info,
                text: 'Contact us',
                trailingIcon: Icons.assignment_ind,
                function: () {
                  goto(
                    child: contactUs(),
                    type: PageTransitionType.fade,
                    context: context,
                  );
                },
              ),
              settingItemBuider(
                leadingIcon: Icons.logout,
                text: 'Logout',
                trailingIcon: Icons.exit_to_app,
                function: () {
                  sharedPrefrences.clearData().then((value) {
                    userToken = "";
                    tokenDate = 0;
                    userCubit.get(context).pickedImage = null;
                    userCubit.get(context).image = null;
                    userCubit.get(context).disappearSplachScreen();
                    goto(
                      child: splashScreen(),
                      type: PageTransitionType.fade,
                      context: context,
                    );
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

Widget settingItemBuider({
  required IconData leadingIcon,
  required String text,
  required IconData? trailingIcon,
  required Function function,
  Widget? child,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10),
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      border: Border.all(
        color: primaryColor,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      children: [
        Icon(
          leadingIcon,
          color: primaryColor,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: primaryColor,
              fontSize: 18,
            ),
          ),
        ),
        trailingIcon == null
            ? child!
            : IconButton(
                splashRadius: 10,
                onPressed: () {
                  function();
                },
                icon: Icon(
                  trailingIcon,
                  color: primaryColor,
                ),
              )
      ],
    ),
  );
}
