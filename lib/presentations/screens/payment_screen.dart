import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:woocommerce/presentations/screens/order_success_screen.dart';
import 'package:woocommerce/presentations/screens/saved_cards_screen.dart';
import 'package:woocommerce/presentations/widgets/progress_indicator_modal.dart';
import 'package:woocommerce/presentations/widgets/snackbar.dart';
import 'package:woocommerce/services/providers/cart_provider.dart';
import 'package:woocommerce/utils/print_to_console.dart';
import '../../models/credit_cards_model.dart';
import '../../models/customer_detail.dart';
import '../../models/login_response.dart';
import '../../services/providers/cards_provider.dart';
import '../../services/providers/email_provider.dart';
import '../../utils/checkout_base.dart';
import '../../utils/shared_prefs.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'dart:convert';
// import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
// import 'package:stripe_payment/stripe_payment.dart';
import 'package:flutter_paypal/flutter_paypal.dart';

class PaymentScreen extends CheckoutBase {
  final Billing? billing;
  final Shipping? shipping;

  const PaymentScreen({Key? key, this.billing, this.shipping}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends CheckoutBaseState<PaymentScreen> {
  int? customerId;
  String? customerEmail;
  String? username;
  LoginResponseModel? loginResponseModel;
  bool isLoading = false;
  bool? isNoCard;

  //paystack
  String publicKey = '';
  final plugin = PaystackPlugin();

  String? cardNumber1;
  String? cardNumber2;
  String? cardNumber3;

  String? paystackORstripe;

  static String apiBase = 'https://api.stripe.com/v1';
  static String paymentApiUrl = '$apiBase/payment_intents';
  // ignore: unused_field
  static String publishableKey = "";
  static String secretKey = '';
  Map<String, String> headers = {
    'Authorization': 'Bearer $secretKey',
    'Content-Type': 'application/x-www-form-urlencoded'
  };

  //for paypal
  bool? isPaymentSuccessful;

  //get customer id and email
  Future getCustomerDetails() async {
    loginResponseModel = await SharedService.loginDetails();
    setState(() {
      customerId = loginResponseModel!.data!.id;
      customerEmail = loginResponseModel!.data!.email;
      username = loginResponseModel!.data!.firstName! + ' ' + loginResponseModel!.data!.lastName!;
    });
  }

  //get if customer has any saved card
  Future getCards() async {
    var cardsProvider = context.watch<CardsProvider>();
    bool _isNoCard = await cardsProvider.isEmpty();
    setState(() {
      isNoCard = _isNoCard;
    });
  }

  //generate transaction id reference
  String _getReference() {
    var platform = (Platform.isIOS) ? 'iOS' : 'Android';
    final thisDate = DateTime.now().millisecondsSinceEpoch;
    return 'ChargedFrom${platform}_$thisDate';
  }

  //credit card flow.. for paystack and stripe
  Future creditCardFlow() async {
    if (isNoCard == true) {
      showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: const Text(
                'No Card Saved',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'baloo da 2',
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: const Text(
                'Please add a card to continue. Your data is saved to your device.',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'baloo da 2',
                  fontWeight: FontWeight.w500,
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    'Proceed',
                    style: TextStyle(
                      fontFamily: 'baloo da 2',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SavedCardsScreen(),
                      ),
                    );
                  },
                )
              ],
            );
          });
    } else {
      var cardsProvider = Provider.of<CardsProvider>(context, listen: false);

      showModalBottomSheet(
          context: context,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          isScrollControlled: true,
          enableDrag: true,
          builder: (_) {
            return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Column(
                  children: [
                    const Center(
                      child: Text(
                        'Select Card For Payment',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'baloo da 2',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Divider(
                      thickness: 1.5,
                      color: Colors.grey,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    FutureBuilder(
                      future: cardsProvider.getCard1(),
                      builder: (BuildContext context, AsyncSnapshot<CreditCardsModel> card1) {
                        return FutureBuilder(
                          future: cardsProvider.getCard2(),
                          builder: (BuildContext context, AsyncSnapshot<CreditCardsModel> card2) {
                            return FutureBuilder(
                              future: cardsProvider.getCard3(),
                              builder: (BuildContext context, AsyncSnapshot<CreditCardsModel> card3) {
                                if (card1.data != null) cardNumber1 = card1.data!.cardNumber!;
                                if (card2.data != null) cardNumber2 = card2.data!.cardNumber!;
                                if (card3.data != null) cardNumber3 = card3.data!.cardNumber!;

                                return SingleChildScrollView(
                                  child: Column(children: [
                                    card1.data == null
                                        ? Container()
                                        : buildCard(
                                            cardNumber: cardNumber1!,
                                            cardNumberConcealed: cardNumber1!.substring(0, 4) + ' **** **** ****',
                                            cardHolderName: card1.data!.cardHolderName!,
                                            expiryDate: card1.data!.expiryDate!,
                                            cvv: card1.data!.cvv!),
                                    card2.data == null
                                        ? Container()
                                        : buildCard(
                                            cardNumber: cardNumber2!,
                                            cardNumberConcealed: cardNumber2!.substring(0, 4) + ' **** **** ****',
                                            cardHolderName: card2.data!.cardHolderName!,
                                            expiryDate: card2.data!.expiryDate!,
                                            cvv: card2.data!.cvv!),
                                    card3.data == null
                                        ? Container()
                                        : buildCard(
                                            cardNumber: cardNumber3!,
                                            cardNumberConcealed: cardNumber3!.substring(0, 4) + ' **** **** ****',
                                            cardHolderName: card3.data!.cardHolderName!,
                                            expiryDate: card3.data!.expiryDate!,
                                            cvv: card3.data!.cvv!),
                                  ]),
                                );
                              },
                            );
                          },
                        );
                      },
                    )
                  ],
                ));
          });
    }
  }

  //!pay with Stripe
  // payWithStripe({
  //   required String cardNumber,
  //   required String cardHolderName,
  //   required String expiryDate,
  //   required String cvv,
  // }) async {
  //   var cartItems = Provider.of<CartProvider>(context, listen: false);
  //   cartItems.fetchCartItems();
  //   String _amount = (cartItems.totalAmount * 100).toString();
  //   setState(() {
  //     isLoading = true;
  //   });
  //   String _cardNumber = cardNumber.replaceAll(' ', '');
  //   //payment card details
  //   final CreditCard _card = CreditCard(
  //     name: cardHolderName,
  //     number: _cardNumber,
  //     expMonth: int.parse(expiryDate.split('/')[0]),
  //     expYear: int.parse(expiryDate.split('/')[1]),
  //     cvc: cvv,
  //     addressLine1: widget.billing!.address1,
  //     addressLine2: widget.billing!.address2,
  //     addressCity: widget.billing!.city,
  //     addressState: widget.billing!.state,
  //     addressZip: widget.billing!.postcode,
  //     addressCountry: widget.billing!.country,
  //   );
  //   try {
  //     //payment method
  //     var paymentMethod = await StripePayment.createPaymentMethod(PaymentMethodRequest(card: _card));
  //     //create intent
  //     var paymentIntent = await createPaymentIntent(_amount, 'USD');
  //     //confirm intent
  //     var response = await StripePayment.confirmPaymentIntent(
  //         PaymentIntent(clientSecret: paymentIntent!['client_secret'], paymentMethodId: paymentMethod.id));

  payWithStripe() {
    snackbar(context, 'Currently unavailable. Please use another payment method', Colors.white, Colors.black54);
  }

  //     if (response.status == 'succeeded') {
  //       printToConsole('Payment Successful');
  //       _onPaymentSuccessful(paymentMethod: 'Stripe', isPaid: true);
  //     } else {
  //       printToConsole('Payment Failed');
  //       setState(() {
  //         isLoading = false;
  //       });
  //     }
  //   } on PlatformException catch (e) {
  //     printToConsole(e.message!);
  //     setState(() {
  //       isLoading = false;
  //     });
  //   } catch (e) {
  //     printToConsole(e.toString());
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  Future<Map<String, dynamic>?> createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {'amount': amount, 'currency': currency, 'payment_method_types[]': 'card'};
      var response = await http.post(Uri.parse(paymentApiUrl), body: body, headers: headers);
      return jsonDecode(response.body);
    } catch (err) {
      printToConsole('err charging user: ${err.toString()}');
    }
    return null;
  }

  //!pay with paystack
  payWithPaystack({
    required String cardNumber,
    required String expiryDate,
    required String cvv,
  }) async {
    String expiryMonth = expiryDate.split('/')[0];
    int expiryYear = int.parse(expiryDate.substring(3, 5));

    var cartItems = Provider.of<CartProvider>(context, listen: false);
    cartItems.fetchCartItems();
    var charge = Charge()
      ..amount = cartItems.totalAmount * 100 * 514
      ..reference = _getReference()
      ..card = PaymentCard(number: cardNumber, cvc: cvv, expiryMonth: int.parse(expiryMonth), expiryYear: expiryYear)
      ..email = customerEmail;
    CheckoutResponse response = await plugin.checkout(
      context,
      method: CheckoutMethod.card,
      charge: charge,
      fullscreen: true,
      logo: Image.asset(
        'assets/res/icon.png',
        fit: BoxFit.contain,
        height: 50,
      ),
    );

    if (response.status == true) {
      printToConsole("Payment Succesful");
      if (paystackORstripe == 'paystack') {
        await _onPaymentSuccessful(paymentMethod: 'Paystack', isPaid: true);
      }
    } else {
      printToConsole("Payment Failed");
      setState(() {
        isLoading = false;
      });
    }
  }

  //!pay with paypal
  Future<bool?> payWithPayPal() async {
    var cartItems = Provider.of<CartProvider>(context, listen: false);
    cartItems.fetchCartItems();
    var totalAmount = cartItems.totalAmount;

    Navigator.of(context)
        .push(MaterialPageRoute(
      builder: (context) => UsePaypal(
          sandboxMode: true,
          clientId: '',
          secretKey: "",
          returnURL: "https://samplesite.com/return",
          cancelURL: "https://samplesite.com/cancel",
          transactions: [
            {
              "amount": {
                "total": totalAmount,
                "currency": "USD",
                "details": {"subtotal": totalAmount, "shipping": 0, "shipping_discount": 0}
              },
              "description": "Payment for reference ${_getReference()}.",
            }
          ],
          note: "Contact us for any questions on your order.",
          onSuccess: (data) {
            printToConsole('Payment Successful');
            isPaymentSuccessful = true;
            isLoading = true;
            printToConsole(isPaymentSuccessful.toString() + ' ' + isLoading.toString());
          },
          onError: (error) {
            isPaymentSuccessful = false;
            printToConsole("onError: $error");
            snackbar(context, 'Payment Failed!!! Try Again or use another payment method', Colors.white, Colors.red);
          },
          onCancel: (params) {
            isPaymentSuccessful = false;
            snackbar(context, 'Payment cancelled!!!', Colors.white, Colors.red);
            printToConsole('cancelled: $params');
          }),
    ))
        .then((value) {
      Future.delayed(const Duration(seconds: 5), () async {
        await _onPaymentSuccessful(paymentMethod: 'Paypal', isPaid: true);
      });
    });

    return isPaymentSuccessful;
  }

  //after payment, create order on server
  Future _onPaymentSuccessful({
    required String paymentMethod,
    required bool isPaid,
  }) async {
    var orderProvider = Provider.of<CartProvider>(context, listen: false);
    var emailProvider = Provider.of<EmailProvider>(context, listen: false);

    orderProvider.createOrder(
        customerId: customerId,
        paymentMethod: paymentMethod,
        isPaid: isPaid,
        transactionId: _getReference(),
        billing: widget.billing,
        shipping: widget.shipping);
    emailProvider.sendEmail(
        serviceId: '',
        templateId: '',
        userId: '',
        parameters: {
          'user_name': username,
          'user_email': customerEmail,
          'body': '''''
Customer name: ${widget.billing!.firstName} ${widget.billing!.lastName}
Customer email: $customerEmail
Customer id: $customerId
Order reference: ${_getReference()}
'''
        });
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const OrderSuccessScreen()));
    // snackbar(context, message, color, backgroundColor);
  }

  @override
  void initState() {
    currentPage = 1;
    getCustomerDetails();
    plugin.initialize(publicKey: publicKey); //init paystack
    // StripePayment.setOptions(StripeOptions(publishableKey: publishableKey, merchantId: "Test", androidPayMode: 'test'));
    super.initState();
  }

  @override
  Widget pageUI() {
    getCards();

    return ProgressModal(
      inAsyncCall: isLoading,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Center(
              child: Text(
                'Payment Options',
                style: TextStyle(fontSize: 18.0, fontFamily: 'baloo da 2', fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10.0),
            paymentOption(
                imagePath: 'assets/res/pay_on_delivery.png',
                title: 'Cash On Delivery',
                subtitle: 'Pay with cash upon delivery',
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text(
                            'Confirm',
                            style: TextStyle(fontFamily: 'baloo da 2', fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          content: const Text(
                            'Do you want to pay with cash upon delivery?',
                            style: TextStyle(fontFamily: 'baloo da 2', fontWeight: FontWeight.w500, fontSize: 16),
                          ),
                          actions: [
                            TextButton(
                              child: const Text(
                                'Proceed',
                                style: TextStyle(fontFamily: 'baloo da 2'),
                              ),
                              onPressed: () {
                                setState(() {
                                  isLoading = true;
                                });
                                _onPaymentSuccessful(paymentMethod: 'Cash On Delivery', isPaid: true);
                              },
                            ),
                            TextButton(
                              child: const Text(
                                'Cancel',
                                style: TextStyle(fontFamily: 'baloo da 2'),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      });
                }),
            paymentOption(
                imagePath: 'assets/res/paystack.png',
                title: 'Paystack',
                subtitle: 'Pay with credit or debit card via Paystack',
                onPressed: () {
                  setState(() {
                    paystackORstripe = 'paystack';
                  });
                  creditCardFlow();
                }),
            paymentOption(
                imagePath: 'assets/res/stripe.png',
                title: 'Stripe',
                subtitle: 'Pay with credit or debit card via Stripe',
                onPressed: () {
                  setState(() {
                    paystackORstripe = 'stripe';
                  });
                  creditCardFlow();
                }),
            paymentOption(
                imagePath: 'assets/res/paypal.png',
                title: 'Paypal',
                subtitle: 'Pay via Paypal',
                onPressed: () {
                  payWithPayPal();
                }),
            // paymentOption(
            //     imagePath: 'assets/res/gpay.jpg',
            //     title: 'Google Pay',
            //     subtitle: 'Pay with your Google account',
            //     onPressed: () {}),
            // paymentOption(
            //     imagePath: 'assets/res/apple_pay.png',
            //     title: 'Apple Pay',
            //     subtitle: 'Pay with your Apple account',
            //     onPressed: () {
            //       payWithApple();
            //     }),
          ],
        ),
      ),
    );
  }

  //build payment options widget
  Widget paymentOption({
    required String title,
    required String subtitle,
    required String imagePath,
    required Function onPressed,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      child: ListTile(
        leading: Container(
          width: 50.0,
          height: 50.0,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.fill,
              )),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, fontFamily: 'baloo da 2'),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, fontFamily: 'baloo da 2'),
        ),
        onTap: () {
          onPressed();
        },
        contentPadding: const EdgeInsets.all(5),
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  //build card liist
  Widget buildCard({
    required String cardNumber,
    required String cardNumberConcealed,
    required String cardHolderName,
    required String expiryDate,
    required String cvv,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        tileColor: Colors.grey[200],
        title: Text(
          cardHolderName,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, fontFamily: 'baloo da 2'),
        ),
        subtitle: Text(
          cardNumberConcealed,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, fontFamily: 'baloo da 2'),
        ),
        trailing: Text(
          expiryDate,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, fontFamily: 'baloo da 2'),
        ),
        onTap: () {
          Navigator.of(context).pop();
          showDialog(
              context: context,
              builder: (_) {
                return AlertDialog(
                  title: const Text(
                    'Confirm',
                    style: TextStyle(fontFamily: 'baloo da 2', fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  content: const Text(
                    'Do you want to pay with this card?',
                    style: TextStyle(fontFamily: 'baloo da 2', fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                  actions: [
                    TextButton(
                      child: const Text(
                        'Proceed',
                        style: TextStyle(fontFamily: 'baloo da 2'),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                          isLoading = true;
                        });
                        if (paystackORstripe == 'paystack') {
                          payWithPaystack(cardNumber: cardNumber, expiryDate: expiryDate, cvv: cvv);
                        } else {
                          payWithStripe();    
                          // payWithStripe(
                          //     cardNumber: cardNumber, expiryDate: expiryDate, cvv: cvv, cardHolderName: cardHolderName);
                        }
                      },
                    ),
                    TextButton(
                      child: const Text(
                        'Cancel',
                        style: TextStyle(fontFamily: 'baloo da 2'),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              });
        },
      ),
    );
  }
}
