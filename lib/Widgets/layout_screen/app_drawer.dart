import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:page_transition/page_transition.dart';

class appDrawer extends StatelessWidget {
  appDrawer({Key? key, required this.appcubit}) : super(key: key);

  final appCubit appcubit;
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
    {"leadingIcon": Icons.star, "title": LocaleKeys.Rating_Screen.tr()},
    {"leadingIcon": Icons.settings, "title": LocaleKeys.Settings.tr()},
  ];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<appCubit, appCubitStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final usercubit = userCubit.get(context);
        final userData = usercubit.userObject;
        return Drawer(
          child: Container(
            color: secondaryColor,
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: DrawerHeader(
                      child: Column(
                    children: [
                      CircleAvatar(
                        radius: 45.0,
                        backgroundImage:
                            NetworkImage(userData!.userImage.toString()),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          child: Text(
                            LocaleKeys.Welcome.tr() +
                                userData.userName.toString(),
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
                ),
                Expanded(
                    flex: 5,
                    child: ListView.separated(
                      itemBuilder: (_, index) => itemBuilder(
                        ico: drawerItems[index]['leadingIcon'],
                        title: drawerItems[index]['title'],
                        trailIcon: Icons.arrow_forward_ios_outlined,
                        context: context,
                        cubit: appcubit,
                        userId: userData.userId.toString(),
                        cartId: userData.userCartId.toString(),
                      ),
                      separatorBuilder: (_, index) => Divider(
                        color: primaryColor,
                        endIndent: 10,
                        indent: 10,
                      ),
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

Widget itemBuilder({
  required IconData ico,
  required String title,
  required IconData trailIcon,
  required BuildContext context,
  required appCubit cubit,
  required String userId,
  required String cartId,
}) {
  return Container(
    child: ListTile(
      leading: Icon(ico, color: primaryColor),
      title: Text(
        title,
        style: TextStyle(
          color: primaryColor,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: IconButton(
          icon: Icon(
            trailIcon,
            color: primaryColor,
          ),
          onPressed: () {
            Navigator.of(context).pop();
            if (title == 'Home Screen') {
              goto(
                child: homeScreen(),
                type: PageTransitionType.fade,
                context: context,
              );
            } else if (title == 'Categories Screen') {
              goto(
                child: categoriesScreen(),
                type: PageTransitionType.fade,
                context: context,
              );
            } else if (title == 'Rating Screen') {
              cubit.fetchUserRatings(userId: userId);
              goto(
                child: ratingScreen(),
                type: PageTransitionType.fade,
                context: context,
              );
            } else if (title == 'Favorites Screen') {
              cubit.getFavoritesProducts(userId: userId);
              goto(
                child: favoriteScreen(),
                type: PageTransitionType.fade,
                context: context,
              );
            } else if (title == 'Shopping cart Screen') {
              if (cartId == 'empty') {
                goto(
                  child: shoppingCartScreen(),
                  type: PageTransitionType.fade,
                  context: context,
                );
              } else {
                cubit.getCartData(cartId: cartId);
                cubit.fetchAllCartProducts(cartId: cartId);
                goto(
                  child: shoppingCartScreen(),
                  type: PageTransitionType.fade,
                  context: context,
                );
              }
            } else {
              goto(
                child: settingsScreen(),
                type: PageTransitionType.fade,
                context: context,
              );
            }
          }),
    ),
  );
}
