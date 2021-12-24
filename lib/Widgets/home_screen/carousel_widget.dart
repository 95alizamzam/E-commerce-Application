import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class carouselWidget extends StatelessWidget {
  carouselWidget({Key? key}) : super(key: key);

  List<Widget> appbanners = const [
    Image(image: AssetImage('assets/banners/banner1.jpg')),
    Image(image: AssetImage('assets/banners/banner2.jpg')),
    Image(image: AssetImage('assets/banners/banner3.jpg')),
    Image(image: AssetImage('assets/banners/banner4.jpg')),
    Image(image: AssetImage('assets/banners/b1.png')),
    Image(image: AssetImage('assets/banners/b2.jpg')),
    Image(image: AssetImage('assets/banners/b3.jpg')),
    Image(image: AssetImage('assets/banners/b4.png')),
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height / 5,
      child: CarouselSlider(
        items: appbanners,
        options: CarouselOptions(
          viewportFraction: 0.4,
          disableCenter: true,
          scrollPhysics: ScrollPhysics(
            parent: const BouncingScrollPhysics(),
          ),
          autoPlay: true,
          enlargeCenterPage: true,
          initialPage: 0,
          pageSnapping: true,
          pauseAutoPlayOnTouch: true,
          autoPlayCurve: Curves.fastOutSlowIn,
          autoPlayAnimationDuration: Duration(milliseconds: 800),
        ),
      ),
    );
  }
}
