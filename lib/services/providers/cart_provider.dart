import 'package:flutter/material.dart';
import 'package:woocommerce/utils/print_to_console.dart';
import '../../models/cart_request.dart';
import '../../models/cart_response.dart';
import '../../models/customer_detail.dart';
import '../../models/order.dart';
import '../../utils/shared_prefs.dart';
import '../woocommerce_api_service.dart';

class CartProvider with ChangeNotifier {
  WooApiService? _apiService;
  List<CartItem>? _cartItems;
  CustomerDetailsModel? _customerDetailsModel;
  OrderModel? _orderModel;
  bool _isOrderCreated = false;

  List<CartItem>? get cartItems => _cartItems;
  int get totalRecords => _cartItems!.length;
  int get totalAmount =>
      _cartItems != null ? _cartItems!.map<int>((e) => e.lineSubtotal!).reduce((value, element) => value + element) : 0;
  CustomerDetailsModel? get customerDetailsModel => _customerDetailsModel;
  OrderModel? get orderModel => _orderModel;
  bool get isOrderCreated => _isOrderCreated;

  CartProvider() {
    _apiService = WooApiService();
    _cartItems = <CartItem>[];
  }

  void resetStreams() {
    _apiService = WooApiService();
    _cartItems = <CartItem>[];
  }

  void addToCart(
    CartProducts products,
    Function onCallback,
  ) async {
    CartRequestModel requestModel = CartRequestModel();
    requestModel.products = <CartProducts>[];

    if (_cartItems == null) resetStreams();

    if (_cartItems == null) {
      await fetchCartItems();
    }

    for (var v in _cartItems!) {
      requestModel.products!.add(CartProducts(productId: v.productId, quantity: v.qty, variationId: v.variationId));
    }

    var isProductExist = requestModel.products!.firstWhere(
      (prd) => prd.productId == products.productId && prd.variationId == products.variationId,
      orElse: () => CartProducts(),
    );

    requestModel.products!.remove(isProductExist);

    requestModel.products!.add(products);

    await _apiService!.addtoCart(requestModel).then((cartResponseModel) {
      if (cartResponseModel.data != null) {
        _cartItems = [];
        _cartItems!.addAll(cartResponseModel.data!);
      }
      onCallback(cartResponseModel);
      notifyListeners();
    });
  }

  fetchCartItems() async {
    bool isLoggedIn = await SharedService.isLoggedIn();
    if (_cartItems == null) resetStreams();

    if (isLoggedIn) {
      await _apiService!.getCartItems().then((cartResponseModel) {
        if (cartResponseModel.data != null) {
          _cartItems!.clear();
          _cartItems!.addAll(cartResponseModel.data!);
        }
        notifyListeners();
      });
    }
  }

  void updateQty(int productId, int qty, {int variationId = 0}) {
    var isProductExist = _cartItems!
        .firstWhere((prd) => prd.productId == productId && prd.variationId == variationId, orElse: () => CartItem());
    isProductExist.qty = qty;
    notifyListeners();
  }

  updateCart() async {
    CartRequestModel requestModel = CartRequestModel();
    requestModel.products = <CartProducts>[];
    WooApiService apiService = WooApiService();

    if (_cartItems == null) resetStreams();

    for (var v in _cartItems!) {
      requestModel.products!.add(CartProducts(productId: v.productId, quantity: v.qty, variationId: v.variationId));
    }

    await apiService.addtoCart(requestModel).then((cartResponseModel) {
      if (cartResponseModel.data != null) {
        _cartItems = [];
        _cartItems!.addAll(cartResponseModel.data!);
      }
      // onCallback(cartResponseModel);
      notifyListeners();
    });
  }

  void removeCartItem(int productId) {
    var isProductExist = _cartItems!.firstWhere((prd) => prd.productId == productId, orElse: () => CartItem());
    _cartItems!.remove(isProductExist);
    notifyListeners();
  }

  // processOrder(OrderModel orderModel) {
  //   _orderModel = orderModel;
  //   notifyListeners();
  // }

  Future createOrder({
    required int? customerId,
    required String? paymentMethod,
    required bool? isPaid,
    required String? transactionId,
    required Billing? billing,
    required Shipping? shipping,
  }) async {
    //getting cart items
    fetchCartItems();

    _orderModel = OrderModel(
      customerId: customerId,
      paymentMethod: paymentMethod,
      paymentMethodTitle: paymentMethod,
      setPaid: isPaid,
      transactionId: transactionId, 
      lineItems: [],
      billing: billing,
      shipping: shipping
    );

    for (var v in _cartItems!) {
      _orderModel!.lineItems.add(LineItems(productId: v.productId, productName: v.productName, quantity: v.qty, variationId: v.variationId));
    }

    await _apiService!.createOrder(orderModel!).then((value) {
      if (value) {
        _isOrderCreated = true;
        printToConsole('Order Created');
        notifyListeners();
      }
    });
  }
}
