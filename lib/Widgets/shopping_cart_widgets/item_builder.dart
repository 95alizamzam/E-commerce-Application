import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_node/shared/app_cubit/cubit.dart';
import 'package:flutter_node/shared/styles.dart';

class itemBuilder extends StatelessWidget {
  itemBuilder({
    Key? key,
    required this.pId,
    required this.productName,
    required this.productDescreption,
    required this.productPrice,
    required this.image,
    required this.cartId,
    required this.cubit,
    required this.productQuantity,
  }) : super(key: key);

  int pId, productQuantity;
  final String productName, productDescreption, productPrice, image, cartId;
  final appCubit cubit;

  @override
  Widget build(BuildContext context) {
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
                    quantity: productQuantity,
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
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          --productQuantity;
                          cubit.updateQuantity(
                            cartId: cartId,
                            productId: pId,
                            quantity: productQuantity,
                          );
                        },
                        child: Container(
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.horizontal(
                              left: context.locale == Locale('en')
                                  ? Radius.circular(10.0)
                                  : Radius.circular(0),
                              right: context.locale == Locale('en')
                                  ? Radius.circular(0)
                                  : Radius.circular(10.0),
                            ),
                            color: primaryColor,
                          ),
                          child: Icon(
                            Icons.remove,
                            size: 14,
                            color: secondaryColor,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 30,
                        alignment: Alignment.center,
                        color: primaryColor,
                        child: Text(
                          productQuantity.toString(),
                          style: TextStyle(
                            color: secondaryColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          ++productQuantity;
                          cubit.updateQuantity(
                            cartId: cartId,
                            productId: pId,
                            quantity: productQuantity,
                          );
                        },
                        child: Container(
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.horizontal(
                              right: context.locale == Locale('en')
                                  ? Radius.circular(10.0)
                                  : Radius.circular(0),
                              left: context.locale == Locale('en')
                                  ? Radius.circular(0)
                                  : Radius.circular(10.0),
                            ),
                            color: primaryColor,
                          ),
                          child: Icon(
                            Icons.add,
                            size: 14,
                            color: secondaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
