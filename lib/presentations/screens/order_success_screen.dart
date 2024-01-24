import 'package:flutter/material.dart';
import 'package:woocommerce/main.dart';
import 'package:woocommerce/presentations/screens/orders_screen.dart';
import 'package:woocommerce/presentations/widgets/elevated_button.dart';
import 'package:woocommerce/utils/checkout_base.dart';

class OrderSuccessScreen extends CheckoutBase {
  const OrderSuccessScreen({Key? key}) : super(key: key);

  @override
  _OrderSuccessScreenState createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends CheckoutBaseState<OrderSuccessScreen> {
  @override
  void initState() {
    currentPage = 2;
    super.initState();
  }

  @override
  Widget pageUI() {
    return SizedBox(
        child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 5,
              )
            ]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Center(
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 100,
                  ),
                ),
                const Center(
                  child: Text(
                    'Order Successful',
                    style: TextStyle(fontSize: 18.0, fontFamily: 'baloo da 2', fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10.0),
                const Text(
                  'Your order has been placed successfully. We will notify you once your order is ready for collection.',
                  style: TextStyle(fontSize: 14.0, fontFamily: 'baloo da 2', fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20.0),
                elevatedButton(
                    icon: Icons.remove_red_eye, backgroundColor: Colors.red, text: 'View Order', onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const OrdersScreen()));
                    }),
                elevatedButton(
                    icon: Icons.done,
                    backgroundColor: Colors.green,
                    text: 'Done',
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context, MaterialPageRoute(builder: (context) => const MyApp()), (route) => false);
                    })
              ],
            )));
  }
}
