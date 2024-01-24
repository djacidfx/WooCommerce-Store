// ignore_for_file: prefer_null_aware_operators
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:woocommerce/presentations/widgets/snackbar.dart';
import '../../models/cart_request.dart';
import '../../models/product.dart';
import '../../models/variable_product.dart';
import '../../services/providers/cart_provider.dart';
import '../../services/providers/loader_provider.dart';
import '../../services/providers/wishlistprovider.dart';
import 'custom_stepper.dart';
import 'expand_text.dart';
import 'related_products_widget.dart';

class ProductDetailsWidget extends StatefulWidget {
  const ProductDetailsWidget({Key? key, this.data, this.variableProducts}) : super(key: key);

  final Product? data;
  final List<VariableProduct>? variableProducts;
  @override
  State<ProductDetailsWidget> createState() => _ProductDetailsWidgetState();

  static Widget selectDropdown(
    BuildContext context,
    Object initialValue,
    dynamic data,
    Function onChanged, {
    Function? onValidate,
  }) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
          height: 75,
          width: 100,
          padding: const EdgeInsets.only(top: 5),
          child: DropdownButtonFormField<VariableProduct>(
            hint: const Text("Select", style: TextStyle(fontFamily: 'Baloo Da 2', color: Colors.black)),
            isDense: true,
            value: null,
            decoration: fieldDecoration(context, "", ""),
            onChanged: (VariableProduct? newValue) {
              FocusScope.of(context).requestFocus(FocusNode());
              onChanged(newValue);
            },
            validator: (value) {
              return onValidate!(value);
            },
            items: data != null
                ? data.map<DropdownMenuItem<VariableProduct>>((VariableProduct data) {
                    return DropdownMenuItem<VariableProduct>(
                      value: data,
                      child: Text(data.attributes!.first.option! + " " + data.attributes!.first.name!,
                          style: const TextStyle(fontFamily: 'Baloo Da 2', color: Colors.red)),
                    );
                  }).toList()
                : null,
          )),
    );
  }

  static InputDecoration fieldDecoration(BuildContext context, String hintText, String helperText,
      {Widget? prefixIcon, Widget? suffixIcon}) {
    return InputDecoration(
        contentPadding: const EdgeInsets.only(top: 6, bottom: 6, left: 6, right: 4),
        hintText: hintText,
        hintStyle: const TextStyle(fontFamily: 'Baloo Da 2', color: Colors.black),
        helperText: helperText,
        helperStyle: const TextStyle(fontFamily: 'Baloo Da 2', color: Colors.black),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 1)),
        border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 1)));
  }
}

class _ProductDetailsWidgetState extends State<ProductDetailsWidget> {
  final CarouselController _controller = CarouselController();
  final int qty = 0;
  final CartProducts cartProducts = CartProducts();

  @override
  Widget build(BuildContext context) {
    // watch wishlist provider
    var wishlistProvider2 = context.watch<WishListProvider>();

    return SingleChildScrollView(
      child:
          Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
        productImages(widget.data!.images!, context),
        Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              //custom stepper and discount
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomStepper(
                    lowerLimit: 1,
                    upperLimit: 20,
                    stepValue: 1,
                    value: qty,
                    onChanged: (value) {
                      cartProducts.quantity = value;
                    },
                  ),
                  Visibility(
                      visible: widget.data!.calculateDiscount() > 0,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(color: Colors.red),
                          child: Text("${widget.data!.calculateDiscount()}% OFF",
                              style: const TextStyle(
                                  fontFamily: 'Baloo Da 2',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white)),
                        ),
                      )),
                ],
              ),
              //
              const SizedBox(height: 5),

              //name and price
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      widget.data!.name!,
                      style: const TextStyle(
                          fontFamily: 'Baloo Da 2', fontSize: 25, fontWeight: FontWeight.w500, color: Colors.black),
                    ),
                  ),
                  Text(
                    "\$${widget.data!.price}",
                    style: const TextStyle(
                        fontFamily: 'Baloo Da 2', fontSize: 25, color: Colors.black, fontWeight: FontWeight.w600),
                  )
                ],
              ),
              const SizedBox(height: 10),

              //variation and dropdown button
              Visibility(
                  visible: widget.data!.type == "variable",
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.data!.attributes!.isNotEmpty
                            ? (widget.data!.attributes![0].name! +
                                ": " +
                                widget.data!.attributes![0].options!.join("-").toString())
                            : "",
                        style: const TextStyle(fontFamily: 'Baloo Da 2', color: Colors.black),
                      ),
                      ProductDetailsWidget.selectDropdown(context, "", widget.variableProducts,
                          (VariableProduct value) {
                        widget.data!.price = value.price;
                        widget.data!.variableProduct = value;
                      })
                    ],
                  )),

              const SizedBox(
                height: 5,
              ),

              // Product details
              ExpandText(
                  labelHeader: "Product Details",
                  shortDesc: widget.data!.shortDescription,
                  desc: widget.data!.description),

              //cart button
              ElevatedButton(
                onPressed: () {
                  Provider.of<LoaderProvider>(context, listen: false).setLoadingStatus(true);
                  var cartProvider = Provider.of<CartProvider>(context, listen: false);

                  cartProducts.productId = widget.data!.id;
                  cartProducts.variationId =
                      widget.data!.variableProduct != null ? widget.data!.variableProduct!.id : 0;

                  cartProvider.addToCart(cartProducts, (val) {
                    Provider.of<LoaderProvider>(context, listen: false).setLoadingStatus(false);

                    snackbar(context, '✅ Product successfully added to cart', Colors.white, Colors.green);
                  });
                },
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Center(child: Icon(Icons.add_shopping_cart, color: Colors.white, size: 20)),
                          const SizedBox(width: 10),
                          Text(
                            "Add to Cart".toUpperCase(),
                            style: const TextStyle(
                                fontFamily: 'Baloo Da 2',
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )),
                style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    shape: const StadiumBorder(),
                    fixedSize: Size(MediaQuery.of(context).size.width, 40)),
              ),

              //save to wishlist btn
              FutureBuilder(
                future: wishlistProvider2.isSavedToWishList(widget.data!.id.toString()),
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  if (snapshot.data == false) {
                    debugPrint(snapshot.data.toString());

                    return ElevatedButton(
                      onPressed: () {
                        wishlistProvider2.addToWishlist(widget.data!.id.toString()).then((value) {
                          snackbar(context, '✅  ${widget.data!.name} has been added to your wishlist', Colors.white,
                              Colors.green);
                          setState(() {});
                        });
                      },
                      child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Center(child: Icon(Icons.favorite_border, color: Colors.white, size: 20)),
                                const SizedBox(width: 10),
                                Text(
                                  "save to wishlist".toUpperCase(),
                                  style: const TextStyle(
                                      fontFamily: 'Baloo Da 2',
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          )),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.black,
                          shape: const StadiumBorder(),
                          fixedSize: Size(MediaQuery.of(context).size.width, 40)),
                    );
                  } else {
                    return ElevatedButton(
                      onPressed: () {
                        wishlistProvider2.removeFromWishlist(widget.data!.id.toString()).then((value) {
                          snackbar(context, '🗑  ${widget.data!.name} has been removed from your wishlist',
                              Colors.white, Colors.black);
                          setState(() {});
                        });
                      },
                      child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Center(child: Icon(Icons.delete, color: Colors.white, size: 20)),
                                const SizedBox(width: 10),
                                Text(
                                  "remove from wishlist".toUpperCase(),
                                  style: const TextStyle(
                                      fontFamily: 'Baloo Da 2',
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          )),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.black,
                          shape: const StadiumBorder(),
                          fixedSize: Size(MediaQuery.of(context).size.width, 40)),
                    );
                  }
                },
              ),

              const Divider(
                color: Colors.black,
              ),
              const SizedBox(
                height: 10,
              ),

              //related products
              RelatedProducts(labelName: "You might also like", products: widget.data!.relatedIds)
            ],
          ),
        )
      ]),
    );
  }

  Widget productImages(List<Images> images, BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Container(
              alignment: Alignment.center,
              child: CarouselSlider.builder(
                itemCount: images.length,
                itemBuilder: (
                  context,
                  index,
                  // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
                  Null,
                ) {
                  return Center(
                    child: SizedBox(
                      height: 350,
                      width: MediaQuery.of(context).size.width,
                      child: Image.network(
                        images[index].src!,
                        fit: BoxFit.fill,
                      ),
                    ),
                  );
                },
                options: CarouselOptions(autoPlay: false, enlargeCenterPage: true, viewportFraction: 1, aspectRatio: 1),
                carouselController: _controller,
              )),
          Positioned(
              top: 160,
              child: IconButton(
                onPressed: () {
                  _controller.previousPage();
                },
                icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
              )),
          Positioned(
              top: 160,
              left: MediaQuery.of(context).size.width - 40,
              child: IconButton(
                onPressed: () {
                  _controller.nextPage();
                },
                icon: const Icon(Icons.arrow_forward_ios, color: Colors.black),
              )),
        ],
      ),
    );
  }
}
