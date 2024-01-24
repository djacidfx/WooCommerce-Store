import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart';
import 'package:woocommerce/presentations/widgets/progress_indicator_modal.dart';
import 'package:woocommerce/services/woocommerce_api_service.dart';
import '../../main.dart';
import '../../models/product.dart';
import '../../models/variable_product.dart';
import '../../services/providers/cart_provider.dart';
import '../../services/providers/loader_provider.dart';
import '../widgets/product_details_widget.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({Key? key, this.product, this.productName}) : super(key: key);
  final Product? product;
  final String? productName;

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  WooApiService apiService = WooApiService();

  @override
  Widget build(BuildContext context) {
    return Consumer<LoaderProvider>(builder: (context, loaderModel, child) {
      return Scaffold(
        appBar: _buildAppBar(),
        body: ProgressModal(child: pageUI(), inAsyncCall: loaderModel.isApiCallProcess, opacity: 0.3),
      );
    });
  }

  Widget pageUI() {
    return Container(
        child:
            widget.product!.type == "variable" ? _variableProductList() : ProductDetailsWidget(data: widget.product!));
  }

  Widget _variableProductList() {
    return FutureBuilder(
        future: apiService.getVariableProducts(widget.product!.id!),
        builder: (BuildContext context, AsyncSnapshot<List<VariableProduct>> model) {
          if (model.hasData) {
            return ProductDetailsWidget(
              data: widget.product!,
              variableProducts: model.data,
            );
          }

          return const Center(child: CircularProgressIndicator());
        });
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: true,
      title: Text(
        widget.productName!.toUpperCase(),
        style: const TextStyle(
          fontFamily: 'Baloo Da 2',
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
      leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.chevron_left,
            color: Colors.black,
          )),
      actions: [
        Badge(
          position: BadgePosition.topEnd(top: 5, end: -2),
            showBadge: Provider.of<CartProvider>(context, listen: false).cartItems!.isNotEmpty,
            badgeContent: Center(
              child: Text(
                Provider.of<CartProvider>(context, listen: false).cartItems!.length.toString(),
                style: const TextStyle(
                    fontFamily: 'Baloo Da 2', color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),
              ),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Base(index: 2,)));
              }, 
              icon: const Icon(
              Icons.shopping_cart,
              color: Colors.black,
            ),
            ),
            badgeColor: Colors.red,
            animationType: BadgeAnimationType.fade,
            animationDuration: const Duration(seconds: 1)),
        const SizedBox(
          width: 15,
        ),
      ],
    );
  }
}