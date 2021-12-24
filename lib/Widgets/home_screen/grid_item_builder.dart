import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_node/app_screens/product_details.dart';
import 'package:flutter_node/shared/app_cubit/cubit.dart';
import 'package:flutter_node/shared/app_cubit/cubit_states.dart';
import 'package:flutter_node/shared/constants.dart';
import 'package:flutter_node/shared/styles.dart';
import 'package:flutter_node/shared/user_cubit/cubit.dart';
import 'package:page_transition/page_transition.dart';

class gridItemBuilder extends StatelessWidget {
  const gridItemBuilder({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.imgUrl,
    required this.productId,
    required this.avgRating,
  }) : super(key: key);

  final int productId, price;
  final String imgUrl, title, subtitle;
  final double avgRating;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<appCubit, appCubitStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = appCubit.get(context);
        return InkWell(
          onTap: () {
            goto(
              child: productDetails(
                productId: productId,
                fromHome: true,
              ),
              type: PageTransitionType.bottomToTop,
              context: context,
            );
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: primaryColor),
              borderRadius: BorderRadius.circular(10),
              color: Colors.black87,
            ),
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(imgUrl),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Name : " + title,
                              style: TextStyle(color: primaryColor),
                            ),
                            Text(
                              "Price : " + price.toString() + '\$',
                              style: TextStyle(color: primaryColor),
                            ),
                            Text(
                              'Rating : ${avgRating}',
                              style: TextStyle(color: primaryColor),
                            )
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          final userId =
                              userCubit.get(context).userObject!.userId;
                          cubit.setFavProduct(
                            productId: productId,
                            userId: userId!,
                          );
                        },
                        child: AnimatedCrossFade(
                          firstChild: Icon(Icons.favorite, color: primaryColor),
                          secondChild: Icon(Icons.favorite_outline_outlined,
                              color: primaryColor),
                          duration: Duration(milliseconds: 700),
                          crossFadeState:
                              cubit.productFavState.contains(productId)
                                  ? CrossFadeState.showFirst
                                  : CrossFadeState.showSecond,
                        ),
                      )
                    ],
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
