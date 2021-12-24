import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_node/Widgets/home_screen/app_data_section.dart';

import 'package:flutter_node/Widgets/home_screen/loading_widget.dart';
import 'package:flutter_node/Widgets/home_screen/app_drawer.dart';
import 'package:flutter_node/app_screens/filter_screen.dart';
import 'package:flutter_node/app_screens/search_screen.dart';
import 'package:flutter_node/shared/app_cubit/cubit.dart';
import 'package:flutter_node/shared/app_cubit/cubit_states.dart';
import 'package:flutter_node/shared/constants.dart';

import 'package:flutter_node/shared/styles.dart';
import 'package:flutter_node/translations/local_keys.dart';
import 'package:page_transition/page_transition.dart';

class homeScreen extends StatelessWidget {
  homeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<appCubit, appCubitStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = appCubit.get(context);
        return SafeArea(
          bottom: true,
          child: Scaffold(
            backgroundColor: secondaryColor,
            appBar: AppBar(
              elevation: 0,
              titleSpacing: 0,
              title: Text(
                LocaleKeys.Home_Screen.tr(),
                style: TextStyle(color: primaryColor),
              ),
              backgroundColor: secondaryColor,
              leading: appBarLeading(),
              actions: appBarAction(context: context),
            ),
            body: cubit.cat_Modal == null || cubit.product_Modal == null
                ? loadingWidget()
                : appDataSection(),
            drawer: appDrawer(),
          ),
        );
      },
    );
  }
}

Widget appBarLeading() => Builder(
    builder: (context) => IconButton(
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
        icon: Icon(
          Icons.menu,
          color: primaryColor,
        )));

List<Widget> appBarAction({
  required BuildContext context,
}) {
  return [
    IconButton(
      onPressed: () {
        goto(
          child: filterScreen(),
          type: PageTransitionType.fade,
          context: context,
        );
      },
      icon: Icon(Icons.filter_alt_outlined, color: primaryColor),
      splashRadius: 1,
    ),
    IconButton(
        onPressed: () {
          goto(
            child: searchScreen(),
            type: PageTransitionType.fade,
            context: context,
          );
        },
        icon: Icon(
          Icons.search,
          color: primaryColor,
        )),
  ];
}
