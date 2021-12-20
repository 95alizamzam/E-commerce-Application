import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_node/app_screens/home_screen.dart';
import 'package:flutter_node/app_screens/login_screen.dart';
import 'package:flutter_node/app_screens/register_screen.dart';

import 'package:flutter_node/shared/constants.dart';
import 'package:flutter_node/shared/user_cubit/cubit.dart';
import 'package:flutter_node/shared/user_cubit/cubit_state.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';

class splashScreen extends StatelessWidget {
  const splashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<userCubit, userCubitStates>(
      listener: (context, state) {
        if (state is hiddenSplachScreen) {
          goto(
            child: userToken == "" ? registerScreen() : homeScreen(),
            type: PageTransitionType.fade,
            context: context,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: HexColor('#13121a'),
          body: Container(
            child: Column(
              children: [
                //splach Screen image
                const Expanded(
                  flex: 3,
                  child: Image(
                    image: AssetImage('assets/images/appIcon.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),

                // Welcome paragraph and circle indicator
                Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Text(
                              'Welcome to online Shop',
                              style: TextStyle(
                                color: HexColor('#ffd700'),
                                fontSize: 20,
                              ),
                            ),
                          ),
                          CircularProgressIndicator(color: HexColor('#ffd700')),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        );
      },
    );
  }
}
