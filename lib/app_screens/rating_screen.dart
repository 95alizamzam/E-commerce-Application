import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_node/app_screens/home_screen.dart';
import 'package:flutter_node/shared/app_cubit/cubit.dart';
import 'package:flutter_node/shared/app_cubit/cubit_states.dart';
import 'package:flutter_node/shared/constants.dart';
import 'package:flutter_node/shared/styles.dart';
import 'package:flutter_node/translations/local_keys.dart';
import 'package:page_transition/page_transition.dart';

class ratingScreen extends StatelessWidget {
  const ratingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<appCubit, appCubitStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = appCubit.get(context);
        return WillPopScope(
          onWillPop: () async {
            goto(
              child: homeScreen(),
              type: PageTransitionType.fade,
              context: context,
            );
            return false;
          },
          child: Scaffold(
            backgroundColor: secondaryColor,
            appBar: AppBar(
              backgroundColor: secondaryColor,
              elevation: 0,
              titleSpacing: 10,
              title: Text(
                LocaleKeys.Rating_Screen.tr(),
                style: TextStyle(color: primaryColor),
              ),
            ),
            body: cubit.ratedProducts == null
                ? Center(
                    child: CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  )
                : cubit.ratedProducts!.data.length == 0
                    ? Center(
                        child: Text(
                          'You didn\'t Rate Any Product Yet',
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 20,
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        itemBuilder: (_, index) {
                          final product = cubit.product_Modal!.data.firstWhere(
                              (element) =>
                                  element.id ==
                                  cubit.ratedProducts!.data[index].productId);
                          return ratedItemBilder(
                            productId: product.id!,
                            cubit: cubit,
                            userId: cubit.ratedProducts!.data[index].userId!,
                            image: product.image.toString(),
                            title: product.title.toString(),
                            subtitle: product.descreption.toString(),
                            rating: cubit.ratedProducts!.data[index].ratingValue
                                .toString(),
                            context: context,
                          );
                        },
                        separatorBuilder: (_, index) =>
                            const SizedBox(height: 10),
                        itemCount: cubit.ratedProducts!.data.length,
                      ),
          ),
        );
      },
    );
  }
}

Widget ratedItemBilder({
  required String userId,
  required int productId,
  required String image,
  required String title,
  required String subtitle,
  required String rating,
  required BuildContext context,
  required appCubit cubit,
}) {
  return GestureDetector(
    onTap: () {
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: Text(
                'Remove Your Rate ?!',
                style: TextStyle(color: primaryColor),
              ),
              actions: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    cubit.removeProductRate(
                        userId: userId, productId: productId);
                  },
                  child: Text('Ok'),
                ),
              ],
            );
          });
    },
    child: Card(
      elevation: 6,
      color: secondaryColor,
      shadowColor: primaryColor,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: primaryColor,
                ),
              ),
              child: Image(
                image: NetworkImage(image),
                width: 70,
                height: 70,
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(color: primaryColor),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(color: primaryColor),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                border: Border.all(
                  color: primaryColor,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.star,
                    color: primaryColor,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$rating',
                    style: TextStyle(color: primaryColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
