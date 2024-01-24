import 'customer_detail.dart';

class CustomerModel {
  int? id;
  String? email;
  String? firstName;
  String? lastName;
  String? password;
  Billing? billing;
  Shipping? shipping;

  CustomerModel({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.password,
    this.billing,
    this.shipping,
  });

  CustomerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    password = json['password'];
    billing = json['billing'] != null ? Billing.fromJson(json['billing']) : null;
    shipping = json['shipping'] != null ? Shipping.fromJson(json['shipping']) : null;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};

    map.addAll({
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'password': password,
      'username': email,
      'billing': billing?.toJson(),
      'shipping': shipping?.toJson(),
    });
    return map;
  }
}
