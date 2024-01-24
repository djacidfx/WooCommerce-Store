import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import '../../models/product.dart';
import '../screens/product_details.dart';

class HomeProductCard extends StatefulWidget {
  const HomeProductCard({Key? key, this.data}) : super(key: key);
  final Product? data;

  @override
  State<HomeProductCard> createState() => _HomeProductCardState();
}

class _HomeProductCardState extends State<HomeProductCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        pushNewScreen(
          context,
          screen: ProductDetails(
            product: widget.data,
            productName: widget.data!.name,
          ),
          withNavBar: false,
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        );
      },
      child: Column(
        children: [
          Stack(children: [
            Center(
              child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 1),
                  width: 120,
                  height: 155,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                      image: DecorationImage(
                        image: NetworkImage(
                          widget.data!.images![0].src!,
                        ),
                        fit: BoxFit.fill,
                      ))),
            ),
            Positioned(
              top: 7,
              left: 20,
              child: Visibility(
                  visible: widget.data!.calculateDiscount() > 0,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        '-${widget.data?.calculateDiscount()}%',
                        style: const TextStyle(
                          fontFamily: 'baloo da 2',
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  )),
            ),
          ]),
          Container(
            width: 100,
            alignment: Alignment.center,
            child: Column(
              children: [
                const SizedBox(
                  height: 3,
                ),
                Center(
                  child: Text(
                    widget.data!.name!,
                    maxLines: 2,
                    style: const TextStyle(
                      fontFamily: 'baloo da 2',
                      height: 1,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Text(
                  widget.data!.type == "variable"
                      ? (widget.data!.attributes![0].name! +
                          ": " +
                          widget.data!.attributes![0].options!.join("-").toString())
                      : '\$${widget.data!.regularPrice}',
                  style: TextStyle(
                    fontFamily: 'baloo da 2',
                    color: widget.data!.type == "variable" ? Colors.black : Colors.red,
                    fontSize: widget.data!.type == "variable" ? 12 : 14,
                    fontWeight: FontWeight.w600,
                    decoration: widget.data!.type == "variable" ? TextDecoration.none : TextDecoration.lineThrough,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  widget.data!.type == "variable" ? '\$${widget.data!.price}' : '\$${widget.data!.salePrice}',
                  style: const TextStyle(
                    fontFamily: 'baloo da 2',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
