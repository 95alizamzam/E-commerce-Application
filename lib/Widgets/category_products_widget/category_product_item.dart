import 'package:flutter/material.dart';
import 'package:flutter_node/shared/styles.dart';

class categoryProductItem extends StatelessWidget {
  const categoryProductItem({
    Key? key,
    required this.pId,
    required this.imageUrl,
    required this.title,
    required this.Descreption,
    required this.price,
    required this.Quantity,
  }) : super(key: key);

  final int pId;
  final String imageUrl;
  final String title;
  final String Descreption;
  final String price;
  final String Quantity;

  @override
  Widget build(BuildContext context) {
    TextStyle sty = TextStyle(color: primaryColor);
    return Row(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundImage: Image(image: NetworkImage(imageUrl)).image,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name : ' + title, style: sty),
              Text('Descreption : ' + Descreption, style: sty),
              Text('Price : ' + price + '\$', style: sty),
              Text('Quantity : ' + Quantity, style: sty),
            ],
          ),
        ),
      ],
    );
  }
}
