import 'package:flutter/material.dart';
import 'package:woocommerce/services/woocommerce_api_service.dart';
import '../../utils/shared_prefs.dart';

class DeleteAccountProvider with ChangeNotifier {
  final WooApiService _apiService = WooApiService();

  Future deleteAccount() async {
    await _apiService.deleteAccount();
    SharedService.logout();
    notifyListeners();
  }
}
