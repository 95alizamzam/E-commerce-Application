import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_node/Widgets/home_screen/carousel_widget.dart';
import 'package:flutter_node/Widgets/home_screen/categories_show.dart';
import 'package:flutter_node/Widgets/home_screen/introduction.dart';
import 'package:flutter_node/Widgets/home_screen/products_widget.dart';
import 'package:flutter_node/Widgets/layout_screen/app_drawer.dart';
import 'package:flutter_node/app_screens/filter_screen.dart';
import 'package:flutter_node/app_screens/search_screen.dart';
import 'package:flutter_node/shared/app_cubit/cubit.dart';
import 'package:flutter_node/shared/app_cubit/cubit_states.dart';
import 'package:flutter/services.dart';
import 'package:flutter_node/shared/constants.dart';

import 'package:flutter_node/shared/styles.dart';
import 'package:page_transition/page_transition.dart';

import 'package:progress_indicators/progress_indicators.dart';

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
                'Home Screen',
                style: TextStyle(color: primaryColor),
              ),
              backgroundColor: secondaryColor,
              leading: Builder(
                  builder: (context) => IconButton(
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                      icon: Icon(
                        Icons.menu,
                        color: primaryColor,
                      ))),
              actions: [
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
              ],
            ),
            body: cubit.cat_Modal == null || cubit.product_Modal == null
                ? Center(
                    child: FadingText(
                      'Loading...',
                      style: TextStyle(
                        fontSize: 20,
                        color: primaryColor,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  )
                : Container(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          carouselWidget(),
                          intro(title: 'Categories'),
                          categoriesShow(),
                          productsWidget(),
                        ],
                      ),
                    ),
                  ),
            drawer: appDrawer(appcubit: cubit),
          ),
        );
      },
    );
  }
}
