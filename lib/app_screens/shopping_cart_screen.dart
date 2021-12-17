import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        if (state is getCartDataSuccessfully) {
          appCubit().fetchAllCartProducts(cartId: state.cartId);
        }
        if (state is RegisterCartSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: secondaryColor,
              content: Text(
                'Your Cart Registered Successfully',
                style: TextStyle(color: primaryColor),
              )));
          userCubit().getUserData();
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
        final usercubit = userCubit.get(context);
        final userData = usercubit.userObject!;
        return Scaffold(
          backgroundColor: secondaryColor,
          appBar: AppBar(
            elevation: 0,
            titleSpacing: 0,
            backgroundColor: secondaryColor,
            title: Text(
              'Shopping Cart',
              style: TextStyle(color: primaryColor),
            ),
            leading: IconButton(
                onPressed: () {
                  goto(
                    child: homeScreen(),
                    type: PageTransitionType.fade,
                    context: context,
                  );
                },
                icon: Icon(
                  Icons.arrow_back_ios_new_outlined,
                  color: primaryColor,
                )),
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
                          cubit.registerCart(userId: userData.userId!);
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
              : (cubit.cartProducts == null)
                  ? Center(
                      child: Text(
                        'Your Cart is Empty',
                        style: TextStyle(color: primaryColor, fontSize: 20),
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
                                itemBuilder: (_, index) => cartItemBuilder(
                                  pId: cubit.cartProducts!.data[index].id!,
                                  cubit: cubit,
                                  cartId: cubit.cartObject!.cartId.toString(),
                                  productDescreption: cubit
                                      .cartProducts!.data[index].descreption!,
                                  productPrice: cubit
                                      .cartProducts!.data[index].price
                                      .toString(),
                                  productName:
                                      cubit.cartProducts!.data[index].title!,
                                  image: cubit.cartProducts!.data[index].image
                                      .toString(),
                                ),
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
                              margin: const EdgeInsets.symmetric(vertical: 10),
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
        );
      },
    );
  }
}

Widget cartItemBuilder({
  required int pId,
  required String productName,
  required String productDescreption,
  required String productPrice,
  required String image,
  required String cartId,
  required appCubit cubit,
}) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      border: Border.all(color: primaryColor),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                    border: Border.all(
                  color: primaryColor,
                )),
                child: Image(
                  image: NetworkImage(image),
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productName,
                        style: TextStyle(color: primaryColor, height: 2),
                      ),
                      Text(
                        productDescreption,
                        style: TextStyle(color: primaryColor),
                      ),
                      Text(
                        productPrice + '\$',
                        style: TextStyle(color: primaryColor),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {
                // remove item from shopping cart screen
                cubit.addItemsToCart(
                  pId: pId,
                  cartId: cartId,
                );
              },
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: secondaryColor,
                  border: Border.all(
                    color: primaryColor,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Remove',
                  style: TextStyle(color: primaryColor),
                ),
              ),
            ),

            Container(
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  quantityController(
                    productId: pId,
                    child: Icon(
                      Icons.remove,
                      size: 14,
                      color: secondaryColor,
                    ),
                    direction: true,
                    hasDecoration: true,
                    clr: primaryColor,
                    cubit: cubit,
                  ),
                  Expanded(
                    child: Container(
                      height: 30,
                      alignment: Alignment.center,
                      color: primaryColor,
                      child: Text(
                        '1',
                        style: TextStyle(
                          color: secondaryColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  quantityController(
                    productId: pId,
                    child: Icon(
                      Icons.add,
                      size: 14,
                      color: secondaryColor,
                    ),
                    direction: false,
                    hasDecoration: true,
                    clr: primaryColor,
                    cubit: cubit,
                  ),
                ],
              ),
            ),

            Text(
              'Total Price : ' +
                  cubit
                      .calPrice(price: double.parse(productPrice), quantity: 2)
                      .toString() +
                  '\$',
              style: TextStyle(color: primaryColor),
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: [

            //     CircleAvatar(
            //       backgroundColor: primaryColor,
            //       radius: 10,
            //       child: Center(
            //         child: Icon(
            //           Icons.remove,
            //           size: 15,
            //           color: secondaryColor,
            //         ),
            //       ),
            //     ),
            //     Padding(
            //       padding: const EdgeInsets.symmetric(horizontal: 10),
            //       child: Text(
            //         '1',
            //         style: TextStyle(color: primaryColor),
            //       ),
            //     ),
            //     CircleAvatar(
            //       backgroundColor: primaryColor,
            //       radius: 10,
            //       child: Center(
            //         child: Icon(
            //           Icons.add,
            //           size: 15,
            //           color: secondaryColor,
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ],
    ),
  );
}

Widget quantityController({
  required int productId,
  required Widget child,
  required bool direction,
  required bool hasDecoration,
  required Color clr,
  required appCubit cubit,
}) {
  return Expanded(
    child: GestureDetector(
      onTap: () {
        direction
            ? cubit.decreaseCounter()
            : cubit.increaseCounter(
                productId: productId,
              );
      },
      child: Container(
        height: 30,
        decoration: hasDecoration
            ? BoxDecoration(
                borderRadius: direction
                    ? BorderRadius.horizontal(left: Radius.circular(10.0))
                    : BorderRadius.horizontal(right: Radius.circular(10.0)),
                color: clr,
              )
            : null,
        child: child,
      ),
    ),
  );
}
