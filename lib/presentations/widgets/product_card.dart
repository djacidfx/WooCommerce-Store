import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import '../../models/product.dart';
import '../screens/product_details.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({
    Key? key,
    required this.data,
  }) : super(key: key);

  final Product data;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        pushNewScreen(
          context,
          screen: ProductDetails(
            product: widget.data,
            productName: widget.data.name,
          ),
          withNavBar: false,
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        );
      },
      child: Column(
        children: [
          Badge(
            elevation: widget.data.calculateDiscount() > 0 ? 2 : 0,
            badgeColor: widget.data.calculateDiscount() > 0 ? Colors.red : Colors.transparent,
            badgeContent: widget.data.calculateDiscount() > 0 ?
             Text(
              '-${widget.data.calculateDiscount()}%',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.white,
                fontFamily: 'baloo da 2',
              ),
            ) : null,
            padding: const EdgeInsets.all(5),
            position: BadgePosition.topStart(top: 5, start: 10),
            child: Center(
              child: Container(
                  margin: const EdgeInsets.only(bottom: 5),
                  width: 160,
                  height: 185,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                      image: DecorationImage(
                        image: NetworkImage(
                          widget.data.images![0].src!,
                        ),
                        fit: BoxFit.fill,
                      ))),
            ),
          ),
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
                    widget.data.name!,
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
                  widget.data.type == "variable"
                      ? (widget.data.attributes![0].name! +
                          ": " +
                          widget.data.attributes![0].options!.join("-").toString())
                      : '\$${widget.data.regularPrice}',
                  style: TextStyle(
                    fontFamily: 'baloo da 2',
                    color: widget.data.type == "variable" ? Colors.black : Colors.red,
                    fontSize: widget.data.type == "variable" ? 12 : 14,
                    fontWeight: FontWeight.w600,
                    decoration: widget.data.type == "variable" ? TextDecoration.none : TextDecoration.lineThrough,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  widget.data.type == "variable" ? '\$${widget.data.price}' : '\$${widget.data.salePrice}',
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
