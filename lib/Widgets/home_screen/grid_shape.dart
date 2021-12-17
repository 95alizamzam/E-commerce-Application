import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_node/app_screens/product_details.dart';
import 'package:flutter_node/shared/app_cubit/cubit.dart';
import 'package:flutter_node/shared/app_cubit/cubit_states.dart';
import 'package:flutter_node/shared/constants.dart';
import 'package:flutter_node/shared/styles.dart';
import 'package:flutter_node/shared/user_cubit/cubit.dart';
import 'package:page_transition/page_transition.dart';

class gridShape extends StatelessWidget {
  const gridShape({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<appCubit, appCubitStates>(
        listener: (context, state) {},
        builder: (context, state) {
          final cubit = appCubit.get(context);
          final data = cubit.product_Modal!.data;
          return cubit.product_Modal == null
              ? CircularProgressIndicator()
              : Container(
                  color: secondaryColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 3 / 4,
                    children: data.map((element) {
                      return gridItem(
                        productId: element.id,
                        imgUrl: element.image!,
                        title: element.title!,
                        subtitle: element.descreption!,
                        price: element.price!,
                        cubit: cubit,
                        context: context,
                      );
                    }).toList(),
                  ),
                );
        });
  }
}

Widget gridItem({
  required int? productId,
  required String imgUrl,
  required String title,
  required String subtitle,
  required int price,
  required appCubit cubit,
  required BuildContext context,
}) {
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
              )),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
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
                        'Rating : 4.5',
                        style: TextStyle(color: primaryColor),
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    final userId = userCubit.get(context).userObject!.userId;
                    cubit.setFavProduct(
                      productId: productId!,
                      userId: userId!,
                    );
                  },
                  child: Icon(
                    cubit.productFavState.contains(productId)
                        ? Icons.favorite
                        : Icons.favorite_outline_outlined,
                    color: primaryColor,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
