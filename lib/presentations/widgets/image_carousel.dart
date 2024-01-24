import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

Widget imageCarousel() {
  return CarouselSlider(
    options: CarouselOptions(
      height: 180.0,
      autoPlay: true,
      autoPlayInterval: const Duration(seconds: 5)
    ),
    items: [
      'https://flutterwocommerce.metrolifetech.com/wp-content/uploads/2021/12/Shoe-poster-1024x1024.jpg',
      'https://flutterwocommerce.metrolifetech.com/wp-content/uploads/2022/05/banner-m25-1.jpg',
      'https://flutterwocommerce.metrolifetech.com/wp-content/uploads/2021/12/cloth-sale.jpg'
    ].map((i) {
      return Builder(
        builder: (BuildContext context) {
          return InkWell(
    onTap: () {},
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      height: 130,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(image: NetworkImage(i), fit: BoxFit.fill)),
    ),
  );
        },
      );
    }).toList(),
  );
}