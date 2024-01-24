import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:woocommerce/presentations/screens/products_by_category.dart';
import 'package:woocommerce/presentations/widgets/progress_indicator_modal.dart';
import 'package:woocommerce/utils/print_to_console.dart';
import '../../../models/category.dart';
import '../../../models/product.dart';
import '../../../services/providers/product_provider.dart';
import '../../widgets/product_card.dart';
import '../../widgets/product_card_widget_listview.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({Key? key}) : super(key: key);

  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  bool isGridview = true;
  bool isPopular = false;
  bool isNewest = false;
  bool isPriceAsc = false;
  bool isPriceDesc = false;
  bool isSearchBarClicked = false;
  int _page = 1;
  final ScrollController _scrollController = ScrollController();
  bool isApiCallProcess = false;
  final _searchQuery = TextEditingController();
  Timer? _debounce;
  bool _showBackToTopButton = false;

  @override
  void initState() {
    _scrollController.addListener(() {
      setState(() {
        if (_scrollController.offset >= 400) {
          _showBackToTopButton = true; // show the back-to-top button
        } else {
          _showBackToTopButton = false; // hide the back-to-top button
        }
      });
    });

    var productProvider = Provider.of<ProductProvider>(context, listen: false);
    productProvider.resetStreams();
    productProvider.setLoadingState(LoadMoreStatus.INITIAL);
    productProvider.fetchProducts(_page);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        productProvider.setLoadingState(LoadMoreStatus.LOADING);
        productProvider.fetchProducts(++_page);
      }
    });

    _searchQuery.addListener(_onSearchChange);

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

  FocusNode focusNode = FocusNode();

  void _scrollToTop() {
    _scrollController.animateTo(0, duration: const Duration(seconds: 1), curve: Curves.linear);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _showBackToTopButton == false
          ? null
          : FloatingActionButton(
              onPressed: _scrollToTop,
              child: const Icon(Icons.arrow_upward),
            ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: !isSearchBarClicked
            ? const Text(
                'Shop - All Products',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              )
            : Container(
                margin: const EdgeInsets.only(top: 5),
                height: 40,
                child: TextField(
                  controller: _searchQuery,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.search,
                  focusNode: focusNode,
                  onEditingComplete: () {
                    var productsList = Provider.of<ProductProvider>(context, listen: false);
                    if (_debounce?.isActive ?? false) _debounce!.cancel();
                    productsList.resetStreams();
                    productsList.setLoadingState(LoadMoreStatus.INITIAL);
                    productsList.fetchProducts(_page, strSearch: _searchQuery.text);
                    focusNode.unfocus();
                  },
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: "Search",
                      hintStyle: const TextStyle(
                        fontFamily: 'baloo da 2',
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black54,
                          width: 1,
                        ),
                      ),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                      fillColor: Colors.grey[200],
                      filled: true),
                ),
              ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              !isSearchBarClicked ? Icons.search : Icons.cancel,
              color: Colors.black,
            ),
            onPressed: () {
              setState(() {
                isSearchBarClicked = !isSearchBarClicked;
              });
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey[200],
      body: ProgressModal(
        inAsyncCall: isApiCallProcess,
        opacity: 0.3,
        child: _productList(),
      ),
    );
  }

  Widget _productList() {
    return Consumer<ProductProvider>(builder: (context, productsModel, child) {
      if (productsModel.allProducts!.isNotEmpty && productsModel.getLoadMoreStatus() != LoadMoreStatus.INITIAL) {
        return _buildList(productsModel.allProducts!, productsModel.getLoadMoreStatus() == LoadMoreStatus.LOADING);
      }

      return const Center(
          child: CircularProgressIndicator(
        color: Colors.red,
      ));
    });
  }

  Widget _buildList(List<Product> items, bool isLoadMore) {
    var productProvider = Provider.of<ProductProvider>(context);

    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width,
          height: 50,
          child: Container(
              color: Colors.grey[200],
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: MediaQuery.of(context).size.width,
              height: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: filterBottomSheet,
                    child: Row(
                      children: const [
                        Icon(
                          Icons.filter_list,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text('Filters',
                            style: TextStyle(fontFamily: 'baloo da 2', fontWeight: FontWeight.w500, fontSize: 16)),
                      ],
                    ),
                  ),
                  Text(
                      isNewest
                          ? 'Newest'
                          : isPriceAsc
                              ? 'Price: Lowest to Highest'
                              : isPriceDesc
                                  ? 'Price: Highest to Lowest'
                                  : 'Popular',
                      style: const TextStyle(fontFamily: 'baloo da 2', fontWeight: FontWeight.w500, fontSize: 16)),
                  InkWell(
                      onTap: () {
                        setState(() {
                          isGridview = !isGridview;
                        });
                      },
                      child: Icon(isGridview ? Icons.list : CupertinoIcons.square_grid_3x2_fill))
                ],
              )),
        ),

        Container(
          margin: const EdgeInsets.only(top: 5),
          child: FutureBuilder(
            future: productProvider.getCategories(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                List<Category> categories = snapshot.data;
                printToConsole(categories.toString());
                return SizedBox(
                  height: 70,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      Category category = categories[index];
                      return buildCategoryList(
                        categoryName: category.categoryName!,
                        imageURL: category.image!.url!,
                        categoryId: category.categoryId.toString(),
                      );
                    },
                  ),
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),

        const SizedBox(
          height: 10,
        ),

        //gridview
        isGridview
            ? Expanded(
                child: GridView.count(
                  shrinkWrap: true,
                  controller: _scrollController,
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  physics: const ClampingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  children: items.map((Product item) {
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
                  children: items.map((Product item) {
                    return ProductCardLV(
                      data: item,
                    );
                  }).toList(),
                ),
              ),

        Visibility(
          child: Container(
              padding: const EdgeInsets.all(5),
              height: 35.0,
              width: 35.0,
              child: const Center(
                  child: CircularProgressIndicator(
                color: Colors.red,
              ))),
          visible: isLoadMore,
        )
      ],
    );
  }

  Future filterBottomSheet() {
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      // barrierColor: Colors.black,
      builder: (context) => SingleChildScrollView(
          controller: ModalScrollController.of(context),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Container(
                  color: Colors.grey,
                  height: 3,
                  width: 50,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text('Sort by',
                    style: TextStyle(fontFamily: 'baloo da 2', fontWeight: FontWeight.w500, fontSize: 22)),
                const SizedBox(
                  height: 25,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        isPopular = !isPopular;
                      });
                      Navigator.of(context).pop();
                      var productsList = Provider.of<ProductProvider>(context, listen: false);
                      productsList.resetStreams();
                      productsList.setSortOrder(SortBy("popularity", "Popularity", "asc"));
                      productsList.fetchProducts(_page);
                    },
                    child: const Text('Popular',
                        style: TextStyle(fontFamily: 'baloo da 2', fontWeight: FontWeight.w500, fontSize: 18)),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        isNewest = !isNewest;
                      });
                      Navigator.of(context).pop();
                      var productsList = Provider.of<ProductProvider>(context, listen: false);
                      productsList.resetStreams();
                      productsList.setSortOrder(SortBy("modified", "Latest", "desc"));
                      productsList.fetchProducts(_page);
                    },
                    child: const Text('Newest',
                        style: TextStyle(fontFamily: 'baloo da 2', fontWeight: FontWeight.w500, fontSize: 18)),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        isPriceAsc = !isPriceAsc;
                      });
                      Navigator.of(context).pop();
                      var productsList = Provider.of<ProductProvider>(context, listen: false);
                      productsList.resetStreams();
                      productsList.setSortOrder(SortBy("price", "Price: Low to High", "asc"));
                      productsList.fetchProducts(_page);
                    },
                    child: const Text('Price: Lowest to Highest',
                        style: TextStyle(fontFamily: 'baloo da 2', fontWeight: FontWeight.w500, fontSize: 18)),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      var productsList = Provider.of<ProductProvider>(context, listen: false);
                      productsList.resetStreams();
                      productsList.setSortOrder(SortBy("price", "Price: High to Low", "desc"));
                      productsList.fetchProducts(_page);
                    },
                    child: const Text('Price: Highest to Lowest',
                        style: TextStyle(fontFamily: 'baloo da 2', fontWeight: FontWeight.w500, fontSize: 18)),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          )),
    );
  }

  Widget buildCategoryList({required String categoryName, required String imageURL, required String categoryId}) {
    return InkWell(
      onTap: () {
        pushNewScreen(
          context,
          screen: ProductByCategoryScreen(categoryId: categoryId, categoryName: categoryName),
          withNavBar: false,
        );
      },
      child: Container(
        margin: const EdgeInsets.only(
          right: 10,
        ),
        child: Column(
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1),
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(imageURL),
                    fit: BoxFit.fill,
                  )),
            ),
            Center(
                child: Text(categoryName,
                    style: const TextStyle(fontFamily: 'baloo da 2', fontWeight: FontWeight.w500, fontSize: 12))),
          ],
        ),
      ),
    );
  }

}
