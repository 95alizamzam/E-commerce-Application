import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_node/app_screens/categories_screen.dart';
import 'package:flutter_node/app_screens/home_screen.dart';
import 'package:flutter_node/app_screens/product_details.dart';
import 'package:flutter_node/shared/app_cubit/cubit.dart';
import 'package:flutter_node/shared/app_cubit/cubit_states.dart';
import 'package:flutter_node/shared/constants.dart';
import 'package:flutter_node/shared/styles.dart';
import 'package:page_transition/page_transition.dart';

class catProducts extends StatelessWidget {
  const catProducts({Key? key, this.fromHome}) : super(key: key);
  final bool? fromHome;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocConsumer<appCubit, appCubitStates>(
        listener: (context, state) {},
        builder: (context, state) {
          final cubit = appCubit.get(context);
          if (cubit.catProducts == null) {
            return Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          } else {
            final myProducts = cubit.catProducts!.data;
            return Scaffold(
              appBar: AppBar(
                elevation: 0,
                titleSpacing: 0,
                title: Text(
                  'Category Products',
                  style: TextStyle(color: primaryColor),
                ),
                backgroundColor: secondaryColor,
                leading: InkWell(
                  onTap: () {
                    if (fromHome == true && fromHome != null) {
                      goto(
                        child: homeScreen(),
                        type: PageTransitionType.fade,
                        context: context,
                      );
                    } else {
                      goto(
                        child: categoriesScreen(),
                        type: PageTransitionType.fade,
                        context: context,
                      );
                    }
                  },
                  child: Icon(Icons.arrow_back_ios_new_outlined,
                      color: primaryColor),
                ),
              ),
              body: Container(
                color: secondaryColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: ListView.separated(
                  itemBuilder: (_, index) => productBuilder(
                    pId: myProducts[index].id!,
                    imageUrl: myProducts[index].image!,
                    title: myProducts[index].title!,
                    Descreption: myProducts[index].descreption!,
                    price: myProducts[index].price.toString(),
                    Quantity: myProducts[index].quantity.toString(),
                    context: context,
                  ),
                  separatorBuilder: (_, index) =>
                      const Divider(color: Colors.green),
                  itemCount: myProducts.length,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

Widget productBuilder({
  required int pId,
  required String imageUrl,
  required String title,
  required String Descreption,
  required String price,
  required String Quantity,
  required BuildContext context,
}) {
  TextStyle sty = TextStyle(color: primaryColor);
  return Row(
    children: [
      CircleAvatar(
        radius: 35,
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
      TextButton(
          onPressed: () {
            goto(
              child: productDetails(
                productId: pId,
                fromHome: false,
              ),
              type: PageTransitionType.bottomToTop,
              context: context,
            );
          },
          child: Text(
            'Details',
            style: TextStyle(color: primaryColor),
          ))
    ],
  );
}
