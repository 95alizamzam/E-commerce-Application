import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_node/shared/app_cubit/cubit.dart';
import 'package:flutter_node/shared/app_cubit/cubit_states.dart';
import 'package:flutter_node/shared/styles.dart';

class filterSlider extends StatelessWidget {
  const filterSlider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<appCubit, appCubitStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = appCubit.get(context);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Text(
                'Min:',
                style: TextStyle(color: primaryColor),
              ),
              Expanded(
                child: RangeSlider(
                  min: 1,
                  max: 100,
                  divisions: 10,
                  labels: RangeLabels(
                    cubit.sliderSelectedValues.start.toString(),
                    cubit.sliderSelectedValues.end.toString(),
                  ),
                  activeColor: primaryColor,
                  inactiveColor: secondaryColor,
                  values: cubit.sliderSelectedValues,
                  onChanged: (val) {
                    cubit.setFilters(sliderValues: val, title: null);
                  },
                ),
              ),
              Text(
                'Max:',
                style: TextStyle(color: primaryColor),
              ),
              const SizedBox(width: 10),
            ],
          ),
        );
      },
    );
  }
}
