import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import '../../models/product.dart';
import '../screens/product_details.dart';

class ProductCardLV extends StatefulWidget {
  const ProductCardLV({Key? key, this.data})
      : super(key: key);
  final Product? data;

  @override
  State<ProductCardLV> createState() => _ProductCardLVState();
}

class _ProductCardLVState extends State<ProductCardLV> {

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
        child: Container(
            margin: const EdgeInsets.all(13),
            height: 120,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.all(5),
                  height: 120,
                  width: 130,
                  decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.grey[200]!,
                    width: 2
                  ),
                  image: DecorationImage(
                   image: NetworkImage(
                     widget.data!.images![0].src!,
                    ),
                       fit: BoxFit.fill,
                  )
                  )
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 3,),
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
                                  widget.data!.type == "variable" ?  (widget.data!.attributes![0].name! +  ": " + widget.data!.attributes![0].options! .join("-").toString()) : '\$${widget.data!.regularPrice}',
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
                                  widget.data!.type == "variable" ? '\$${widget.data!.price}' : '\$${widget.data?.salePrice}',
                                  style: const TextStyle(
          fontFamily: 'baloo da 2',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  textAlign: TextAlign.center,
                                ),
                                Visibility(
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
                                    '-${widget.data!.calculateDiscount()}%',
                                    style: const TextStyle(
          fontFamily: 'baloo da 2',
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                            )
                          ),
                              
                              ],
                            ),
                        
                  ),
                )

                

              ],
            ),
          ),
    );
  }        
}