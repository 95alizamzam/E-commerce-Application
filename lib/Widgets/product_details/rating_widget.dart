import 'package:flutter/material.dart';
import 'package:flutter_node/shared/app_cubit/cubit.dart';
import 'package:flutter_node/shared/styles.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProductDetailsButton extends StatefulWidget {
  ProductDetailsButton({
    Key? key,
    required this.index,
    required this.cartId,
    required this.clr,
    required this.cubit,
    required this.text,
    required this.productId,
    required this.userId,
  }) : super(key: key);

  final int index, productId;
  final Color clr;
  final String userId, text;
  final String? cartId;
  final appCubit cubit;

  @override
  _ProductDetailsButtonState createState() => _ProductDetailsButtonState();
}

class _ProductDetailsButtonState extends State<ProductDetailsButton> {
  double ratingValue = 2.5;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.text == 'Add To Favorites') {
          widget.cubit.setFavProduct(
            productId: widget.productId,
            userId: widget.userId,
          );
        } else if (widget.text == 'Rating the Product') {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) {
                return AlertDialog(
                  title: Text('Rate The Product'),
                  titlePadding: const EdgeInsets.all(12),
                  shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: RatingBar.builder(
                          initialRating: ratingValue.toDouble(),
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
                            setState(() {
                              ratingValue = rating;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  contentPadding: const EdgeInsets.all(10),
                  actions: [
                    OutlinedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red)),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    OutlinedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(secondaryColor)),
                      onPressed: () {
                        widget.cubit.rateProducts(
                          userId: widget.userId,
                          productId: widget.productId,
                          rateValue: ratingValue == 0.0 ? 1 : ratingValue,
                        );
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      child: Text(
                        'Save',
                        style: TextStyle(color: primaryColor),
                      ),
                    ),
                  ],
                );
              });
        } else {
          // add or remove item from product details screen
          widget.cubit.addItemsToCart(
            pId: widget.productId,
            cartId: widget.cartId!,
            quantity: 1,
          );
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: widget.clr,
          border: Border.all(color: primaryColor),
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 10,
        ),
        child: Text(
          widget.index == 1
              ? (widget.cubit.productFavState.contains(widget.productId))
                  ? 'Unfavorite Product'
                  : widget.text
              : (widget.index == 0)
                  ? (widget.cubit.productsInCart.contains(widget.productId))
                      ? 'Remove From Cart'
                      : widget.text
                  : widget.text,
          style: TextStyle(
            color: primaryColor,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
