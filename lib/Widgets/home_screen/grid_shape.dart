import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_node/Widgets/home_screen/grid_item_builder.dart';
import 'package:flutter_node/shared/app_cubit/cubit.dart';
import 'package:flutter_node/shared/app_cubit/cubit_states.dart';
import 'package:flutter_node/shared/styles.dart';

class gridShape extends StatelessWidget {
  const gridShape({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<appCubit, appCubitStates>(
        listener: (context, state) {},
        builder: (context, state) {
          final cubit = appCubit.get(context);

          final data = cubit.isFilterDone
              ? cubit.filteredModal!.data
              : cubit.product_Modal!.data;
          final ratingData = cubit.avgRateModal!.data;
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
                      double productAvgRate = 0.0;
                      try {
                        final rate = ratingData
                            .firstWhere((item) => item.productId == element.id);
                        productAvgRate = rate.productAvgRate!;
                      } catch (e) {
                        productAvgRate = 0.0;
                      }

                      return gridItemBuilder(
                        title: element.title!,
                        subtitle: element.descreption!,
                        price: element.price!,
                        imgUrl: element.image!,
                        productId: element.id!,
                        avgRating: productAvgRate,
                      );
                    }).toList(),
                  ),
                );
        });
  }
}
