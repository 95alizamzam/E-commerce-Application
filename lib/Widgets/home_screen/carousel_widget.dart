import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_node/shared/app_cubit/cubit.dart';
import 'package:flutter_node/shared/app_cubit/cubit_states.dart';

class carouselWidget extends StatelessWidget {
  const carouselWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<appCubit, appCubitStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = appCubit.get(context);
        return Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height / 5,
          child: CarouselSlider(
            items: cubit.appbanners,
            options: CarouselOptions(
              height: 100,
              autoPlay: true,
              enlargeCenterPage: true,
              initialPage: 0,
              viewportFraction: 0.4,
            ),
          ),
        );
      },
    );
  }
}
