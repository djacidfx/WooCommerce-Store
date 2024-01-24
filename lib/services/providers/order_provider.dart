import 'package:flutter/material.dart';
import 'package:woocommerce/services/woocommerce_api_service.dart';

import '../../models/order.dart';

class OrderProvider with ChangeNotifier {
  WooApiService? _apiService;

  List<OrderModel>? _orderList;
  List<OrderModel>? get allOrders => _orderList;
  double get totalRecords => _orderList!.length.toDouble();

  OrderProvider() {resetStreams();}

  void resetStreams() {_apiService = WooApiService();}

  // fetchOrders() async {
  //   List<OrderModel> orderList = await _apiService!.getOrders();
  //   _orderList ??= <OrderModel>[];
  //   if (orderList.isNotEmpty) {
  //     _orderList = [];
  //     _orderList!.addAll(orderList);
  //   }
  //     notifyListeners();
  // }

  //fetch orders
  Future<List<OrderModel>> getProcessingOrders() async {
    return await _apiService!.getOrders(status: 'processing');
  }

  Future<List<OrderModel>> getShippingOrders() async {
    return await _apiService!.getOrders(status: 'on-hold');
  }

  Future<List<OrderModel>> getCompletedOrders() async {
    return await _apiService!.getOrders(status: 'completed');
  }

  Future<List<OrderModel>> getCancelledOrders() async {
    return await _apiService!.getOrders(status: 'cancelled');
  }

  //cancel order
  Future cancelOrder({required OrderModel model }) async {
    model.status = 'cancelled';
    await _apiService!.cancelOrder(model: model);
    notifyListeners();
  }

}