import 'package:badges/badges.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
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
import 'package:flutter_node/translations/local_keys.dart';
import 'package:page_transition/page_transition.dart';

class drawerItem extends StatelessWidget {
  drawerItem({
    Key? key,
    required this.cartId,
    required this.ico,
    required this.title,
    required this.userId,
    required this.itemIndex,
  }) : super(key: key);

  final IconData ico;
  final String title, userId, cartId;
  final int itemIndex;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<appCubit, appCubitStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = appCubit.get(context);
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
            if (itemIndex == 0) {
              goto(
                child: homeScreen(),
                type: PageTransitionType.fade,
                context: context,
              );
              cubit.changeDrawerIndex(index: 0);
            } else if (itemIndex == 1) {
              goto(
                child: categoriesScreen(),
                type: PageTransitionType.fade,
                context: context,
              );
              cubit.changeDrawerIndex(index: 1);
            } else if (itemIndex == 4) {
              goto(
                child: ratingScreen(),
                type: PageTransitionType.fade,
                context: context,
              );
              cubit.changeDrawerIndex(index: 4);
              cubit.fetchUserRatings(userId: userId);
            } else if (itemIndex == 2) {
              goto(
                child: favoriteScreen(),
                type: PageTransitionType.fade,
                context: context,
              );
              cubit.changeDrawerIndex(index: 2);
              cubit.getFavoritesProducts(userId: userId);
            } else if (itemIndex == 3) {
              if (cartId == 'empty') {
                goto(
                  child: shoppingCartScreen(),
                  type: PageTransitionType.fade,
                  context: context,
                );
              } else {
                goto(
                  child: shoppingCartScreen(),
                  type: PageTransitionType.fade,
                  context: context,
                );
                cubit.getCartData(cartId: cartId);
                cubit.fetchAllCartProducts(cartId: cartId);
              }
              cubit.changeDrawerIndex(index: 3);
            } else {
              goto(
                child: settingsScreen(),
                type: PageTransitionType.fade,
                context: context,
              );
              cubit.changeDrawerIndex(index: 5);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: cubit.drawerIndex == itemIndex
                  ? Colors.grey.withOpacity(.3)
                  : Colors.transparent,
            ),
            padding: const EdgeInsets.all(14),
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                ico == Icons.shopping_cart ||
                        ico == Icons.favorite_border ||
                        ico == Icons.star
                    ? Badge(
                        badgeColor: primaryColor,
                        padding: const EdgeInsets.all(4),
                        badgeContent: ico == Icons.shopping_cart
                            ? Text(
                                cubit.productsInCart.length.toString(),
                                style: TextStyle(color: Colors.white),
                              )
                            : (ico == Icons.star)
                                ? Text(
                                    cubit.numberOfRating.length.toString(),
                                    style: TextStyle(color: Colors.white),
                                  )
                                : Text(
                                    cubit.productFavState.length.toString(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                        position: BadgePosition(
                          isCenter: false,
                          top: -10,
                          end: -4,
                        ),
                        child: Icon(ico, color: Colors.white.withOpacity(.5)))
                    : Icon(ico, color: Colors.white.withOpacity(.5)),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
