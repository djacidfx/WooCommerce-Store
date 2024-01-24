import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:woocommerce/presentations/screens/products_by_tag_id.dart';
import '../../models/product.dart';
import '../../services/woocommerce_api_service.dart';
import 'home_product_card.dart';

class HomeProductSlider extends StatefulWidget {
  const HomeProductSlider({Key? key, required this.tagId, required this.title}) : super(key: key);
  final String tagId;
  final String title;

  @override
  _HomeProductSliderState createState() => _HomeProductSliderState();
}

class _HomeProductSliderState extends State<HomeProductSlider> {
  WooApiService apiService = WooApiService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: apiService.getProducts(tagId: widget.tagId),
      builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(top: 20),
            child: const CircularProgressIndicator(),
          );
        } else {
          return Container(
            margin: const EdgeInsets.only(top: 0, right: 5, left: 5, bottom: 5),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          pushNewScreen(
                            context,
                            screen: ProductsByTagId(
                              tagId: widget.tagId,
                              title: widget.title,
                            ),
                            withNavBar: false,
                            pageTransitionAnimation: PageTransitionAnimation.cupertino,
                          );
                        },
                        child: const Text(
                          'View All',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ))
                  ],
                ),
                _buildList(
                  snapshot.data!,
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildList(List<Product> items) {
    return SizedBox(
      height: 225,
      child: ListView(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: items.map((Product item) {
          return HomeProductCard(data: item);
        }).toList(),
      ),
    );
  }
}
