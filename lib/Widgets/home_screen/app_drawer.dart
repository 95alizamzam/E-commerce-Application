import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_node/Widgets/home_screen/drawer_item.dart';
import 'package:flutter_node/app_screens/categories_screen.dart';
import 'package:flutter_node/app_screens/favorites_screen.dart';
import 'package:flutter_node/app_screens/home_screen.dart';
import 'package:flutter_node/app_screens/rating_screen.dart';
import 'package:flutter_node/app_screens/settings_screen.dart';
import 'package:flutter_node/app_screens/shopping_cart_screen.dart';
import 'package:flutter_node/shared/app_cubit/cubit.dart';
import 'package:flutter_node/shared/app_cubit/cubit_states.dart';
import 'package:flutter_node/shared/constants.dart';
import 'package:flutter_node/shared/styles.dart';
import 'package:flutter_node/shared/user_cubit/cubit.dart';
import 'package:flutter_node/translations/local_keys.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';
import 'package:badges/badges.dart';

class appDrawer extends StatelessWidget {
  appDrawer({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> drawerItems = [
    {"leadingIcon": Icons.home, "title": LocaleKeys.Home_Screen.tr()},
    {
      "leadingIcon": Icons.grid_view_rounded,
      "title": LocaleKeys.Categories_Screen.tr()
    },
    {
      "leadingIcon": Icons.favorite_border,
      "title": LocaleKeys.Favorites_Screen.tr()
    },
    {
      "leadingIcon": Icons.shopping_cart,
      "title": LocaleKeys.Shopping_cart_Screen.tr()
    },
    {
      "leadingIcon": Icons.star,
      "title": LocaleKeys.Rating_Screen.tr(),
    },
    {
      "leadingIcon": Icons.settings,
      "title": LocaleKeys.Settings.tr(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<appCubit, appCubitStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final userData = userCubit.get(context).userObject;
        return Drawer(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black,
                  Colors.grey,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/appIcon.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey.withOpacity(0.3),
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                    userData!.userImage.toString())),
                            borderRadius: BorderRadius.circular(45),
                            border: Border.all(
                              color: HexColor('#ffd700'),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          LocaleKeys.Welcome.tr() +
                              "  " +
                              userData.userName.toString(),
                          style: TextStyle(
                            color: HexColor('#ffd700').withOpacity(0.9),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                    flex: 5,
                    child: ListView.separated(
                      itemBuilder: (_, index) => drawerItem(
                        itemIndex: index,
                        ico: drawerItems[index]['leadingIcon'],
                        title: drawerItems[index]['title'],
                        userId: userData.userId.toString(),
                        cartId: userData.userCartId.toString(),
                      ),
                      separatorBuilder: (_, index) => const SizedBox(height: 4),
                      itemCount: drawerItems.length,
                    ))
              ],
            ),
          ),
        );
      },
    );
  }
}
