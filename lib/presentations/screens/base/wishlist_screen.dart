import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:woocommerce/presentations/widgets/progress_indicator_modal.dart';
import 'package:woocommerce/services/providers/wishlistprovider.dart';
import '../../../models/product.dart';
import '../../../services/providers/product_provider.dart';
import '../../../utils/print_to_console.dart';
import '../../widgets/product_card.dart';
import '../../widgets/product_card_widget_listview.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  _WishlistScreenState createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  bool isGridview = true;
  int _page = 1;
  final ScrollController _scrollController = ScrollController();
  bool isApiCallProcess = false;

  @override
  void initState() {
    var productList = Provider.of<ProductProvider>(context, listen: false);
    productList.resetStreams();
    productList.setLoadingState(LoadMoreStatus.INITIAL);
    productList.fetchProducts(
      _page,
    );

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        productList.setLoadingState(LoadMoreStatus.LOADING);
        productList.fetchProducts(
          ++_page,
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
            centerTitle: true,
            toolbarHeight: 50,
            backgroundColor: Colors.white,
            title: const Text(
              'Wishlist',
              style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black, fontFamily: 'baloo da 2'),
            ),
            elevation: 0,
            actions: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      isGridview = !isGridview;
                    });
                  },
                  icon: Icon(
                    isGridview ? Icons.list : CupertinoIcons.square_grid_3x2_fill,
                    color: Colors.black,
                  ))
            ]),
        body: ProgressModal(
          inAsyncCall: isApiCallProcess,
          opacity: 0.3,
          child: isWishlistEmpty(),
        ));
  }

  Widget isWishlistEmpty() {
    var wishlistProvider = context.watch<WishListProvider>();
    return FutureBuilder(
      future: wishlistProvider.isWishlistEmpty(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data == true) {
            return const Center(
              child: Text(
                'No items in wishlist',
                style:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'baloo da 2', color: Colors.black),
              ),
            );
          } else {
            return _productList();
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _productList() {
    return Consumer<ProductProvider>(builder: (context, productsModel, child) {
      if (productsModel.allProducts!.isNotEmpty && productsModel.getLoadMoreStatus() != LoadMoreStatus.INITIAL) {
        return _buildList(productsModel.allProducts!, productsModel.getLoadMoreStatus() == LoadMoreStatus.LOADING);
      } else {
        if (productsModel.allProducts!.isNotEmpty && productsModel.getLoadMoreStatus() != LoadMoreStatus.INITIAL) {}
        return const Center(
            child: CircularProgressIndicator(
          color: Colors.red,
        ));
      }
    });
  }

  Widget _buildList(List<Product> items, bool isLoadMore) {
    var wishlistProvider = context.watch<WishListProvider>();

    return FutureBuilder(
      future: wishlistProvider.getWishlistProductIDs(),
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        printToConsole(snapshot.data.toString());
        
        return Container(
          margin: const EdgeInsets.only(top: 10),
          color: Colors.grey[200],
          child: Column(
            children: [
              isGridview
                  ? Expanded(
                      child: GridView.count(
                        shrinkWrap: true,
                        controller: _scrollController,
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        physics: const ClampingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        children: items.where((element) {
                          return snapshot.data!.contains(element.id.toString());
                        }).map((Product item) {
                          return ProductCard(
                            data: item,
                          );
                        }).toList(),
                      ),
                    )
                  : Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        controller: _scrollController,
                        physics: const ClampingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        children: items.where((element) {
                          return snapshot.data!.contains(element.id.toString());
                        }).map((Product item) {
                          return ProductCardLV(
                            data: item,
                          );
                        }).toList(),
                      ),
                    ),
              Visibility(
                visible: isLoadMore,
                child: Container(
                    padding: const EdgeInsets.all(5),
                    height: 35.0,
                    width: 35.0,
                    child: const Center(
                        child: CircularProgressIndicator(
                      color: Colors.red,
                    ))),
              )
            ],
          ),
        );
      },
    );
  }
}