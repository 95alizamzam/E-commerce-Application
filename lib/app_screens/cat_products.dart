import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_node/Widgets/category_products_widget/category_product_item.dart';
import 'package:flutter_node/app_screens/categories_screen.dart';
import 'package:flutter_node/app_screens/home_screen.dart';
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
            return WillPopScope(
              onWillPop: () async {
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
                return true;
              },
              child: Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  titleSpacing: 10,
                  title: Text(
                    'Category Products',
                    style: TextStyle(color: primaryColor),
                  ),
                  backgroundColor: secondaryColor,
                ),
                body: Container(
                  color: secondaryColor,
                  padding: const EdgeInsets.all(10),
                  child: ListView.separated(
                    itemBuilder: (_, index) => categoryProductItem(
                      pId: myProducts[index].id!,
                      imageUrl: myProducts[index].image!,
                      title: myProducts[index].title!,
                      Descreption: myProducts[index].descreption!,
                      price: myProducts[index].price.toString(),
                      Quantity: myProducts[index].quantity.toString(),
                    ),
                    separatorBuilder: (_, index) =>
                        Divider(color: primaryColor),
                    itemCount: myProducts.length,
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
