import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:woocommerce/services/woocommerce_api_service.dart';
import 'package:woocommerce/main.dart';
import '../../models/customer.dart';
import '../../utils/shared_prefs.dart';

class SocialLogin with ChangeNotifier {
  final _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _googleAccount;
  CustomerModel? customerModel;
  WooApiService apiService = WooApiService();
  bool isApiCallProcess = false;

  SharedPreferences? prefs;

  googleLogin(BuildContext context) async {
    _googleAccount = await _googleSignIn.signIn();
    customerModel = CustomerModel(
      firstName: _googleAccount!.displayName,
      email: _googleAccount!.email,
    );
    isApiCallProcess = true;
    await apiService.loginSocialCustomer(customerModel!.email ?? "").then((ret) {
      isApiCallProcess = false;
      if (ret.data != null) {
        debugPrint(customerModel.toString());
        SharedService.setLoginDetails(ret);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Logging you in. Please wait..."),
          duration: Duration(seconds: 3),
        ));
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const Base()));
      }
    });
    notifyListeners();
  }

  fblogin(BuildContext context) async {
    var result =
        await FacebookAuth.i.login(permissions: ["public_profile", "email"]);

    if (result.status == LoginStatus.success) {
      final requestData =
          await FacebookAuth.i.getUserData(fields: "email, name, picture");

      customerModel = CustomerModel(
        firstName: requestData["name"],
        email: requestData["email"],
      );
      isApiCallProcess = true;
      await apiService.loginSocialCustomer(customerModel!.email ?? "").then((ret) {
        isApiCallProcess = false;
        if (ret.data != null) {
          debugPrint(customerModel.toString());
          SharedService.setLoginDetails(ret);
    
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Logging you in. Please wait..."),
            duration: Duration(seconds: 3),
          ));
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const Base()));
        }
      });
      notifyListeners();
    }
  }

  logOut() async {
    _googleAccount = await _googleSignIn.signOut();
    await FacebookAuth.i.logOut();
    customerModel = null;
    notifyListeners();
  }

}
