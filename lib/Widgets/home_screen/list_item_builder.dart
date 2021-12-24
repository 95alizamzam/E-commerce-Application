import 'package:flutter/material.dart';
import 'package:flutter_node/app_screens/product_details.dart';
import 'package:flutter_node/shared/constants.dart';
import 'package:flutter_node/shared/styles.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:page_transition/page_transition.dart';

class listItemBuilder extends StatelessWidget {
  const listItemBuilder(
      {Key? key,
      required this.imgUrl,
      required this.subtitle,
      required this.title,
      required this.price,
      required this.productAvgRate,
      required this.productId})
      : super(key: key);

  final int productId, price;
  final String imgUrl, subtitle, title;
  final double productAvgRate;

  @override
  Widget build(BuildContext context) {
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: FadeInImage(
                placeholder: AssetImage('assets/images/loading.gif'),
                image: NetworkImage(imgUrl),
              ).image,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(color: primaryColor, fontSize: 16),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(color: primaryColor, fontSize: 14),
                  ),
                  Text(
                    'price : ' + price.toString() + '\$',
                    style: TextStyle(color: primaryColor),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            RatingBar.builder(
              itemBuilder: (_, index) {
                return Icon(
                  Icons.star,
                  color: primaryColor,
                );
              },
              ignoreGestures: true,
              itemCount: 5,
              itemSize: 15,
              initialRating: productAvgRate,
              unratedColor: Colors.black,
              allowHalfRating: true,
              onRatingUpdate: (val) {},
            ),
          ],
        ),
      ),
    );
  }
}
