import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_node/Widgets/category_screen_widgets/category_item.dart';
import 'package:flutter_node/app_screens/home_screen.dart';
import 'package:flutter_node/shared/app_cubit/cubit.dart';
import 'package:flutter_node/shared/app_cubit/cubit_states.dart';
import 'package:flutter_node/shared/constants.dart';
import 'package:flutter_node/shared/styles.dart';
import 'package:flutter_node/translations/local_keys.dart';
import 'package:page_transition/page_transition.dart';

class categoriesScreen extends StatelessWidget {
  const categoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<appCubit, appCubitStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = appCubit.get(context);
        final data = cubit.cat_Modal!.data;
        return SafeArea(
          top: true,
          bottom: true,
          child: WillPopScope(
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
                titleSpacing: 10,
                title: Text(
                  LocaleKeys.Categories.tr(),
                  style: TextStyle(color: primaryColor),
                ),
                backgroundColor: secondaryColor,
              ),
              body: GridView.count(
                crossAxisCount: 3,
                childAspectRatio: 3 / 4,
                mainAxisSpacing: 10,
                crossAxisSpacing: 4,
                padding: const EdgeInsets.all(6),
                physics: const BouncingScrollPhysics(),
                children: data.map((item) {
                  return categoryItemBuilder(
                    catId: item.id.toString(),
                    imageUrl: item.image!,
                    subtitle: item.descreption!,
                    title: item.title!,
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}
