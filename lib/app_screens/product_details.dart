import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_node/Widgets/product_details/product_info.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_node/app_screens/home_screen.dart';
import 'package:flutter_node/app_screens/register_screen.dart';
import 'package:flutter_node/shared/app_cubit/cubit.dart';
import 'package:flutter_node/shared/app_cubit/cubit_states.dart';
import 'package:flutter_node/shared/constants.dart';
import 'package:flutter_node/shared/styles.dart';
import 'package:flutter_node/shared/user_cubit/cubit.dart';
import 'package:page_transition/page_transition.dart';

class productDetails extends StatelessWidget {
  const productDetails(
      {Key? key, required this.productId, required this.fromHome})
      : super(key: key);

  final productId;
  final bool fromHome;

  @override
  Widget build(BuildContext context) {
    SnackBar sbarBuilder({
      required String messsage,
      required Color backGroundColor,
    }) {
      return SnackBar(
        duration: Duration(seconds: 2),
        elevation: 4,
        backgroundColor: backGroundColor,
        content: Text(
          messsage,
          style: TextStyle(
            fontSize: 18,
            color: primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return BlocConsumer<appCubit, appCubitStates>(
      listener: (context, state) {
        if (state is setFavProductFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                duration: Duration(seconds: 2),
                elevation: 4,
                backgroundColor: Colors.red,
                content: Row(
                  children: [
                    Expanded(
                        child: Text(
                      'Error, Not Authoried !! \nRegister An Account Or Login If You already have one',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
                    IconButton(
                      onPressed: () {
                        goto(
                            child: registerScreen(),
                            type: PageTransitionType.fade,
                            context: context);
                      },
                      tooltip: 'Go to register',
                      icon: Icon(
                        Icons.error,
                        color: Colors.red,
                        size: 40,
                      ),
                      splashRadius: 1,
                    )
                  ],
                )),
          );
        }
        if (state is setFavProductSuccess) {
          if (state.status == 'added') {
            ScaffoldMessenger.of(context).showSnackBar(sbarBuilder(
              messsage: "added to your Favorites",
              backGroundColor: secondaryColor,
            ));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              sbarBuilder(
                messsage: "Deleted From your Favorites",
                backGroundColor: secondaryColor,
              ),
            );
          }

          if (state is addProductTocartSuccessfully) {
            if (state.status == "added") {
              ScaffoldMessenger.of(context).showSnackBar(sbarBuilder(
                messsage: "added to your cart",
                backGroundColor: Colors.green,
              ));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(sbarBuilder(
                messsage: "removed from your cart",
                backGroundColor: Colors.red,
              ));
            }
          }
        }
        if (state is addProductTocartSuccessfully) {
          if (state.msg == 'added') {
            ScaffoldMessenger.of(context).showSnackBar(sbarBuilder(
              messsage: "added to your Cart",
              backGroundColor: secondaryColor,
            ));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              sbarBuilder(
                messsage: "Deleted From your Cart",
                backGroundColor: secondaryColor,
              ),
            );
          }
        }
        if (state is RateTheProductSuccessfully) {
          ScaffoldMessenger.of(context).showSnackBar(sbarBuilder(
            messsage: "Rating Done Successfully",
            backGroundColor: secondaryColor,
          ));
        }
      },
      builder: (context, state) {
        final userData = userCubit.get(context).userObject;
        final cubit = appCubit.get(context);
        final data = cubit.product_Modal!.data;
        final product = data.firstWhere((element) => element.id == productId);
        return WillPopScope(
          onWillPop: () async {
            goto(
              child: homeScreen(),
              type: PageTransitionType.fade,
              context: context,
            );
            return true;
          },
          child: SafeArea(
            child: Scaffold(
              backgroundColor: secondaryColor,
              body: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    collapsedHeight: 20,
                    toolbarHeight: 20,
                    expandedHeight: 400,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Image(
                        image: NetworkImage(product.image!),
                        width: double.infinity,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),

                  // body
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        const SizedBox(height: 20),
                        productInfo(
                          title: product.title!,
                          descreption: product.descreption!,
                          price: product.price.toString(),
                          quantity: product.quantity.toString(),
                        ),
                        const SizedBox(height: 40),
                        downItem(
                          ctx: context,
                          index: 2,
                          text: 'Rating the Product',
                          clr: secondaryColor,
                          productId: productId,
                          userId: userData!.userId.toString(),
                          cubit: cubit,
                          cartId: null,
                        ),
                        const SizedBox(height: 20),
                        cubit.cartObject == null
                            ? Container()
                            : downItem(
                                index: 0,
                                text: 'Add To Cart',
                                clr: secondaryColor,
                                productId: productId,
                                userId: userData.userId.toString(),
                                cubit: cubit,
                                cartId: cubit.cartObject!.cartId.toString(),
                                ctx: context,
                              ),
                        const SizedBox(height: 20),
                        downItem(
                          ctx: context,
                          index: 1,
                          text: 'Add To Favorites',
                          clr: secondaryColor,
                          productId: productId,
                          userId: userData.userId.toString(),
                          cubit: cubit,
                          cartId: null,
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget downItem({
  required int index,
  required String text,
  required Color clr,
  required String userId,
  required int productId,
  required appCubit cubit,
  required String? cartId,
  required BuildContext ctx,
}) {
  double ratingValue = 3;
  return InkWell(
    onTap: () {
      if (text == 'Add To Favorites') {
        cubit.setFavProduct(productId: productId, userId: userId);
      } else if (text == 'Rating the Product') {
        showDialog(
            context: ctx,
            builder: (_) {
              return AlertDialog(
                title: Text('Rate The Product'),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RatingBar.builder(
                      initialRating: 1,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemSize: 30,
                      glow: true,
                      onRatingUpdate: (rating) {
                        ratingValue = rating;
                      },
                    ),
                    const SizedBox(height: 6),
                  ],
                ),
                actions: [
                  OutlinedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(secondaryColor),
                      ),
                      onPressed: () {
                        cubit.rateProducts(
                          userId: userId,
                          productId: productId,
                          rateValue: ratingValue,
                        );
                        Navigator.of(ctx, rootNavigator: true).pop();
                      },
                      child: Text(
                        'Save',
                        style: TextStyle(color: primaryColor),
                      ))
                ],
              );
            });
      } else {
        // add or remove item from product details screen
        cubit.addItemsToCart(pId: productId, cartId: cartId!, quantity: 1);
      }
    },
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: clr,
        border: Border.all(color: primaryColor),
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 10,
      ),
      child: Text(
          index == 1
              ? (cubit.productFavState.contains(productId))
                  ? 'Unfavorite Product'
                  : text
              : (index == 0)
                  ? (cubit.productsInCart.contains(productId))
                      ? 'Remove From Cart'
                      : text
                  : text,
          style: TextStyle(
            color: primaryColor,
            fontSize: 20,
          )),
    ),
  );
}
