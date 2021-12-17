import 'package:flutter/material.dart';
import 'package:flutter_node/shared/constants.dart';
import 'package:flutter_node/shared/styles.dart';

class productInfo extends StatelessWidget {
  const productInfo({
    Key? key,
    required this.title,
    required this.descreption,
    required this.price,
    required this.quantity,
  }) : super(key: key);

  final String title;
  final String descreption;
  final String price;
  final String quantity;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: secondaryColor,
        border: Border.all(color: primaryColor),
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Product Info : ',
            style: TextStyle(
              fontSize: 18,
              color: primaryColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          decsItem(index: 1, itemInfo: 'Name  : ' + title),
          decsItem(index: 2, itemInfo: 'Desception : ' + descreption),
          decsItem(index: 3, itemInfo: "Price : " + price.toString() + '\$'),
          decsItem(index: 4, itemInfo: "Quantity : " + quantity.toString()),
        ],
      ),
    );
  }
}

Widget decsItem({
  required String itemInfo,
  required int index,
}) {
  return Container(
    child: Card(
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
      color: secondaryColor,
      shadowColor: primaryColor,
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 15,
              backgroundColor: primaryColor,
              child: Text(
                index.toString(),
                style: TextStyle(color: secondaryColor),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                itemInfo,
                style: TextStyle(
                  fontSize: 20,
                  height: 2,
                  color: primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
