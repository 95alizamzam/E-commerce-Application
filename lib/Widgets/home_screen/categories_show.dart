import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_node/Widgets/home_screen/category_item_builder.dart';
import 'package:flutter_node/shared/app_cubit/cubit.dart';
import 'package:flutter_node/shared/app_cubit/cubit_states.dart';

class categoriesShow extends StatelessWidget {
  const categoriesShow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<appCubit, appCubitStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final data = appCubit.get(context).cat_Modal!.data;
        return Container(
          height: 100,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          width: double.infinity,
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, index) => categoryItemBuilder(
              imgurl: data[index].image!,
              title: data[index].title!,
              catId: data[index].id.toString(),
            ),
            separatorBuilder: (_, index) => const SizedBox(width: 10),
            itemCount: data.length,
          ),
        );
      },
    );
  }
}
