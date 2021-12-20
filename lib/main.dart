import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_node/app_screens/splash_screen.dart';
import 'package:flutter_node/shared/app_cubit/cubit.dart';
import 'package:flutter_node/shared/constants.dart';
import 'package:flutter_node/shared/shared_prefrences/shared_prefrences.dart';
import 'package:flutter_node/shared/styles.dart';
import 'package:flutter_node/shared/user_cubit/cubit.dart';
import 'package:flutter_node/shared/user_cubit/cubit_state.dart';
import 'package:flutter_node/translations/codegen_loader.g.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:easy_localization/easy_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await sharedPrefrences.init();

  // sharedPrefrences.clearData();

  isDark = sharedPrefrences.getData(dataType: 'Bool', key: 'isDark') ?? true;
  userToken =
      sharedPrefrences.getData(key: 'storedToken', dataType: 'String') ?? "";
  tokenDate = sharedPrefrences.getData(key: 'tokenDate', dataType: 'Int') ?? 0;

  int primaryColorValue =
      sharedPrefrences.getData(key: 'primaryColor', dataType: 'Int') ?? 0;
  int secondaryColorValue =
      sharedPrefrences.getData(key: 'secondaryColor', dataType: 'Int') ?? 0;

  primaryColor =
      primaryColorValue == 0 ? HexColor('#ffd700') : Color(primaryColorValue);
  secondaryColor = secondaryColorValue == 0
      ? HexColor('#13121a')
      : Color(secondaryColorValue);

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarColor: Colors.black87,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  print(userToken);
  print(tokenDate);

  runApp(
    EasyLocalization(
      supportedLocales: [
        Locale('en'),
        Locale('ar'),
      ],
      path: 'assets/translations',
      fallbackLocale: Locale('en'),
      assetLoader: CodegenLoader(),
      errorWidget: (error) {
        return ErrorWidget(
          new Exception('Sorry, We can\'t Change The language now'),
        );
      },
      child: MyApp(isDark: isDark),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({Key? key, required this.isDark}) : super(key: key);
  final bool isDark;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => userCubit()
            ..disappearSplachScreen()
            ..getUserData()
            ..monitiringConnection(),
        ),
        BlocProvider(
          create: (_) => appCubit()
            ..getAllCategories()
            ..getAllProducts(),
        ),
      ],
      child: BlocConsumer<userCubit, userCubitStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(),
            // for Easy localization package
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            home: splashScreen(),
          );
        },
      ),
    );
  }
}
