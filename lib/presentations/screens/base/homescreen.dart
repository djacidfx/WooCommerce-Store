import 'dart:async';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:woocommerce/models/product.dart';
import 'package:woocommerce/presentations/widgets/home_products_slider.dart';
import 'package:woocommerce/presentations/widgets/progress_indicator_modal.dart';
import '../../../services/providers/cart_provider.dart';
import '../../../services/providers/product_provider.dart';
import '../../widgets/image_carousel.dart';
import '../../widgets/product_card_widget_listview.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({ Key? key }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _page = 1;
  final ScrollController _scrollController = ScrollController();
  final bool _isApiCallProcess = false;
  final _searchQuery = TextEditingController();
  Timer? _debounce;
  bool isSearchBarClicked = false;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    var productList = Provider.of<ProductProvider>(context, listen: false);
    productList.resetStreams();
    productList.setLoadingState(LoadMoreStatus.INITIAL);
    productList.fetchProducts(_page);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        productList.setLoadingState(LoadMoreStatus.LOADING);
        productList.fetchProducts(++_page);
      }
    });

    _searchQuery.addListener(_onSearchChange);

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
        });
      }
    }).then((value) {
      Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
        });
      }
    });
    });

    super.initState();
  }

  _onSearchChange() {
    var productsList = Provider.of<ProductProvider>(
      context,
      listen: false,
    );
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 7000), () {
      productsList.resetStreams();
      productsList.setLoadingState(LoadMoreStatus.INITIAL);
      productsList.fetchProducts(_page, strSearch: _searchQuery.text);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppbar(),
      body: !isSearchBarClicked ? homeUI() : searchScreen(),
    );
  }

  //appbar
  PreferredSizeWidget myAppbar() {
    return AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          !isSearchBarClicked ? 'FWoo Store' : 'Search results',
          style: TextStyle(
              fontFamily: 'baloo da 2',
              fontWeight:
                  !isSearchBarClicked ? FontWeight.bold : FontWeight.w500,
              fontSize: !isSearchBarClicked ? 22.0 : 18,
              color: Colors.black),
        ),
        actions: [
          if (!isSearchBarClicked)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Badge(
                  showBadge: Provider.of<CartProvider>(context, listen: false)
                      .cartItems
                      !.isNotEmpty,
                  badgeContent: Center(
                    child: Text(
                      Provider.of<CartProvider>(context, listen: false)
                          .cartItems
                          !.length
                          .toString(),
                      style: const TextStyle(
                          fontFamily: 'baloo da 2',
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  child: const Icon(
                    Icons.shopping_cart,
                    color: Colors.black,
                  ),
                  badgeColor: Colors.red,
                  animationType: BadgeAnimationType.fade,
                  animationDuration: const Duration(seconds: 1)),
            ),
          if (!isSearchBarClicked)
            const SizedBox(
              width: 15,
            ),
          if (isSearchBarClicked)
            const Center(
              child: Text(
                'Close',
                style: TextStyle(
                    fontFamily: 'baloo da 2',
                    fontWeight: FontWeight.w500,
                    fontSize: 14.0,
                    color: Colors.black),
              ),
            ),
          if (isSearchBarClicked)
            IconButton(
                onPressed: () {
                  setState(() {
                    isSearchBarClicked = !isSearchBarClicked;
                  });
                },
                icon: const Icon(Icons.close, color: Colors.black))
        ]);
  }

  //searchbar
  Widget searchbar() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: _searchQuery,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.search,
        focusNode: focusNode,
        onEditingComplete: () {
          setState(() {
            isSearchBarClicked = !isSearchBarClicked;
          });
          var productsList =
              Provider.of<ProductProvider>(context, listen: false);
          if (_debounce?.isActive ?? false) _debounce!.cancel();
          productsList.resetStreams();
          productsList.setLoadingState(LoadMoreStatus.INITIAL);
          productsList.fetchProducts(_page, strSearch: _searchQuery.text);
          focusNode.unfocus();
        },
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.search,
              color: focusNode.hasFocus ? Colors.red : Colors.grey,
            ),
            hintText: "Search for anything",
            hintStyle: const TextStyle(
              fontFamily: 'baloo da 2',
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.transparent,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(15)),
            border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(15)),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.red
                ),
                borderRadius: BorderRadius.circular(15)),
            fillColor: Colors.white,
            filled: true),
      ),
    );
  }

  Widget homeUI() {
    return SingleChildScrollView(
      child: Column(
        children: [
          searchbar(),
          const SizedBox(height: 10,),
          imageCarousel(),
          const HomeProductSlider(tagId: '30', title: 'Promo Sales'),
          const HomeProductSlider(tagId: '31', title: 'Top Rated'),
          const HomeProductSlider(tagId: '32', title: 'Accessories'),
          const SizedBox(height: 10,),
        ]
      )
    );
  }

  Widget searchScreen() {
    return ProgressModal(
      inAsyncCall: _isApiCallProcess,
      opacity: 0.3,
      child: _productList(),
    );
  }

  Widget _productList() {
    return Consumer<ProductProvider>(builder: (context, productsModel, child) {
      if (productsModel.allProducts!.isNotEmpty &&
          productsModel.getLoadMoreStatus() != LoadMoreStatus.INITIAL) {
        return _buildList(productsModel.allProducts!,
            productsModel.getLoadMoreStatus() == LoadMoreStatus.LOADING);
      }

      return const Center(
        child: CircularProgressIndicator(color: Colors.red),
      );
    });
  }

  Widget _buildList(List<Product> items, bool isLoadMore) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            shrinkWrap: true,
            controller: _scrollController,
            physics: const ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
            children: items.map((Product item) {
              return ProductCardLV(data: item);
            }).toList(),
          ),
        ),
        Visibility(
          child: Container(
              padding: const EdgeInsets.all(5),
              height: 35.0,
              width: 35.0,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.red),
              )),
          visible: isLoadMore,
        )
      ],
    );
  }
}