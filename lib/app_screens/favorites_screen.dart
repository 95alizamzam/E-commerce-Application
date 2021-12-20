import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_node/app_screens/home_screen.dart';
import 'package:flutter_node/shared/app_cubit/cubit.dart';
import 'package:flutter_node/shared/app_cubit/cubit_states.dart';
import 'package:flutter_node/shared/constants.dart';
import 'package:flutter_node/shared/styles.dart';
import 'package:flutter_node/shared/user_cubit/cubit.dart';
import 'package:page_transition/page_transition.dart';

class favoriteScreen extends StatelessWidget {
  const favoriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocConsumer<appCubit, appCubitStates>(
        listener: (context, state) {},
        builder: (context, state) {
          final cubit = appCubit.get(context);
          final userId = userCubit.get(context).userObject!.userId;
          return WillPopScope(
            onWillPop: () async {
              goto(
                  child: homeScreen(),
                  type: PageTransitionType.fade,
                  context: context);
              return true;
            },
            child: Scaffold(
              backgroundColor: secondaryColor,
              appBar: AppBar(
                elevation: 0,
                titleSpacing: 10,
                backgroundColor: secondaryColor,
                title: Text(
                  'Favorites Products',
                  style: TextStyle(color: primaryColor),
                ),
              ),
              body: (cubit.favProducts == null)
                  ? Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    )
                  : (cubit.favProducts!.data.length == 0)
                      ? Center(
                          child: Text(
                            'You Doesn\'t Have Any Favorite Items',
                            style: TextStyle(
                              color: primaryColor,
                            ),
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.all(10),
                          child: ListView.separated(
                            itemBuilder: (_, index) {
                              return favItemBuilder(
                                pId: cubit.favProducts!.data[index].id!,
                                imageUrl: cubit.favProducts!.data[index].image!,
                                title: cubit.favProducts!.data[index].title!,
                                Descreption:
                                    cubit.favProducts!.data[index].descreption!,
                                price: cubit.favProducts!.data[index].price
                                    .toString(),
                                Quantity: cubit
                                    .favProducts!.data[index].quantity
                                    .toString(),
                                cubit: cubit,
                                uId: userId.toString(),
                              );
                            },
                            separatorBuilder: (_, index) =>
                                Divider(color: primaryColor),
                            itemCount: cubit.favProducts!.data.length,
                          ),
                        ),
            ),
          );
        },
      ),
    );
  }
}

Widget favItemBuilder({
  required int pId,
  required String uId,
  required String imageUrl,
  required String title,
  required String Descreption,
  required String price,
  required String Quantity,
  required appCubit cubit,
}) {
  TextStyle sty = TextStyle(
    color: primaryColor,
  );
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
            Text(
              'Name : ' + title,
              style: sty,
            ),
            Text(
              'Descreption : ' + Descreption,
              style: sty,
            ),
            Text(
              'Price : ' + price + '\$',
              style: sty,
            ),
            Text(
              'Quantity : ' + Quantity,
              style: sty,
            ),
          ],
        ),
      ),
      IconButton(
          onPressed: () {
            cubit.setFavProduct(
              productId: pId,
              userId: uId,
            );
          },
          icon: Icon(
            Icons.delete,
            color: Colors.red,
          ))
    ],
  );
}
