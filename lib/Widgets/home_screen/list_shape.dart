import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_node/Widgets/home_screen/list_item_builder.dart';
import 'package:flutter_node/shared/app_cubit/cubit.dart';
import 'package:flutter_node/shared/app_cubit/cubit_states.dart';
import 'package:flutter_node/shared/styles.dart';

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

          return cubit.product_Modal == null || cubit.avgRateModal == null
              ? CircularProgressIndicator()
              : Builder(builder: (_) {
                  final RatingData = cubit.avgRateModal!.data;
                  return Container(
                    child: ListView.separated(
                      itemBuilder: (_, index) {
                        return listItemBuilder(
                          productId: data[index].id!,
                          imgUrl: data[index].image!,
                          title: data[index].title!,
                          subtitle: data[index].descreption!,
                          price: data[index].price!,
                          productAvgRate: index > RatingData.length - 1
                              ? 0
                              : RatingData[index].productAvgRate!,
                        );
                      },
                      separatorBuilder: (_, index) => Divider(
                        color: primaryColor,
                        indent: 10,
                        endIndent: 10,
                      ),
                      itemCount: data.length,
                    ),
                  );
                });
        });
  }
}
