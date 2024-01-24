// ignore_for_file: deprecated_member_use
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:woocommerce/constants/api_constants.dart';
import 'package:woocommerce/presentations/screens/saved_cards_screen.dart';
import 'package:woocommerce/utils/print_to_console.dart';
import '../../../models/login_response.dart';
import '../../../utils/shared_prefs.dart';
import '../../widgets/unauth_widget.dart';
import '../address_screen.dart';
import '../delete_acct.dart';
import '../orders_screen.dart';
import '../reset_password.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  SharedPreferences? prefs;

  final String title = 'FWoo Stores';
  final String subject = '''FWoo Store is a demo ecemmerce app, built with Flutter, and uses WooCommerce as a backend

  Download now
  Android: https//play.google.com/store/apps/details?id=com.flutter.woocommerce
  ''';

  final _dialog = RatingDialog(
    initialRating: 5.0,
    starSize: 20,
    title: Text(
      'Rate Us'.toUpperCase(),
      style: const TextStyle(fontFamily: 'baloo da 2', fontWeight: FontWeight.w500, fontSize: 18),
      textAlign: TextAlign.center,
    ),
    // encourage your user to leave a high rating?
    message: Text(
      Platform.isAndroid ? 'Give us a 5 star rating on the Play Store' : 'Give us a 5 star rating on the App Store',
      style: const TextStyle(fontFamily: 'baloo da 2', fontWeight: FontWeight.normal, fontSize: 15.5),
      textAlign: TextAlign.center,
    ),
    // your app's logo?
    image: Image.asset(
      'assets/res/icon.png',
      height: 100,
      width: 100,
    ),
    onCancelled: () => printToConsole('cancelled'),
    onSubmitted: (response) {
      StoreRedirect.redirect(androidAppId: 'com.lds.borku_africa', iOSAppId: '');
    },
    submitButtonText: 'Submit',
  );


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: SharedService.isLoggedIn(),
        builder: (BuildContext context, AsyncSnapshot<bool> loginModel) {
          return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                centerTitle: true,
                title: const Text(
                  'My Account',
                  style: TextStyle(
                      fontFamily: 'baloo da 2', fontSize: 20, color: Colors.black, fontWeight: FontWeight.w500),
                ),
                ),
              body: loginModel.data == true ? _listView(context) : const UnAuthWidget());
        });
  }

  Widget _buildListTile(IconData leadingIcon, String optionTitle, String optionSubtitle, Function() onTap) {
    return Center(
      child: ListTile(
        leading: Icon(
          leadingIcon,
          color: Colors.black,
        ),
        contentPadding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
        onTap: onTap,
        title: Text(
          optionTitle,
          style:
              const TextStyle(fontFamily: 'baloo da 2', fontSize: 17, color: Colors.black, fontWeight: FontWeight.w500),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Text(
            optionSubtitle,
            style: const TextStyle(
                fontFamily: 'baloo da 2', fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w500),
          ),
        ),
        trailing: const Icon(Icons.keyboard_arrow_right, color: Colors.black),
      ),
    );
  }

  Widget _listView(BuildContext context) {
    return FutureBuilder(
        future: SharedService.loginDetails(),
        builder: (BuildContext context, AsyncSnapshot<LoginResponseModel?> loginModel) {
          if (loginModel.hasData) {
            return ListView(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(top: 10),
                        child: Text(
                          loginModel.data!.data!.firstName! + ' ' + loginModel.data!.data!.lastName!,
                          style: const TextStyle(
                              fontFamily: 'baloo da 2', fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                      Center(
                        child: Text(
                          loginModel.data!.data!.email!,
                          style: const TextStyle(
                            fontFamily: 'baloo da 2',
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  thickness: 2,
                ),
                Container(
                  margin: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      //order history
                      _buildListTile(Icons.shopping_cart, "Orders", "Check orders, order status and print invoice", () {
                        pushNewScreen(
                          context,
                          screen: const OrdersScreen(),
                          withNavBar:
                              false, // OPTIONAL VALUE. True by default.
                          pageTransitionAnimation:
                              PageTransitionAnimation.cupertino,
                        );
                      }),
                      //address
                      _buildListTile(
                          Icons.my_location, "Addresses", "Add or update your billing and shipping address(es)", () {
                        pushNewScreen(
                          context,
                          screen: AddressScreen(
                            email: loginModel.data!.data!.email!,
                            firstName: loginModel.data!.data!.firstName!,
                            lastName: loginModel.data!.data!.lastName!,
                          ),
                          withNavBar: false,
                          pageTransitionAnimation: PageTransitionAnimation.cupertino,
                        );
                      }),
                      //saved cards
                      _buildListTile(Icons.credit_card, "Saved Cards", "Add or remove cards for payment", () {
                        pushNewScreen(
                          context,
                          screen: const SavedCardsScreen(),
                          withNavBar: false,
                          pageTransitionAnimation: PageTransitionAnimation.cupertino,
                        );
                      }),
                      //customer care
                      _buildListTile(Icons.support_agent, "Customer Care",
                          "For complains, enquiries on order, purchases, etc, send us a mail", () async {
                        String mail = 'mailto:info@flutterwocommerce.metrolifetech.com?subject=&body=';
                        if (await canLaunch(mail)) {
                          // Launch the App
                          await launch(
                            mail,
                          );
                        } else {
                          // Handle Error
                          throw 'Could not launch $mail';
                        }
                      }),
                      //rate us
                      _buildListTile(Icons.rate_review, "Rate Us", "Click to give aus a 5 star rating on the app store",
                          () {
                        showDialog(
                          context: context,
                          barrierDismissible: true, // set to false if you want to force a rating
                          builder: (context) => _dialog,
                        );
                      }),
                      //share
                      _buildListTile(Icons.share, "Share", "Share app with friends, family and colleagues", () {
                        Share.share(title, subject: subject);
                      }),
                      //visit site
                      _buildListTile(Icons.web, "Visit FWo Demo Store Site", APIconstants.url.split('/w')[0], () async {
                        await launchUrl(
      Uri.parse(APIconstants.url.split('/w')[0]),
      mode: LaunchMode.inAppWebView,
      webViewConfiguration: const WebViewConfiguration(
        enableJavaScript : true,
      ),
    );
                      }),
                      //reset password
                      _buildListTile(Icons.lock, "Reset Password", "Change your password for security reasons", () {
                        pushNewScreen(
                          context,
                          screen: const ResetPasswordScreen(),
                          withNavBar: false,
                          pageTransitionAnimation: PageTransitionAnimation.cupertino,
                        );
                      }),
                      //delete acct
                      _buildListTile(Icons.delete_sweep, "Delete Account", "Permanently delete your account", () {
                        pushNewScreen(
                          context,
                          screen: DeleteAccount(
                            email: loginModel.data!.data!.email!,
                            username: loginModel.data!.data!.firstName! + ' ' + loginModel.data!.data!.lastName!,
                          ),
                          withNavBar: false, // OPTIONAL VALUE. True by default.
                          pageTransitionAnimation: PageTransitionAnimation.cupertino,
                        );
                      }),
                      //logout
                      _buildListTile(Icons.exit_to_app, "Log Out", "", () {
                        pushDynamicScreen(context,
                            withNavBar: true,
                            screen: showCupertinoDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CupertinoAlertDialog(
                                    title: const Text(
                                      "Log out?",
                                      style: TextStyle(
                                          fontFamily: 'baloo da 2', fontWeight: FontWeight.bold, fontSize: 18),
                                    ),
                                    content: const Text(
                                      "Do you want to log out your account from this device?",
                                      style: TextStyle(
                                          fontFamily: 'baloo da 2', fontWeight: FontWeight.w500, fontSize: 14),
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            SharedService.logout().then((value) => {setState(() {})});
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text(
                                            "Yes",
                                            style: TextStyle(fontFamily: 'baloo da 2', color: Colors.black),
                                          )),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text(
                                            "No",
                                            style: TextStyle(fontFamily: 'baloo da 2', color: Colors.black),
                                          )),
                                    ],
                                  );
                                }));
                      }),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(color: Colors.red),
            );
          }
        });
  }
}
