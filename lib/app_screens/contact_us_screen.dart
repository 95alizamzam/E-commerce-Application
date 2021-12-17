import 'package:flutter/material.dart';
import 'package:flutter_node/app_screens/settings_screen.dart';
import 'package:flutter_node/shared/constants.dart';
import 'package:flutter_node/shared/styles.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';

class contactUs extends StatelessWidget {
  const contactUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle sty = TextStyle(fontSize: 18, color: primaryColor);
    return SafeArea(
      bottom: true,
      top: true,
      child: Scaffold(
        backgroundColor: secondaryColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: secondaryColor,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: primaryColor,
            ),
            onPressed: () {
              goto(
                child: settingsScreen(),
                type: PageTransitionType.fade,
                context: context,
              );
            },
          ),
          titleSpacing: 0,
          title: Text(
            'Contact us',
            style: TextStyle(color: primaryColor),
          ),
        ),
        body: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 4,
              width: double.infinity,
              child: Image(
                image: AssetImage('assets/images/contact_us.png'),
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 8,
              color: HexColor('#47b8e0'),
            ),
            Expanded(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: HexColor('#47b8e0'),
                    ),
                    Text(
                      'Iraq,Erbil city, 40 Street',
                      style: sty,
                    ),
                    Icon(
                      Icons.phone_android,
                      color: HexColor('#47b8e0'),
                    ),
                    Text('(964) 751 547 7206', style: sty),
                    Icon(
                      Icons.email,
                      color: HexColor('#47b8e0'),
                    ),
                    Text('alizamzamacc@gmail.com', style: sty),
                    Icon(
                      Icons.schedule,
                      color: HexColor('#47b8e0'),
                    ),
                    Text('Saturday - Tuesday', style: sty),
                    Text('9:00 am - 10:00 pm', style: sty),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
