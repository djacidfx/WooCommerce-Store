import 'package:flutter/material.dart';
import 'package:woocommerce/utils/print_to_console.dart';
import '../../models/customer.dart';
import '../../models/customer_detail.dart';
import '../woocommerce_api_service.dart';

class CustomerDetailsProvider with ChangeNotifier {
  final WooApiService _apiService = WooApiService();
  Billing? billing;
  CustomerModel? _customerModel;
  CustomerModel? get customerModel => _customerModel;

  Future updateBillingDetails(
    String firstName_,
    String lastName_,
    String email_,
    BuildContext context, {
    required String firstName,
    required String lastName,
    required String company,
    required String address1,
    required String address2,
    required String city,
    required String state,
    required String postcode,
    required String country,
    required String email,
    required String phone,
  }) async {
    final _customerDetailsModel = CustomerModel(
      email: email_,
      firstName: firstName_,
      lastName: lastName_,
      billing: Billing(
        firstName: firstName,
        lastName: lastName,
        company: company,
        address1: address1,
        address2: address2,
        city: city,
        state: state,
        postcode: postcode,
        country: country,
        email: email,
        phone: phone,
      ),
    );
    await _apiService.updateAddress(_customerDetailsModel).then((value) {
      printToConsole('updateBillingDetails is successful');
    });
    notifyListeners();
  }

  Future updateShippingDetails(
    String firstName_,
    String lastName_,
    String email_,
    BuildContext context, {
    required String firstName,
    required String lastName,
    required String company,
    required String address1,
    required String address2,
    required String city,
    required String state,
    required String postcode,
    required String country,
  }) async {
    final _customerDetailsModel = CustomerModel(
      email: email_,
      firstName: firstName_,
      lastName: lastName_,
      shipping: Shipping(
        firstName: firstName,
        lastName: lastName,
        company: company,
        address1: address1,
        address2: address2,
        city: city,
        state: state,
        postcode: postcode,
        country: country,
      ),
    );
    await _apiService.updateAddress(_customerDetailsModel).then((value) {
      printToConsole('updateShippingDetails is successful');
    });
    notifyListeners();
  }

  Future<CustomerModel?> getCustomerDetails() async {
    _customerModel = await _apiService.getCustomerDetails();
    // printToConsole('Customer details: ${_customerModel?.toJson()}');
    return _customerModel;
  }

}
