import 'package:flutter/material.dart';
import 'package:woocommerce/presentations/widgets/orders_cancelled.dart';
import 'package:woocommerce/presentations/widgets/orders_delivered.dart';
import 'package:woocommerce/presentations/widgets/orders_processing.dart';
import 'package:woocommerce/presentations/widgets/orders_shipping.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({ Key? key }) : super(key: key);

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
    length: 4,
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
            backgroundColor: Colors.white,
            centerTitle: true,
            toolbarHeight: 55,
            title: const Text(
              'My Orders',
              style:
                  TextStyle(fontFamily: 'baloo da 2', fontSize: 20, color: Colors.black, fontWeight: FontWeight.w500),
            ),
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                )),
            bottom: const TabBar(
              isScrollable: true,
              indicatorColor: Colors.red,
              tabs: [
                Tab(
                  child: Text(
                    'Processing',
                    style: TextStyle(
                        fontFamily: 'baloo da 2', fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),
                  ),
                ),
                Tab(
                  child: Text(
                    'Shipping',
                    style: TextStyle(
                        fontFamily: 'baloo da 2', fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),
                  ),
                ),
                Tab(
                  child: Text(
                    'Delivered',
                    style: TextStyle(
                        fontFamily: 'baloo da 2', fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),
                  ),
                ),
                Tab(
                  child: Text(
                    'Cancelled',
                    style: TextStyle(
                        fontFamily: 'baloo da 2', fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            )),
        body: const TabBarView(
          children: [
            ProcessingOrders(),
            ShippingOrders(),
            DeliveredOrders(),
            CancelledOrders()
          ],
        ),
      ),
      
    );
  }
}