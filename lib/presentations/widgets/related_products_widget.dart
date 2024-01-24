import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:woocommerce/services/woocommerce_api_service.dart';

import '../../models/product.dart';
import '../screens/product_details.dart';

class RelatedProducts extends StatefulWidget {
  const RelatedProducts({Key? key, this.labelName, this.products})
      : super(key: key);

  final String? labelName;
  final List<int>? products;

  @override
  _RelatedProductsState createState() => _RelatedProductsState();
}

class _RelatedProductsState extends State<RelatedProducts> {
  WooApiService apiService = WooApiService();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              widget.labelName!,
              style: const TextStyle(
          fontFamily: 'Baloo Da 2',
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
        _productsList(),
      ],
    );
  }

  Widget _productsList() {
    return FutureBuilder(
        future: apiService.getProducts(productsIDs: widget.products),
        builder: (BuildContext context, AsyncSnapshot<List<Product>> model) {
          if (model.hasData) {
            return _buildList(model.data!);
          }

          return const Center(
            child: CircularProgressIndicator(color: Colors.red,)
          );
        });
  }

  Widget _buildList(List<Product> items) {
    return Container(
      height: 250,
      alignment: Alignment.centerLeft,
      child: ListView.builder(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: items.length,
          itemBuilder: (context, index) {
            var data = items[index];
            return InkWell(
              onTap: () {
                pushNewScreen(
                  context,
                  screen: ProductDetails(
                    product: data,
                    productName: data.name,
                  ),
                  withNavBar: false,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                      margin: const EdgeInsets.all(10),
                      width: 130,
                      height: 150,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                          image: DecorationImage(
                              image: NetworkImage(
                                data.images![0].src!,
                              ),
                              fit: BoxFit.fill))),
                  Container(
                    margin: const EdgeInsets.only(top: 5, left: 4),
                    width: 130,
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            data.name!,
                            maxLines: 2,
                            style: const TextStyle(
          fontFamily: 'Baloo Da 2',
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '\$${data.regularPrice}',
                              style: const TextStyle(
          fontFamily: 'Baloo Da 2',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.lineThrough,
                                color: Colors.red,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              '\$${data.salePrice}',
                              style: const TextStyle(
          fontFamily: 'Baloo Da 2',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
