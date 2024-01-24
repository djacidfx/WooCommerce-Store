import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:woocommerce/presentations/widgets/progress_indicator_modal.dart';
import '../../models/product.dart';
import '../../services/providers/product_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/product_card_widget_listview.dart';

class ProductsByTagId extends StatefulWidget {
  const ProductsByTagId({Key? key, this.tagId, this.title}) : super(key: key);
  final String? tagId;
  final String? title;

  @override
  _ProductsByTagIdState createState() => _ProductsByTagIdState();
}

class _ProductsByTagIdState extends State<ProductsByTagId> {
  bool isGridview = true;
  int _page = 1;
  final ScrollController _scrollController = ScrollController();
  bool isApiCallProcess = false;

  @override
  void initState() {
    var productList = Provider.of<ProductProvider>(context, listen: false);
    productList.resetStreams();
    productList.setLoadingState(LoadMoreStatus.INITIAL);
    productList.fetchProducts(_page, tagId: widget.tagId);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        productList.setLoadingState(LoadMoreStatus.LOADING);
        productList.fetchProducts(++_page, tagId: widget.tagId);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            toolbarHeight: 50,
            backgroundColor: Colors.white,
            title: Text(
              widget.title!.toUpperCase(),
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black, fontFamily: 'baloo da 2'),
            ),
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.chevron_left_outlined, color: Colors.black)),
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
        body: WillPopScope(
          onWillPop: () async {
            Navigator.of(context).pop();
            return true;
          },
          child: ProgressModal(inAsyncCall: isApiCallProcess, opacity: 0.3, child: _productList()),
        ));
  }

  Widget _productList() {
    return Consumer<ProductProvider>(builder: (context, productsModel, child) {
      if (productsModel.allProducts!.isNotEmpty && productsModel.getLoadMoreStatus() != LoadMoreStatus.INITIAL) {
        return _buildList(productsModel.allProducts!, productsModel.getLoadMoreStatus() == LoadMoreStatus.LOADING);
      } else {
        if (productsModel.allProducts!.isNotEmpty && productsModel.getLoadMoreStatus() != LoadMoreStatus.INITIAL) {}
        return const Center(child: CircularProgressIndicator(color: Colors.red,));
      }
    });
  }

  Widget _buildList(List<Product> items, bool isLoadMore) {
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
                    children: items.map((Product item) {
                      return ProductCard(data: item);
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
                child: const Center(child: CircularProgressIndicator(color: Colors.red,))),
            visible: isLoadMore,
          )
        ],
      ),
    );
  }
}
