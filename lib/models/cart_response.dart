// ignore_for_file: unnecessary_null_comparison
class CartResponseModel {
  bool? status;
  List<CartItem>? data;

  CartResponseModel({this.status, this.data});

  CartResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <CartItem>[];
      json['data'].forEach((v) {
        data!.add(CartItem.fromJson(v));
      });
    }
  }
  
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CartItem {
  int? productId;
  String? productName;
  String? productRegularprice;
  String? productSalePrice;
  String? thumbnail;
  int? qty;
  int? lineSubtotal;
  int? lineTotal;
  int? variationId;
  String? attribute;
  String? attributeValue;

  CartItem(
      {this.productId,
      this.productName,
      this.productRegularprice,
      this.productSalePrice,
      this.thumbnail,
      this.qty,
      this.lineSubtotal,
      this.lineTotal,
      this.variationId,
      this.attribute,
      this.attributeValue
    });

  CartItem.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productName = json['product_name'];
    productRegularprice = json['product_regular_price'];
    productSalePrice = json['product_sale_price'];
    thumbnail = json['thumbnail'];
    qty = json['qty'];
    lineSubtotal = int.parse(json['line_subtotal'].toString());
    lineTotal = int.parse(json['line_total'].toString());
    variationId = json['variation_id'];
    attribute = (json['attribute'].toString() != "[]") ? Map<String, dynamic>.from(json['attribute']).keys.first.toString() : '' ;
    attributeValue = (json['attribute'].toString() != "[]") ? Map<String, dynamic>.from(json['attribute']).values.first.toString() : '' ;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['product_name'] = productName;
    data['product_regular_price'] = productRegularprice;
    data['product_sale_price'] = productSalePrice;
    data['thumbnail'] = thumbnail;
    data['qty'] = qty;
    data['line_subtotal'] = lineSubtotal;
    data['line_total'] = lineTotal;
    data['variation_id'] = variationId;

    return data;
  }
}