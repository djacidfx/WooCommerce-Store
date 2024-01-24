import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:woocommerce/presentations/widgets/elevated_button.dart';
import 'package:woocommerce/presentations/widgets/progress_indicator_modal.dart';
import '../../../models/cart_response.dart';
import '../../../services/providers/cart_provider.dart';
import '../../../services/providers/loader_provider.dart';
import '../../../utils/shared_prefs.dart';
import '../../widgets/custom_stepper.dart';
import '../../widgets/unauth_widget.dart';
import '../verify_address.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool isLoading = false;
  bool isUpdateCartBtnClicked = false;
  Consumer<CartProvider>? cartProvider;

  initCart() {
    var cartItemsList = Provider.of<CartProvider>(context, listen: false);
    cartItemsList.fetchCartItems();
  }

  @override
  void initState() {
    super.initState();
    initCart();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: SharedService.isLoggedIn(),
        builder: (BuildContext context, AsyncSnapshot<bool> loginModel) {
          if (loginModel.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.red));
          } else {
            return Consumer<LoaderProvider>(builder: (context, loaderModel, child) {
              return Consumer<CartProvider>(builder: (context, cartModel, child) {
                return Scaffold(
                    bottomNavigationBar: !loginModel.hasData
                        ? null
                        : Container(
                            alignment: Alignment.topCenter,
                            height: isUpdateCartBtnClicked ? 130 : 80,
                            child: _buttomButtons(),
                          ),
                    backgroundColor: Colors.grey[200],
                    appBar: AppBar(
                      backgroundColor: Colors.white,
                      centerTitle: loginModel.hasData && cartModel.cartItems!.isNotEmpty ? false : true,
                      title: const Text(
                        'My Cart',
                        style: TextStyle(
                            fontFamily: 'baloo da 2', fontSize: 25, color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                      actions: [
                        loginModel.hasData && cartModel.cartItems!.isNotEmpty
                            ? Container(
                                alignment: Alignment.center,
                                margin: const EdgeInsets.only(right: 10),
                                child: Text(
                                  'Total: \$${cartModel.totalAmount}',
                                  style: const TextStyle(
                                      fontFamily: 'baloo da 2',
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                    body: !loginModel.hasData
                        ? const UnAuthWidget()
                        : ProgressModal(
                            child: _cartItemsList(),
                            inAsyncCall: loaderModel.isApiCallProcess,
                            opacity: 0.3,
                          ));
              });
            });
          }
        });
  }

  Widget _cartItemsList() {
    return Consumer<CartProvider>(
      builder: (context, cartModel, child) {
        if (cartModel.cartItems!.isNotEmpty) {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: cartModel.cartItems!.length,
                        itemBuilder: (context, index) {
                          return cartProductWidget(cartModel.cartItems![index]);
                        }),
                    const SizedBox(
                      height: 35,
                    ),
                  ],
                )
              ],
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: const [
              Icon(
                CommunityMaterialIcons.cart_remove,
                color: Colors.black,
                size: 100,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '''
Your Cart is currently empty. Visit the shop page to add products to your cart.
                  ''',
                style: TextStyle(fontFamily: 'baloo da 2', color: Colors.black, fontSize: 15),
                textAlign: TextAlign.center,
              ),
            ]),
          );
        }
      },
    );
  }

  Widget _buttomButtons() {
    return Consumer<CartProvider>(builder: (context, cartModel, child) {
      if (cartModel.cartItems!.isNotEmpty) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              //update cart button
              if (isUpdateCartBtnClicked)
                elevatedButton(
                  icon: Icons.sync,
                  text: 'Update Cart',
                  backgroundColor: Colors.white,
                  iconColor: Colors.black,
                  textColor: Colors.black,
                  onPressed: () {
                    Provider.of<LoaderProvider>(context, listen: false).setLoadingStatus(true);
                    var cartProvider = Provider.of<CartProvider>(context, listen: false);

                    cartProvider.updateCart().then((value) {
                      Provider.of<LoaderProvider>(context, listen: false).setLoadingStatus(false);
                      setState(() {
                        isUpdateCartBtnClicked = false;
                      });
                    });
                  },
                ),
              const SizedBox(
                height: 10,
              ),
              //checkout button
              elevatedButton(
                icon: Icons.shopping_cart_checkout,
                text: 'Checkout',
                onPressed: () {
                  pushNewScreen(
                    context,
                    screen: const VerifyAddress(),
                    withNavBar: false,
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                },
              ),
            ],
          ),
        );
      } else {
        return Container();
      }
    });
  }

  Widget cartProductWidget(CartItem data) {
    return Center(
      child: Card(
          elevation: 2.0,
          shadowColor: Colors.black,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Container(
              height: 100,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: makeCartProductWidgetList(context, data))),
    );
  }

  Widget makeCartProductWidgetList(BuildContext context, CartItem data) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 80,
              width: 80,
              child: Image.network(
                data.thumbnail!,
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(children: [
                Expanded(
                  child: Center(
                    child: Text(
                      data.variationId == 0
                          ? data.productName!
                          : "${data.productName} (${data.attributeValue}${data.attribute})",
                      style: const TextStyle(
                          fontFamily: 'baloo da 2', color: Colors.black, fontWeight: FontWeight.w500, fontSize: 18),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    data.productSalePrice!.isEmpty ? "\$${data.productRegularprice}" : "\$${data.productSalePrice}",
                    style: const TextStyle(fontFamily: 'baloo da 2', color: Colors.black, fontSize: 18),
                  ),
                ),
                Expanded(
                  child: CustomStepper(
                    lowerLimit: 0,
                    upperLimit: 20,
                    stepValue: 1,
                    value: data.qty!,
                    onChanged: (value) {
                      isUpdateCartBtnClicked = true;
                      Provider.of<CartProvider>(context, listen: false)
                          .updateQty(data.productId!, value, variationId: data.variationId!);
                    },
                  ),
                ),
              ]),
            ),
            IconButton(
                onPressed: () {
                  pushDynamicScreen(context,
                      withNavBar: true,
                      screen: showCupertinoDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CupertinoAlertDialog(
                              title: const Text(
                                "Remove Item",
                                style: TextStyle(fontFamily: 'baloo da 2', fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              content: const Text(
                                "Are you sure to delete this item from you cart?",
                                style: TextStyle(fontFamily: 'baloo da 2', fontWeight: FontWeight.w500, fontSize: 14),
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Provider.of<LoaderProvider>(context, listen: false).setLoadingStatus(true);
                                      Provider.of<CartProvider>(context, listen: false).removeCartItem(data.productId!);
                                      Provider.of<LoaderProvider>(context, listen: false).setLoadingStatus(false);
                                      var cartProvider = Provider.of<CartProvider>(context, listen: false);

                                      cartProvider.updateCart().then((value) {
                                        Provider.of<LoaderProvider>(context, listen: false).setLoadingStatus(false);
                                      });

                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      "Yes",
                                      style: TextStyle(fontFamily: 'baloo da 2', color: Colors.black),
                                    )),
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      "No",
                                      style: TextStyle(fontFamily: 'baloo da 2', color: Colors.black),
                                    )),
                              ],
                            );
                          }));
                },
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.black,
                  size: 25,
                ))
          ],
        ));
  }
} 