import 'package:flutter/material.dart';
import 'package:flutter_node/app_screens/cat_products.dart';
import 'package:flutter_node/app_screens/favorites_screen.dart';
import 'package:flutter_node/app_screens/home_screen.dart';
import 'package:flutter_node/app_screens/shopping_cart_screen.dart';
import 'package:flutter_node/shared/app_cubit/cubit.dart';
import 'package:flutter_node/shared/constants.dart';
import 'package:flutter_node/shared/styles.dart';
import 'package:flutter_node/shared/user_cubit/cubit.dart';
import 'package:page_transition/page_transition.dart';

class topSection extends StatelessWidget {
  const topSection({Key? key, required this.image, required this.fromHome})
      : super(key: key);
  final String image;
  final bool fromHome;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(top: 50),
          decoration: BoxDecoration(
            // color: goldClr,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Image(
            image: NetworkImage(image),
            width: double.infinity,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(14.0),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  if (!fromHome) {
                    goto(
                      child: catProducts(),
                      type: PageTransitionType.fade,
                      context: context,
                    );
                  } else {
                    goto(
                      child: homeScreen(),
                      type: PageTransitionType.fade,
                      context: context,
                    );
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color: primaryColor,
                      )),
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    color: primaryColor,
                  ),
                ),
              ),
              Spacer(),
              InkWell(
                onTap: () {
                  goto(
                    child: shoppingCartScreen(),
                    type: PageTransitionType.fade,
                    context: context,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color: primaryColor,
                      )),
                  child: Icon(
                    Icons.shopping_cart,
                    color: primaryColor,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              InkWell(
                onTap: () {
                  final appcubit = appCubit.get(context);
                  final usercubit = userCubit.get(context);
                  appcubit.getFavoritesProducts(
                    userId: usercubit.userObject!.userId.toString(),
                  );
                  goto(
                    child: favoriteScreen(),
                    type: PageTransitionType.fade,
                    context: context,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color: primaryColor,
                      )),
                  child: Icon(
                    Icons.favorite,
                    color: primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
