import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_node/shared/app_cubit/cubit.dart';
import 'package:flutter_node/shared/app_cubit/cubit_states.dart';
import 'package:flutter_node/shared/styles.dart';
import 'package:flutter_node/translations/local_keys.dart';

class filterButton extends StatelessWidget {
  const filterButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<appCubit, appCubitStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = appCubit.get(context);
        return GestureDetector(
          onTap: () {
            cubit.getFilteredProducts(
              selectedPrice: cubit.sliderSelectedValues.end,
              minPriceValue: cubit.sliderSelectedValues.start,
              selectedCategories: cubit.categories,
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.center,
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: primaryColor,
              border: Border.all(color: secondaryColor),
            ),
            child: Text(LocaleKeys.Save_Changes.tr(),
                style: TextStyle(
                  color: secondaryColor,
                  fontSize: 18,
                )),
          ),
        );
      },
    );
  }
}
