// ignore_for_file: unnecessary_null_comparison

import 'customer_detail.dart';

class OrderModel {
  int? customerId;
  String? paymentMethod;
  String? paymentMethodTitle;
  bool? setPaid;
  String? transactionId;
  late List<LineItems> lineItems;

  int? orderId;
  String? orderNumber;
  String? status;
  DateTime? orderDate;
  Shipping? shipping;
  Billing? billing;

  double? totalAmount;
  double? shippingTotal;
  double? itemTotalAmount;

  OrderModel({
    this.customerId,
    this.paymentMethod,
    this.paymentMethodTitle,
    this.setPaid,
    this.transactionId,
    required this.lineItems,
    this.orderId,
    this.orderNumber,
    this.status,
    this.orderDate,
    this.shipping,
    this.billing,
    this.totalAmount,
    this.shippingTotal,
    this.itemTotalAmount,
  });

  OrderModel.fromJson(Map<String, dynamic> json) {
    customerId = json['customer_id'];
    paymentMethod = json['payment_method'];
    paymentMethodTitle = json['payment_method_title'];
    transactionId = json['transaction_id'];
    
    if (json['line_items'] != null) {
      lineItems = <LineItems>[];
      json['line_items'].forEach((v) {
        lineItems.add(LineItems.fromJson(v));
      });
      itemTotalAmount = lineItems != null
          ? lineItems.map<double?>((m) => m.totalAmount).reduce((a, b) => a! + b!)
          : 0;
    }
    orderId = json['id'];
    orderNumber = json['order_key'];
    status = json['status'];
    orderDate = DateTime.parse(json['date_created']);
    shipping = json['shipping'] != null ? Shipping.fromJson(json['shipping']) : null;
    billing = json['billing'] != null ? Billing.fromJson(json['billing']) : null;
    totalAmount = double.parse(json['total']);
    shippingTotal = double.parse(json['shipping_total']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customer_id'] = customerId;
    data['payment_method'] = paymentMethod;
    data['payment_method_title'] = paymentMethodTitle;
    data['set_paid'] = setPaid;
    data['transaction_id'] = transactionId;
    data['line_items'] = lineItems.map((v) => v.toJson()).toList();
    if (shipping != null) {
      data['shipping'] = shipping!.toJson();
    }
    if (billing != null) {
      data['billing'] = billing!.toJson();
    }
    return data;
  }
}

class LineItems {
  int? productId;
  String? productName;
  int? quantity;
  int? variationId;
  double? totalAmount;

  LineItems({
    this.productId,
    this.productName,
    this.quantity,
    this.variationId,
    this.totalAmount,
  });

  LineItems.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productName = json['name'];
    quantity = json['quantity'];
    variationId = json['variation_id'];
    totalAmount = double.parse(json['total']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['name'] = productName;
    data['quantity'] = quantity;
    if (variationId != null) {
      data['variation_id'] = variationId;
    }
    return data;
  }
}
