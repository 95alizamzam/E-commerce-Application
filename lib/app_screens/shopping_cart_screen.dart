import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_node/Widgets/shopping_cart_widgets/item_builder.dart';
import 'package:flutter_node/app_screens/home_screen.dart';
import 'package:flutter_node/shared/app_cubit/cubit.dart';
import 'package:flutter_node/shared/app_cubit/cubit_states.dart';
import 'package:flutter_node/shared/constants.dart';
import 'package:flutter_node/shared/styles.dart';
import 'package:flutter_node/shared/user_cubit/cubit.dart';
import 'package:page_transition/page_transition.dart';

class shoppingCartScreen extends StatelessWidget {
  const shoppingCartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<appCubit, appCubitStates>(
      listener: (context, state) {
        if (state is RegisterCartSuccess) {
          userCubit().getUserData();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: secondaryColor,
              content: Text(
                'Your Cart Registered Successfully',
                style: TextStyle(color: primaryColor),
              )));
        }

        if (state is AlreadyHaveCartState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: secondaryColor,
              content: Text(
                'Your Already Have Cart ',
                style: TextStyle(color: primaryColor),
              )));
        }
      },
      builder: (context, state) {
        final cubit = appCubit.get(context);
        final userId = userCubit.get(context).userObject!.userId;

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
              titleSpacing: 10,
              backgroundColor: secondaryColor,
              title: Text(
                'Shopping Cart',
                style: TextStyle(color: primaryColor),
              ),
            ),
            body: (cubit.cartObject == null)
                ? Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'You Don\'t Have Cart Yet, So you can\'t add products to cart',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            cubit.registerCart(userId: userId!);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: primaryColor,
                                )),
                            child: Text(
                              'Order Your Cart',
                              style: TextStyle(
                                color: primaryColor,
                              ),
                            ),
                          ),
                        )
                      ],
                    ))
                : (cubit.cartProducts == null ||
                        cubit.cartProducts!.data.length == 0)
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Text(
                            'Your Cart is Empty, Please discover our Products and add them to your cart',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: primaryColor, fontSize: 20),
                          ),
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Container(
                                child: ListView.separated(
                                  itemBuilder: (_, index) {
                                    final data =
                                        cubit.cartProducts!.data[index];
                                    return itemBuilder(
                                      pId: data.id!,
                                      productName: data.title!,
                                      productDescreption: data.descreption!,
                                      productPrice: data.price.toString(),
                                      image: data.image!,
                                      cartId:
                                          cubit.cartObject!.cartId.toString(),
                                      cubit: cubit,
                                      productQuantity: data.quantity!,
                                    );
                                  },
                                  separatorBuilder: (_, index) =>
                                      const SizedBox(height: 10),
                                  itemCount: cubit.cartProducts!.data.length,
                                ),
                              ),
                            ),
                            Container(
                                margin: const EdgeInsets.only(top: 20),
                                child: Divider(
                                  endIndent: 40,
                                  indent: 40,
                                  color: primaryColor,
                                )),
                            Expanded(
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: secondaryColor,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: primaryColor,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(14.0),
                                      child: Text(
                                        "Total :  " +
                                            cubit.totalPrice.toString() +
                                            "\$",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: primaryColor,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.all(14),
                                        decoration: BoxDecoration(
                                          color: primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                        // width: double.infinity,
                                        child: Text(
                                          'Pay Now',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: secondaryColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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
