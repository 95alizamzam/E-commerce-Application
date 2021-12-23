import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_node/app_screens/product_details.dart';
import 'package:flutter_node/shared/app_cubit/cubit.dart';
import 'package:flutter_node/shared/app_cubit/cubit_states.dart';
import 'package:flutter_node/shared/constants.dart';
import 'package:flutter_node/shared/styles.dart';
import 'package:page_transition/page_transition.dart';

class listShape extends StatelessWidget {
  const listShape({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<appCubit, appCubitStates>(
        listener: (context, state) {},
        builder: (context, state) {
          final cubit = appCubit.get(context);
          final data = cubit.isFilterDone
              ? cubit.filteredModal!.data
              : cubit.product_Modal!.data;
          return cubit.product_Modal == null
              ? CircularProgressIndicator()
              : Container(
                  child: ListView.separated(
                    itemBuilder: (_, index) => listItem(
                      productId: data[index].id!,
                      imgUrl: data[index].image!,
                      title: data[index].title!,
                      subtitle: data[index].descreption!,
                      price: data[index].price!,
                      context: context,
                    ),
                    separatorBuilder: (_, index) =>
                        Divider(color: primaryColor, indent: 10, endIndent: 10),
                    itemCount: data.length,
                  ),
                );
        });
  }
}

Widget listItem({
  required int productId,
  required String imgUrl,
  required String title,
  required String subtitle,
  required int price,
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
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
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
              ],
            ),
          ),
          Text(
            price.toString() + '\$',
            style: TextStyle(color: primaryColor),
          ),
          const SizedBox(width: 10),
        ],
      ),
    ),
  );
}
