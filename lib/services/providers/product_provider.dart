import 'package:flutter/material.dart';
import 'package:woocommerce/services/woocommerce_api_service.dart';
import '../../models/category.dart';
import '../../models/product.dart';

class SortBy {
  String value;
  String text;
  String sortOrder;

  SortBy(this.value, this.text, this.sortOrder);
}

// ignore: constant_identifier_names
enum LoadMoreStatus {INITIAL, LOADING, STABLE}

class ProductProvider with ChangeNotifier {
  WooApiService? _apiService;
  List<Product>? _productList;
  SortBy? _sortBy;

  int pageSize = 20;

  List<Product>? get allProducts => _productList;
  int get totalRecords => _productList!.length;

  LoadMoreStatus _loadMoreStatus = LoadMoreStatus.STABLE;
  getLoadMoreStatus() => _loadMoreStatus;

  ProductProvider() {
    resetStreams();
    _sortBy = SortBy("modified", "latest", "asc");
  }

  void resetStreams() {
    _apiService = WooApiService();
    _productList = <Product>[];
  }

  setLoadingState(LoadMoreStatus loadMoreStatus) {
    _loadMoreStatus = loadMoreStatus;
    // notifyListeners();
  }

  setSortOrder(SortBy sortBy) {
    _sortBy = sortBy;
    notifyListeners();
  }

  fetchProducts(pageNumber, {
    String? strSearch,
    String? tagId,
    String? categoryId,
    String? sortBy,
    String sortOrder = "asc",
    List<int>? productIDs,

  }) async {
    List<Product> itemModel = await _apiService!.getProducts(
      strSearch: strSearch,
      tagId: tagId,
      pageNumber: pageNumber,
      pageSize: pageSize,
      categoryId: categoryId,
      sortBy: _sortBy!.value,
      sortOrder: _sortBy!.sortOrder,
      productsIDs: productIDs,
    );

    if (itemModel.isNotEmpty) {
      _productList!.addAll(itemModel);
    }

    setLoadingState(LoadMoreStatus.STABLE);
    notifyListeners();
  }

  //fetch categories
  Future<List<Category>> getCategories() async {
    return await _apiService!.getCategories();
  }

  // List get catAllProducts => _apiService!.getCategories() as List;

  //get single product
  Future<Product> getProduct(int id) async {
    return await _apiService!.getProduct(productId: id);
  }

}