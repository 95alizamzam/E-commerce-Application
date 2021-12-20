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
import 'package:flutter_node/translations/local_keys.dart';
import 'package:page_transition/page_transition.dart';
import 'package:easy_localization/easy_localization.dart';

class settingsScreen extends StatelessWidget {
  const settingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<appCubit, appCubitStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = appCubit.get(context);
        return WillPopScope(
          onWillPop: () async {
            goto(
              child: homeScreen(),
              type: PageTransitionType.fade,
              context: context,
            );
            return true;
          },
          child: Scaffold(
            backgroundColor: secondaryColor,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: secondaryColor,
              title: Text(
                LocaleKeys.Settings.tr(),
                style: TextStyle(color: primaryColor),
              ),
              titleSpacing: 10,
            ),
            body: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              children: [
                settingItemBuider(
                  leadingIcon: Icons.wb_sunny,
                  text: LocaleKeys.Change_Application_Mood.tr(),
                  trailingIcon: null,
                  child: Switch(
                      activeColor: primaryColor,
                      value: isDark,
                      onChanged: (bool value) {
                        cubit.changeAppMood(context: context, val: value);
                      }),
                  function: () {},
                ),
                settingItemBuider(
                  leadingIcon: Icons.language,
                  text: LocaleKeys.Change_Application_Language.tr(),
                  trailingIcon: null,
                  child: PopupMenuButton(
                      padding: const EdgeInsets.all(0),
                      shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                          color: secondaryColor,
                        ),
                      ),
                      color: primaryColor,
                      icon: Icon(
                        Icons.spellcheck_outlined,
                        color: primaryColor,
                      ),
                      itemBuilder: (ctx) {
                        return [
                          PopupMenuItem(
                            onTap: () {
                              // convert to arab language
                              cubit.changeAppLanguage(
                                context: ctx,
                                val: Locale('ar'),
                              );
                            },
                            child: Row(
                              children: [
                                Image(
                                  image: AssetImage('assets/images/arab.png'),
                                  width: 20,
                                  height: 20,
                                ),
                                const SizedBox(width: 10),
                                Text('Arabic Language'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            onTap: () {
                              // convert to english
                              cubit.changeAppLanguage(
                                context: ctx,
                                val: Locale('en'),
                              );
                            },
                            child: Row(
                              children: [
                                Image(
                                  image: AssetImage('assets/images/eng.png'),
                                  width: 20,
                                  height: 20,
                                ),
                                const SizedBox(width: 10),
                                Text('English Language'),
                              ],
                            ),
                          ),
                        ];
                      }),
                  function: () {},
                ),
                settingItemBuider(
                    leadingIcon: Icons.color_lens,
                    text: LocaleKeys.Change_Application_Colors.tr(),
                    trailingIcon: Icons.colorize,
                    function: () {
                      cubit.changeAppColors(context: context);
                    }),
                settingItemBuider(
                  leadingIcon: Icons.person,
                  text: LocaleKeys.Change_user_Data.tr(),
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
                  text: LocaleKeys.Contact_us.tr(),
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
                  text: LocaleKeys.Logout.tr(),
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
