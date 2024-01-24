import 'customer_detail.dart';

class OrderDetailModel {
  int? orderId;
  String? orderNumber;
  String? paymentMethodTitle;
  String? paymentMethod;
  String? orderStatus;
  DateTime? orderDate;
  Shipping? shipping;
  Billing? billing;
  List<LineItems>? lineItems;
  double? totalAmount;
  double? shippingTotal;
  double? itemTotalAmount;

  OrderDetailModel(
      {this.paymentMethod,
      this.paymentMethodTitle,
      this.lineItems,
      this.orderId,
      this.orderNumber,
      this.orderDate,
      this.orderStatus,
      this.shipping,
      this.totalAmount,
      this.shippingTotal,
      this.billing});

  OrderDetailModel.fromJson(Map<String, dynamic> json) {
    orderId = json['id'];
    orderNumber = json['order_key'];
    paymentMethod = json['payment_method'];
    paymentMethodTitle = json['payment_method_title'];
    orderStatus = json['status'];
    orderDate = DateTime.parse(json['date_created']);
    shipping =
        json['shipping'] != null ? Shipping.fromJson(json['shipping']) : null;
    billing =
        json['billing'] != null ? Billing.fromJson(json['billing']) : null;

    if (json['line_items'] != null) {
      lineItems = <LineItems>[];
      json['line_items'].forEach((v) {
        lineItems!.add(LineItems.fromJson(v));
      });

      itemTotalAmount = lineItems != null
          ? lineItems!.map<double?>((m) => m.totalAmount).reduce((a, b) => a! + b!)
          : 0;
    }

    totalAmount = double.parse(json['total']);
    shippingTotal = double.parse(json['shipping_total']);
  }
}

class LineItems {
  int? productId;
  int? quantity;
  int? variationId;
  String? productName;
  double? totalAmount;

  LineItems(
      {this.productId,
      this.quantity,
      this.variationId,
      this.productName,
      this.totalAmount});

  LineItems.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productName = json['name'];
    variationId = json['variation_id'];
    quantity = json['quantity'];
    totalAmount = double.parse(json['total']);
  }
}
